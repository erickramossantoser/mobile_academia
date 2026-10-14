class Pessoa {
  final String nome;
  final String identificacao;
  final DateTime dataEntrada;
  DateTime? dataSaida;

  Pessoa({
    required this.nome,
    required this.identificacao,
    required this.dataEntrada,
  });

  // O cadastro já registra a entrada. Sem data de saída, a pessoa está presente.
  bool get noAmbiente => dataSaida == null;
}
