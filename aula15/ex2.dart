import 'package:flutter/material.dart';

void main() {
  runApp(const Exercicio2App());
}

class Exercicio2App extends StatelessWidget {
  const Exercicio2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercício 2 - Classificação',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const TelaClassificacao(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Partida {
  final String timeA;
  final String timeB;
  final TextEditingController golsAController = TextEditingController();
  final TextEditingController golsBController = TextEditingController();

  Partida(this.timeA, this.timeB);
}

class TelaClassificacao extends StatefulWidget {
  const TelaClassificacao({super.key});

  @override
  State<TelaClassificacao> createState() => _TelaClassificacaoState();
}

class _TelaClassificacaoState extends State<TelaClassificacao> {
  final List<TextEditingController> _timesControllers =
      List.generate(4, (_) => TextEditingController());
  
  List<String> _times = [];
  List<Partida> _partidas = [];
  List<MapEntry<String, int>> _classificacao = [];
  int _etapaAtual = 1;

  void _avancarParaJogos() {
    _times = _timesControllers
        .map((controller) => controller.text.trim())
        .where((nome) => nome.isNotEmpty)
        .toList();

    if (_times.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha os 4 times.')),
      );
      return;
    }

    _partidas.clear();
    for (int i = 0; i < _times.length; i++) {
      for (int j = i + 1; j < _times.length; j++) {
        _partidas.add(Partida(_times[i], _times[j]));
      }
    }

    setState(() => _etapaAtual = 2);
  }

  void _calcularResultado() {
    Map<String, int> pontuacao = {for (var time in _times) time: 0};

    for (var partida in _partidas) {
      int golsA = int.tryParse(partida.golsAController.text) ?? 0;
      int golsB = int.tryParse(partida.golsBController.text) ?? 0;

      if (golsA > golsB) {
        pontuacao[partida.timeA] = pontuacao[partida.timeA]! + 3;
      } else if (golsB > golsA) {
        pontuacao[partida.timeB] = pontuacao[partida.timeB]! + 3;
      } else {
        pontuacao[partida.timeA] = pontuacao[partida.timeA]! + 1;
        pontuacao[partida.timeB] = pontuacao[partida.timeB]! + 1;
      }
    }

    var listaOrdenada = pontuacao.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    setState(() {
      _classificacao = listaOrdenada;
      _etapaAtual = 3;
    });
  }

  void _reiniciar() {
    for (var controller in _timesControllers) controller.clear();
    setState(() => _etapaAtual = 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fase de Grupos'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_etapaAtual == 1) _buildCadastroTimes(),
            if (_etapaAtual == 2) _buildPlacares(),
            if (_etapaAtual == 3) _buildResultadoFinal(),
          ],
        ),
      ),
    );
  }

  Widget _buildCadastroTimes() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('1. Cadastre os Times', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...List.generate(4, (index) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextField(
              controller: _timesControllers[index],
              decoration: InputDecoration(labelText: 'Time ${index + 1}', border: const OutlineInputBorder()),
            ),
          )),
          const Spacer(),
          ElevatedButton(onPressed: _avancarParaJogos, child: const Text('Avançar para Jogos')),
        ],
      ),
    );
  }

  Widget _buildPlacares() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('2. Insira os Gols', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _partidas.length,
              itemBuilder: (context, index) {
                var p = _partidas[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: Text(p.timeA, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold))),
                        const SizedBox(width: 8),
                        SizedBox(width: 45, child: TextField(controller: p.golsAController, keyboardType: TextInputType.number, textAlign: TextAlign.center, decoration: const InputDecoration(border: OutlineInputBorder()))),
                        const Text(' X '),
                        SizedBox(width: 45, child: TextField(controller: p.golsBController, keyboardType: TextInputType.number, textAlign: TextAlign.center, decoration: const InputDecoration(border: OutlineInputBorder()))),
                        const SizedBox(width: 8),
                        Expanded(child: Text(p.timeB, style: const TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(onPressed: _calcularResultado, child: const Text('Ver Classificados')),
        ],
      ),
    );
  }

  Widget _buildResultadoFinal() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('3. Times Classificados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _classificacao.length,
              itemBuilder: (context, index) {
                bool passou = index < 2;
                var time = _classificacao[index];
                return ListTile(
                  leading: Icon(passou ? Icons.check_circle : Icons.cancel, color: passou ? Colors.green : Colors.red),
                  title: Text(time.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text('${time.value} pts', style: const TextStyle(fontSize: 16)),
                  tileColor: passou ? Colors.green.withOpacity(0.1) : null,
                );
              },
            ),
          ),
          ElevatedButton(onPressed: _reiniciar, child: const Text('Reiniciar Simulador')),
        ],
      ),
    );
  }
}