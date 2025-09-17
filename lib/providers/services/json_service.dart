import 'dart:io';

import 'package:app_separacao/models/pedido.dart';
import 'package:app_separacao/models/produto.dart';
import 'package:app_separacao/providers/database/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class JsonService {
  static Future<void> salvarJsonComoArquivo(
    String jsonFinal,
    String nomeArquivo,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$nomeArquivo.json';
      final file = File(filePath);

      await file.writeAsString(jsonFinal);
      // print('✅ Arquivo JSON salvo em: $filePath');
    } catch (e) {
      //  print('❌ Erro ao salvar JSON: $e');
    }
  }

  Future<void> enviarJsonParaServidor(String jsonFinal) async {
    final url = Uri.parse('https://seuservidor.com/api/pedidos');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonFinal,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // print(' JSON enviado com sucesso!');
        // print('Resposta do servidor: ${response.body}');
      } else {
        // print(' Erro ao enviar JSON: ${response.statusCode}');
        // print('Mensagem: ${response.body}');
      }
    } catch (e) {
      // print(' Falha na comunicação com o servidor: $e');
    }
  }

  Future<String?> salvarImagemBase64(String base64, String nomeArquivo) async {
    try {
      final dir = Directory(
        '${(await getApplicationDocumentsDirectory()).path}/imagens_produtos',
      );

      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final file = File('${dir.path}/$nomeArquivo');

      final bytes = base64Decode(base64);
      await file.writeAsBytes(bytes, flush: true);

      //  print("Imagem salva no seguinte caminho: ${file.path}");
      return file.path;
    } catch (e) {
      //   print('Erro ao salvar imagem base64: $e');
      return null;
    }
  }

  Future<void> importarPedidoDoJsonFromServer(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.191:8080/api'),
      );

      if (response.statusCode != 200) {
        throw Exception('Erro ao buscar dados: ${response.statusCode}');
      }

      final Map<String, dynamic> jsonData = json.decode(response.body);

      final Pedido pedido = Pedido.fromJson(jsonData['pedido']);
      final List<Produto> produtos = (jsonData['produtos'] as List)
          .map((p) => Produto.fromJson(p))
          .toList();

      final db = await DatabaseHelper.instance.database;

      await db.insert('Pedidos', pedido.toJson());

      for (var produto in produtos) {
        try {
          String? caminhoImagem;

          if (produto.imagemBase64!.isNotEmpty) {
            caminhoImagem = await salvarImagemBase64(
              produto.imagemBase64!,
              'produto_${produto.id}.jpg',
            );
          }

          final produtoAtualizado = Produto(
            id: produto.id,
            descricao: produto.descricao,
            solicitado: produto.solicitado,
            separado: produto.separado,
            motivo: produto.motivo,
            endereco: produto.endereco,
            imagemLocal: caminhoImagem ?? '',
            pedidoId: produto.pedidoId,
            codigoBarras: produto.codigoBarras,
          );

          await db.insert(
            'Produtos',
            produtoAtualizado.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        } catch (e) {
          // print('Erro ao inserir produto ${produto.id}: $e');
        }
      }

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Sucesso'),
          content: Text('✅ Pedido importado com sucesso!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      //  print('Pedido e produtos importados com sucesso!');
    } catch (e) {
      //  print('Erro geral na importação: $e');
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Erro'),
          content: Text('❌ Ocorreu um erro ao importar o pedido.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fechar'),
            ),
          ],
        ),
      );
    }
  }
}
