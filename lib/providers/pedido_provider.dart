import 'package:app_separacao/models/pedido.dart';
import 'package:app_separacao/services/pedido_service.dart';
import 'package:flutter/material.dart';

class PedidoProvider extends ChangeNotifier {
  final PedidoService _service = PedidoService();

  Pedido? _pedido;
  Pedido? get pedido => _pedido;

  List<Map<String, dynamic>> _pedidoComProdutos = [];
  List<Map<String, dynamic>> get pedidoComProdutos => _pedidoComProdutos;

  /// Carrega apenas o pedido
  Future<void> carregarPedido(int pedidoId) async {
    _pedido = await _service.carregarPedido(pedidoId);
    notifyListeners();
  }

  /// Insere pedido novo
  Future<int> adicionarPedido(Pedido pedido) async {
    final id = await PedidoService.inserirPedido(pedido);
    _pedido = pedido..id = id; // atualiza estado interno com id gerado
    notifyListeners();
    return id;
  }

  /// Atualiza os dados principais do pedido
  Future<void> atualizarPedido({
    required int pedidoId,
    required String separador,
    required String inicio,
    required String fim,
  }) async {
    await _service.atualizarPedido(
      pedidoId: pedidoId,
      separador: separador,
      inicio: inicio,
      fim: fim,
    );
    await carregarPedido(pedidoId); // recarrega atualizado
  }

  /// Atualiza produtos do pedido
  Future<void> atualizarProdutosSeparados({
    required int pedidoId,
    required List<Map<String, dynamic>> produtosAtualizados,
  }) async {
    await _service.atualizarProdutosSeparados(
      pedidoId: pedidoId,
      produtosAtualizados: produtosAtualizados,
    );
    await carregarPedidoComProdutos(pedidoId); // recarrega atualizado
  }

  /// Carrega pedido junto com seus produtos
  Future<void> carregarPedidoComProdutos(int pedidoId) async {
    _pedidoComProdutos =
        await PedidoService.listarPedidoComProdutosPorId(pedidoId);
    notifyListeners();
  }
}
