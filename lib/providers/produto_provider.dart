import 'package:app_separacao/models/produto.dart';
import 'package:app_separacao/services/produto_service.dart';
import 'package:flutter/material.dart';

class ProdutoProvider extends ChangeNotifier {
  final ProdutoService _service = ProdutoService();

  List<Produto> _produtos = [];
  List<Produto> get produtos => _produtos;

  /// Carrega todos os produtos de um pedido
  Future<void> carregarProdutos(int pedidoId) async {
    _produtos = await _service.carregarProdutos(pedidoId);
    notifyListeners();
  }

  /// Insere novo produto
  Future<int> adicionarProduto(Produto produto) async {
    final id = await _service.inserirProduto(produto);
    _produtos.add(produto..id = id); // atualiza estado em memória
    notifyListeners();
    return id;
  }

  /// Atualiza status de produtos (ex: separado ou não)
  Future<void> atualizarProdutosSeparados({
    required int pedidoId,
    required List<Map<String, dynamic>> produtosAtualizados,
  }) async {
    await _service.atualizarProdutosSeparados(
      pedidoId: pedidoId,
      produtosAtualizados: produtosAtualizados,
    );
    await carregarProdutos(
        pedidoId); // recarrega do banco para manter consistência
  }

  /// Busca produto por ID dentro do estado
  Produto? getProdutoById(int id) {
    try {
      return _produtos.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
