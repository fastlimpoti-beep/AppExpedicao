import 'dart:io';

import 'package:app_separacao/models/produto.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class DialogHelper {
  void showDescricaoDialog(BuildContext context, Produto item) {
    String? codigoLido; // Inicializa como null
    bool scannerAtivo = false;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Descrição",
      pageBuilder: (context, animation1, animation2) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: Material(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Descrição Completa',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      item.imagemLocal != null && item.imagemLocal!.isNotEmpty
                          ? Image.file(
                              File(item.imagemLocal!),
                              width: 200,
                              height: 200,
                              fit: BoxFit.contain,
                            )
                          : const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                      const SizedBox(height: 10),
                      Text(item.descricao),
                      const SizedBox(height: 10),
                      if (codigoLido != null)
                        Text(
                          'Código Lido: $codigoLido',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      const SizedBox(height: 10),
                      if (scannerAtivo)
                        SizedBox(
                          width: 500,
                          height: 300,
                          child: MobileScanner(
                            onDetect: (capture) {
                              final List<Barcode> barcodes = capture.barcodes;
                              for (final barcode in barcodes) {
                                final String? code = barcode.rawValue;
                                if (code != null) {
                                  setState(() {
                                    codigoLido = code;
                                    scannerAtivo = false;
                                  });
                                  break;
                                }
                              }
                            },
                          ),
                        ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                scannerAtivo = true;
                              });
                            },
                            child: const Text('Ler Código'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Fechar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<DateTime?> selecionarDataHora(
    BuildContext context,
    DateTime? dataAtual,
  ) async {
    final data = await showDatePicker(
      context: context,
      initialDate: dataAtual ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (data == null) return null;

    // Verifica se o widget ainda está montado antes de usar o context
    if (!context.mounted) return null;

    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(dataAtual ?? DateTime.now()),
    );

    if (hora == null) return null;

    return DateTime(data.year, data.month, data.day, hora.hour, hora.minute);
  }

  Future<bool> mostrarConfirmacaoVoltar(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false, // impede fechar tocando fora
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmar saída'),
              content: Text('Deseja realmente voltar e sair do pedido?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Sim, voltar'),
                ),
              ],
            );
          },
        ) ??
        false; // retorna false se o diálogo for fechado sem escolha
  }

  void mostrarAlerta(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text('❗ $mensagem', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void mostrarConfirmacao(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text('✅ $mensagem', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
