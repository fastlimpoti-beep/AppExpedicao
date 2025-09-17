class Produto {
  final int? id;
  final int? pedidoId;
  final String endereco;
  final String descricao;
  final int solicitado;
  int? separado;
  String? motivo;
  String? imagemBase64;
  final String? imagemLocal;
  final String codigoBarras;

  Produto({
    this.id,
    required this.pedidoId,
    required this.endereco,
    required this.descricao,
    required this.solicitado,
    required this.separado,
    required this.motivo,
    this.imagemBase64,
    required this.imagemLocal,
    required this.codigoBarras,
  });
  factory Produto.vazio() {
    return Produto(
      id: null,
      descricao: '',
      solicitado: 0,
      separado: 0,
      motivo: '',
      pedidoId: null,
      endereco: '',
      imagemBase64: '',
      imagemLocal: '',
      codigoBarras: '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pedido_id': pedidoId,
      'endereco': endereco,
      'descricao': descricao,
      'solicitado': solicitado,
      'separado': separado,
      'motivo_nao_separacao': motivo,
      'imagem_base_64': imagemBase64,
      'imagem_local': imagemLocal,
      'codigo_barras': codigoBarras,
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      pedidoId: map['pedido_id'],
      endereco: map['endereco'],
      descricao: map['descricao'],
      solicitado: map['solicitado'],
      separado: map['separado'],
      motivo: map['motivo_nao_separacao'],
      imagemLocal: map['imagem_local'],
      imagemBase64: map['imagem_base_64'],
      codigoBarras: map['codigo_barras'],
    );
  }

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: _toInt(json['id']),
      pedidoId: _toInt(json['pedido_id']),
      endereco: json['endereco'] ?? '',
      descricao: json['descricao'] ?? '',
      solicitado: _toInt(json['solicitado'] ?? 0),
      separado: _toInt(json['separado'] ?? 0),
      motivo: json['motivo_nao_separacao'] ?? '',
      imagemLocal: json['imagem_local'] ?? '',
      imagemBase64: json['imagem_base_64'] ?? '',
      codigoBarras: json['codigo_barras'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pedido_id': pedidoId,
      'endereco': endereco,
      'descricao': descricao,
      'solicitado': solicitado,
      'separado': separado,
      'motivo_nao_separacao': motivo,
      'imagem_local': imagemLocal,
      'codigo_barras': codigoBarras,
    };
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
