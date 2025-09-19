class Pedido {
  int? id;
  final String numero;
  final String cliente;
  final String endereco;
  final String telefone;
  final String email;
  final String comprador;
  final String estoque;
  final String observacoes;
  final String dataCriacao;
  String separador;
  String inicio;
  String fim;

  Pedido({
    this.id,
    required this.numero,
    required this.cliente,
    required this.endereco,
    required this.telefone,
    required this.email,
    required this.comprador,
    required this.estoque,
    required this.observacoes,
    required this.dataCriacao,
    required this.separador,
    required this.inicio,
    required this.fim,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numero': numero,
      'cliente': cliente,
      'endereco': endereco,
      'telefone': telefone,
      'email': email,
      'comprador': comprador,
      'estoque': estoque,
      'observacoes': observacoes,
      'data_criacao': dataCriacao,
      'separador': separador,
      'inicio': inicio,
      'fim': fim,
    };
  }

  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      id: map['id'],
      numero: map['numero'],
      cliente: map['cliente'],
      endereco: map['endereco'],
      telefone: map['telefone'],
      email: map['email'],
      comprador: map['comprador'],
      estoque: map['estoque'],
      observacoes: map['observacoes'],
      dataCriacao: map['data_criacao'],
      separador: map['separador'],
      inicio: map['inicio'],
      fim: map['fim'],
    );
  }
  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      numero: json['numero'] ?? '',
      cliente: json['cliente'] ?? '',
      endereco: json['endereco'] ?? '',
      telefone: json['telefone'] ?? '',
      email: json['email'] ?? '',
      comprador: json['comprador'] ?? '',
      estoque: json['estoque'] ?? '',
      observacoes: json['observacoes'] ?? '',
      dataCriacao: json['data_criacao'] ?? '',
      separador: json['separador'] ?? '',
      inicio: json['inicio'] ?? '',
      fim: json['fim'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero': numero,
      'cliente': cliente,
      'endereco': endereco,
      'telefone': telefone,
      'email': email,
      'comprador': comprador,
      'estoque': estoque,
      'observacoes': observacoes,
      'data_criacao': dataCriacao,
      'separador': separador,
      'inicio': inicio,
      'fim': fim,
    };
  }
}
