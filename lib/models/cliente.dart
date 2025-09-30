class Cliente {
  final String? nome;
  final String? endereco;
  final String? telefone;
  final String email;
  final String comprador;
  final String estoque;

  Cliente({
    required this.nome,
    required this.endereco,
    required this.telefone,
    required this.email,
    required this.comprador,
    required this.estoque,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      nome: json['cliente'] ?? '',
      endereco: json['endereco'] ?? '',
      telefone: json['telefone'] ?? '',
      email: json['email'] ?? '',
      comprador: json['comprador'] ?? '',
      estoque: json['estoque'] ?? '',
    );
  }
}
