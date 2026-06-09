import 'package:flutter/material.dart';

void main() {
  runApp(const Exercicio1App());
}

class Exercicio1App extends StatelessWidget {
  const Exercicio1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercício 1 - Jogos',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const TelaJogos(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TelaJogos extends StatefulWidget {
  const TelaJogos({super.key});

  @override
  State<TelaJogos> createState() => _TelaJogosState();
}

class _TelaJogosState extends State<TelaJogos> {
  final List<TextEditingController> _timesControllers =
      List.generate(4, (_) => TextEditingController());
  
  List<String> _partidas = [];

  void _gerarPartidas() {
    List<String> times = _timesControllers
        .map((controller) => controller.text.trim())
        .where((nome) => nome.isNotEmpty)
        .toList();

    if (times.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha o nome dos 4 times.')),
      );
      return;
    }

    List<String> novasPartidas = [];
    // Combina todos os times para gerar os jogos possíveis
    for (int i = 0; i < times.length; i++) {
      for (int j = i + 1; j < times.length; j++) {
        novasPartidas.add('${times[i]} x ${times[j]}');
      }
    }

    setState(() {
      _partidas = novasPartidas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerador de Partidas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Digite o nome dos 4 times:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: _timesControllers[index],
                  decoration: InputDecoration(
                    labelText: 'Time ${index + 1}',
                    border: const OutlineInputBorder(),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _gerarPartidas,
              child: const Text('Mostrar Jogos Possíveis'),
            ),
            const Divider(height: 32, thickness: 2),
            if (_partidas.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _partidas.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.sports_soccer),
                        title: Text(_partidas[index], 
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}