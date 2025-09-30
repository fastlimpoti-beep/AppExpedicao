part of 'separacao_bloc.dart';

abstract class SeparacaoEvent extends Equatable {
  const SeparacaoEvent();
  @override
  List<Object> get props => [];
}

class SelecionarSeparador extends SeparacaoEvent {
  final String separador;
  const SelecionarSeparador(this.separador);

  @override
  List<Object> get props => [separador];
}

class IniciarSeparacao extends SeparacaoEvent {}

class FinalizarSeparacao extends SeparacaoEvent {}

class CarregarProdutosSeparacao extends SeparacaoEvent {
  final int pedidoId;

  const CarregarProdutosSeparacao(this.pedidoId);
}
