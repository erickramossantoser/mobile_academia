import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ControleLotacao(),
    );
  }
}

class ControleLotacao extends StatefulWidget {
  const ControleLotacao({super.key});

  @override
  State<ControleLotacao> createState() => _ControleLotacaoState();
}

class _ControleLotacaoState extends State<ControleLotacao> {
  int pessoas = 0;
  final int capacidadeMaxima = 20;

  // Getters usados para verificar a situação atual da academia.
  bool get estaVazia => pessoas == 0;
  bool get estaLotada => pessoas == capacidadeMaxima;

  String get situacao {
    if (estaLotada) {
      return 'Academia lotada';
    } else if (pessoas >= 16) {
      return 'Atenção: academia quase cheia';
    } else {
      return 'Pode entrar';
    }
  }

  void entrou() {
    if (!estaLotada) {
      setState(() {
        pessoas++;
      });
    }
  }

  void saiu() {
    if (!estaVazia) {
      setState(() {
        pessoas--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Controle de Lotação',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/academia_bg.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color.fromRGBO(0, 0, 0, 0.25),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ACADEMIA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Capacidade máxima: $capacidadeMaxima pessoas',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 36),
            const Text(
              'Pessoas no local',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Text(
              pessoas.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 90,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              situacao,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: estaVazia ? null : saiu,
                  style: TextButton.styleFrom(
                    backgroundColor: estaVazia
                        ? Colors.white.withAlpha(90)
                        : Colors.white,
                    fixedSize: const Size(120, 48),
                  ),
                  child: const Text(
                    'SAIU',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: estaLotada ? null : entrou,
                  style: TextButton.styleFrom(
                    backgroundColor: estaLotada
                        ? Colors.white.withAlpha(90)
                        : Colors.white,
                    fixedSize: const Size(120, 48),
                  ),
                  child: const Text(
                    'ENTROU',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
