import 'package:app_separacao/models/produto.dart';

abstract class SeparacaoState {
  final String? inicio;
  final String? separador;
  final String? fim;

  const SeparacaoState({this.inicio, this.separador, this.fim});
}

class SeparacaoCompletaState extends SeparacaoState {
  final List<Produto> produtos;

  const SeparacaoCompletaState({
    required this.produtos,
    String? inicio,
    String? separador,
    String? fim,
  }) : super(inicio: inicio, separador: separador, fim: fim);
}

class ProdutoEncontradoPorCodigoState extends SeparacaoState {
  final Produto produto;

  const ProdutoEncontradoPorCodigoState({
    required this.produto,
    String? inicio,
    String? separador,
    String? fim,
  }) : super(inicio: inicio, separador: separador, fim: fim);
}
