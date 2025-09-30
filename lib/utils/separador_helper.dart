import 'dart:convert';

import 'package:app_separacao/models/pedido.dart';
import 'package:app_separacao/models/produto.dart';
import 'package:app_separacao/services/json_service.dart';
import 'package:app_separacao/services/pedido_service.dart';
import 'package:app_separacao/services/produto_service.dart';
import 'package:app_separacao/views/home_page.dart';
import 'package:flutter/material.dart';

class SeparadorHelper {
  static Future<bool> salvarSeparacao({
    required BuildContext context,
    required Pedido pedido,
    required List<Produto> produtos,
    required String? separador,
    required DateTime inicio,
    required DateTime fim,
  }) async {
    PedidoService pedidoService = PedidoService();
    ProdutoService produtoService = ProdutoService();

    await pedidoService.atualizarPedido(
      pedidoId: pedido.id,
      separador: separador ?? 'teste',
      inicio: inicio.toString(),
      fim: fim.toString(),
    );

    pedido.separador = separador ?? 'teste';
    pedido.inicio = inicio.toString();
    pedido.fim = fim.toString();

    final produtosAtualizados = produtos.map((item) {
      return {
        'id': item.id,
        'separado': item.separado,
        'motivo_nao_separacao': item.motivo ?? '',
      };
    }).toList();

    await produtoService.atualizarProdutosSeparados(
      pedidoId: pedido.id,
      produtosAtualizados: produtosAtualizados,
    );

    final jsonFinal = json.encode({
      'pedido': pedido.toJson(),
      'produtos': produtos.map((p) => p.toJson()).toList(),
    });

    await JsonService.salvarJsonComoArquivo(jsonFinal, "Arquivo_TESTE.json");

    return true;
  }

  Future<void> confirmarFinalizacao({
    required BuildContext context,
    required Pedido pedido,
    required List<Produto> produtos,
    required String? separador,
    required DateTime inicio,
    required DateTime fim,
  }) async {
    final sucesso = await salvarSeparacao(
      context: context,
      pedido: pedido,
      produtos: produtos,
      separador: separador,
      inicio: inicio,
      fim: fim,
    );

    if (!sucesso) return;

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Finalizando...'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Enviando dados para o servidor...'),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 5));
    if (!context.mounted) return;

    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Separação Finalizada'),
        content: const Text('Os dados foram salvos com sucesso.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
