import 'package:app_separacao/models/cliente.dart';
import 'package:app_separacao/models/pedido.dart';
import 'package:app_separacao/database/db_helper.dart';

class PedidoService {
  static Future<int> inserirPedido(Pedido pedido) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('Pedidos', pedido.toMap());
  }

  Future<void> atualizarPedido({
    required int? pedidoId,
    required String separador,
    required String inicio,
    required String fim,
  }) async {
    final db = await DatabaseHelper.instance.database;

    await db.update(
      'Pedidos',
      {'separador': separador, 'inicio': inicio, 'fim': fim},
      where: 'id = ?',
      whereArgs: [pedidoId],
    );
  }

  Future<void> atualizarProdutosSeparados({
    required int pedidoId,
    required List<Map<String, dynamic>> produtosAtualizados,
  }) async {
    try {
      final db = await DatabaseHelper.instance.database;

      for (var produto in produtosAtualizados) {
        await db.update(
          'Produtos',
          {'separado': produto['separado']},
          where: 'id = ? AND pedido_id = ?',
          whereArgs: [produto['id'], pedidoId],
        );
      }

      //print('Produtos do pedido $pedidoId atualizados com sucesso!');
    } catch (e) {
      //   print('Erro ao atualizar produtos do pedido $pedidoId: $e');
    }
  }

  static Future<Map<String, dynamic>?> buscarPedidoPorId(int id) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('Pedidos', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<Pedido?> carregarPedido(int pedidoId) async {
    final data = await PedidoService.buscarPedidoPorId(pedidoId);
    if (data != null) {
      return Pedido.fromMap(data);
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> listarPedidoComProdutosPorId(
    int pedidoId,
  ) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.rawQuery(
      '''
      SELECT 
        p.id as pedido_id,
        p.numero,
        p.cliente,
        p.endereco as pedido_endereco,
        p.telefone,
        p.email,
        p.comprador,
        p.estoque,
        p.observacoes,
        p.data_criacao,
        p.separador,
        p.inicio,
        p.fim,
        pr.id as produto_id,
        pr.endereco as produto_endereco,
        pr.descricao,
        pr.motivo_nao_separacao,
        pr.solicitado,
        pr.separado,
        pr.imagem_path,
        pr.codigo_barras
      FROM Pedidos p
      LEFT JOIN Produtos pr ON p.id = pr.pedido_id
      WHERE p.id = ?
    ''',
      [pedidoId],
    );

    return result;
  }

  Future<Cliente> getClienteDoPedido(int pedidoId) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'Pedidos',
      where: 'id = ?',
      whereArgs: [pedidoId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final row = result.first;
      return Cliente(
        nome: row['cliente'] as String? ?? '',
        endereco: row['endereco'] as String? ?? '',
        telefone: row['telefone'] as String? ?? '',
        email: row['email'] as String? ?? '',
        comprador: row['comprador'] as String? ?? '',
        estoque: row['estoque'] as String? ?? '',
      );
    } else {
      throw Exception('Pedido não encontrado');
    }
  }

  Future<String> getObservacaoDoPedido(int pedidoId) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'Pedidos',
      columns: ['observacoes'],
      where: 'id = ?',
      whereArgs: [pedidoId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['observacoes'] as String? ?? '';
    } else {
      throw Exception('Pedido não encontrado');
    }
  }
}
