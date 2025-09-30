import 'dart:async';
import 'package:app_separacao/bloc/blocs/teste_event.dart';
import 'package:app_separacao/bloc/blocs/teste_state.dart';
import 'package:app_separacao/models/produto.dart';
import 'package:app_separacao/services/produto_service.dart';

class TesteBloc {
  final _inputController = StreamController<SeparacaoEvent>();
  final _outputController = StreamController<SeparacaoState>.broadcast();

  String? _inicio;
  String? _separador;
  String? _fim;
  List<Produto> _produtos = [];

  SeparacaoCompletaState? _ultimoEstado;

  final ProdutoService produtoService = ProdutoService();

  Sink<SeparacaoEvent> get inputSeparacao => _inputController.sink;
  Stream<SeparacaoState> get outputSeparacao => _outputController.stream;

  TesteBloc() {
    _ultimoEstado = const SeparacaoCompletaState(produtos: []);
    _outputController.add(_ultimoEstado!);
    _inputController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(SeparacaoEvent event) async {
    if (event is InicioSeparacao) {
      _inicio = DateTime.now().toString();
      _emitirEstadoCompleto();
    } else if (event is SeparadorSeparacao) {
      if (_inicio == null) return;
      _separador = event.separador;
      _emitirEstadoCompleto();
    } else if (event is FimSeparacao) {
      _fim = DateTime.now().toString();
      _emitirEstadoCompleto();
    } else if (event is CarregarProdutosSeparacao) {
      _produtos = await produtoService.carregarProdutos(event.pedidoId);
      _emitirEstadoCompleto();
    } else if (event is AtualizarProdutoSeparado) {
      final index = _produtos.indexWhere((p) => p.id == event.produtoId);
      if (index != -1) {
        _produtos[index].separado = event.separado;
        _produtos[index].motivo = event.motivo;
        _emitirEstadoCompleto();
      }
    }
  }

  void _emitirEstadoCompleto() {
    final novoEstado = SeparacaoCompletaState(
      produtos: _produtos,
      inicio: _inicio,
      separador: _separador,
      fim: _fim,
    );

    _ultimoEstado = novoEstado;
    _outputController.add(novoEstado);
  }

  void emitirEstadoAtual() {
    if (_ultimoEstado != null) {
      _outputController.add(_ultimoEstado!);
    }
  }

  void dispose() {
    _inputController.close();
    _outputController.close();
  }
}
