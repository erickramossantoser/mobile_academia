import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../models/pessoa.dart';

class PessoaItem extends StatelessWidget {
  final Pessoa pessoa;
  final VoidCallback onSaida;
  final VoidCallback onExcluir;

  const PessoaItem({
    super.key,
    required this.pessoa,
    required this.onSaida,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    final formato = DateFormat('dd/MM/yyyy HH:mm');
    final cor = pessoa.noAmbiente
        ? const Color(0xFF197546)
        : const Color(0xFF616161);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Slidable(
        key: ObjectKey(pessoa),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.55,
          children: [
            SlidableAction(
              onPressed: pessoa.noAmbiente ? (_) => onSaida() : null,
              backgroundColor: const Color(0xFFE48A13),
              foregroundColor: Colors.white,
              icon: Icons.logout,
              label: 'SAÍDA',
            ),
            SlidableAction(
              onPressed: (_) => onExcluir(),
              backgroundColor: const Color(0xFFC62828),
              foregroundColor: Colors.white,
              icon: Icons.delete_outline,
              label: 'EXCLUIR',
            ),
          ],
        ),
        child: Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.person, color: cor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pessoa.nome,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Matrícula: ${pessoa.identificacao}'),
                      Text('Entrada: ${formato.format(pessoa.dataEntrada)}'),
                      if (pessoa.dataSaida != null)
                        Text('Saída: ${formato.format(pessoa.dataSaida!)}'),
                      const SizedBox(height: 6),
                      Text(
                        pessoa.noAmbiente ? 'No ambiente' : 'Saiu',
                        style: TextStyle(
                          color: cor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.swipe_left,
                  size: 20,
                  color: Color(0xFF616161),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
