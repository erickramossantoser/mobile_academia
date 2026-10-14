import 'package:flutter/material.dart';

import '../models/pessoa.dart';
import '../widgets/pessoa_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nomeController = TextEditingController();
  final identificacaoController = TextEditingController();
  final List<Pessoa> pessoas = [];
  static const int capacidadeMaxima = 20;

  // A contagem vem da lista: excluir ou registrar saída não deixa o total errado.
  int get presentes => pessoas.where((pessoa) => pessoa.noAmbiente).length;
  bool get estaLotada => presentes >= capacidadeMaxima;

  String get situacao {
    if (estaLotada) return 'Academia lotada';
    if (presentes >= 16) return 'Atenção: academia quase cheia';
    return 'Pode entrar';
  }

  @override
  void dispose() {
    nomeController.dispose();
    identificacaoController.dispose();
    super.dispose();
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensagem)));
  }

  void cadastrarPessoa() {
    final nome = nomeController.text.trim();
    final identificacao = identificacaoController.text.trim();

    if (nome.isEmpty || identificacao.isEmpty) {
      mostrarMensagem('Preencha o nome e a matrícula.');
      return;
    }

    final jaEstaPresente = pessoas.any(
      (pessoa) =>
          pessoa.identificacao.toLowerCase() == identificacao.toLowerCase() &&
          pessoa.noAmbiente,
    );
    if (jaEstaPresente) {
      mostrarMensagem('Já existe uma pessoa no ambiente com essa matrícula.');
      return;
    }

    if (estaLotada) {
      mostrarMensagem('Não é possível registrar a entrada. Academia lotada!');
      return;
    }

    setState(() {
      pessoas.insert(
        0,
        Pessoa(
          nome: nome,
          identificacao: identificacao,
          dataEntrada: DateTime.now(),
        ),
      );
    });
    nomeController.clear();
    identificacaoController.clear();
    FocusScope.of(context).unfocus();
    mostrarMensagem('Pessoa cadastrada com sucesso!');
  }

  Future<bool> confirmar(String titulo, String mensagem) async {
    final resposta = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('CONFIRMAR'),
          ),
        ],
      ),
    );
    return resposta ?? false;
  }

  Future<void> registrarSaida(Pessoa pessoa) async {
    if (!pessoa.noAmbiente) {
      mostrarMensagem('A saída dessa pessoa já foi registrada.');
      return;
    }

    final confirmou = await confirmar(
      'Registrar saída?',
      'Deseja realmente registrar a saída de ${pessoa.nome}?',
    );
    if (!mounted ||
        !confirmou ||
        !pessoas.contains(pessoa) ||
        !pessoa.noAmbiente) {
      return;
    }

    setState(() {
      pessoa.dataSaida = DateTime.now();
    });
    mostrarMensagem('Saída registrada com sucesso!');
  }

  Future<void> excluirPessoa(Pessoa pessoa) async {
    final confirmou = await confirmar(
      'Excluir registro?',
      pessoa.noAmbiente
          ? 'Excluir ${pessoa.nome}? O registro será removido e a vaga será liberada.'
          : 'Deseja realmente excluir o registro de ${pessoa.nome}?',
    );
    if (!mounted || !confirmou || !pessoas.contains(pessoa)) return;

    setState(() {
      pessoas.remove(pessoa);
    });
    mostrarMensagem('Registro excluído com sucesso!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controle de Lotação 2.0')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/academia_bg.png'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Color(0xB3000000),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.fitness_center, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'ACADEMIA',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$presentes / $capacidadeMaxima',
                        key: const Key('contador'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Pessoas no ambiente',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        situacao,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: presentes >= 16
                              ? const Color(0xFFFFD180)
                              : const Color(0xFFB9F6CA),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    key: const Key('lista'),
                    padding: const EdgeInsets.all(16),
                    children: [
                      Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Registrar entrada',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                key: const Key('nome'),
                                controller: nomeController,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: 'Nome',
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                key: const Key('matricula'),
                                controller: identificacaoController,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => cadastrarPessoa(),
                                decoration: const InputDecoration(
                                  labelText: 'Matrícula',
                                  prefixIcon: Icon(Icons.badge_outlined),
                                ),
                              ),
                              const SizedBox(height: 12),
                              FilledButton.icon(
                                onPressed: cadastrarPessoa,
                                icon: const Icon(Icons.person_add_alt_1),
                                label: const Text('CADASTRAR ENTRADA'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Registros (${pessoas.length})',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Deslize um registro para a esquerda: saída ou exclusão.',
                      ),
                      const SizedBox(height: 12),
                      if (pessoas.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(
                            child: Text('Nenhuma pessoa cadastrada.'),
                          ),
                        ),
                      for (final pessoa in pessoas)
                        PessoaItem(
                          key: ObjectKey(pessoa),
                          pessoa: pessoa,
                          onSaida: () => registrarSaida(pessoa),
                          onExcluir: () => excluirPessoa(pessoa),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
