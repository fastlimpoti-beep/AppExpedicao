import 'package:app_separacao/models/produto.dart';
import 'package:app_separacao/database/db_helper.dart';

class ProdutoService {
  Future<int> inserirProduto(Produto produto) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('Produtos', produto.toMap());
  }

  Future<void> atualizarProdutosSeparados({
    required int? pedidoId,
    required List<Map<String, dynamic>> produtosAtualizados,
  }) async {
    final db = await DatabaseHelper.instance.database;

    for (var produto in produtosAtualizados) {
      await db.update(
        'Produtos',
        {
          'separado': produto['separado'],
          'motivo_nao_separacao': produto['motivo_nao_separacao'],
        },
        where: 'id = ? AND pedido_id = ?',
        whereArgs: [produto['id'], pedidoId],
      );
    }
  }

  Future<List<Produto>> carregarProdutos(int pedidoId) async {
    final data = await ProdutoService.buscarProdutosPorPedidoId(pedidoId);
    return data.map((item) => Produto.fromMap(item)).toList();
  }

  static Future<List<Map<String, dynamic>>> buscarProdutosPorPedidoId(
    int pedidoId,
  ) async {
    final db = await DatabaseHelper.instance.database;
    return await db.query(
      'Produtos',
      where: 'pedido_id = ?',
      whereArgs: [pedidoId],
    );
  }
}
