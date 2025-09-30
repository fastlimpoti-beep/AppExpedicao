abstract class SeparacaoEvent {}

class InicioSeparacao extends SeparacaoEvent {
  // Evento sem parâmetros, pois o horário é gerado no Bloc
}

class SeparadorSeparacao extends SeparacaoEvent {
  final String separador;

  SeparadorSeparacao({required this.separador});
}

class FimSeparacao extends SeparacaoEvent {
  // Evento sem parâmetros, pois o horário é gerado no Bloc
}

class AtualizarProdutoSeparado extends SeparacaoEvent {
  final int produtoId;
  final int separado;
  final String motivo;
  final int pedidoId;

  AtualizarProdutoSeparado({
    required this.produtoId,
    required this.separado,
    required this.motivo,
    required this.pedidoId,
  });
}

class LerCodigoBarras extends SeparacaoEvent {
  final String codigoBarras;

  LerCodigoBarras(this.codigoBarras);
}

class CarregarProdutosSeparacao extends SeparacaoEvent {
  final int pedidoId;

  CarregarProdutosSeparacao(this.pedidoId);
}
