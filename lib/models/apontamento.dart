class Apontamento {
  final String setor;
  final String funcionario;
  final String ordem;
  final int quantidade;
  final DateTime dataHora;

  Apontamento({
    required this.setor,
    required this.funcionario,
    required this.ordem,
    required this.quantidade,
    required this.dataHora,
  });

  Map<String, dynamic> toJson() {
    return {
      "setor": setor,
      "funcionario": funcionario,
      "ordem": ordem,
      "quantidade": quantidade,
      "dataHora": dataHora.toIso8601String(),
    };
  }
}