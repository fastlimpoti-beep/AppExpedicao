import 'package:app_separacao/models/produto.dart';
import 'package:app_separacao/utils/dialog_helper.dart';
import 'package:flutter/material.dart';

class TabelaPage extends StatelessWidget {
  final List<Produto> produtos;
  final dynamic inicio;
  final dynamic fim;
  final dynamic separador;
  final Function(List<Produto>) onProdutosChange;
  const TabelaPage({
    super.key,
    required this.produtos,
    required this.onProdutosChange,
    this.inicio,
    this.separador,
    this.fim,
  });

  @override
  Widget build(BuildContext context) {
    DialogHelper dialogHelper = DialogHelper();
    if (produtos.isEmpty) {
      return const Center(child: Text("Nenhum produto encontrado."));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: DataTable(
                horizontalMargin: 0,
                columnSpacing: 0,
                dataRowMinHeight: 40,
                dataRowMaxHeight: 45,
                columns: [
                  DataColumn(label: celulaComBorda("Endereço", 100)),
                  DataColumn(label: celulaComBorda("Descrição", 280)),
                  DataColumn(label: celulaComBorda("Solicitado", 120)),
                  DataColumn(label: celulaComBorda("Separado", 100)),
                ],
                rows: produtos.map((item) {
                  Color? corLinha;
                  if (item.separado == 0) {
                    corLinha = Colors.white;
                  } else if (item.separado == item.solicitado) {
                    corLinha = Colors.green.shade100;
                  } else if (item.separado! < item.solicitado &&
                      item.motivo!.trim().isNotEmpty) {
                    corLinha = Colors.yellow.shade100;
                  } else if (item.separado! < item.solicitado &&
                      item.motivo!.trim().isEmpty) {
                    corLinha = Colors.red.shade100;
                  }

                  return DataRow(
                    color: WidgetStateProperty.resolveWith((_) => corLinha),
                    cells: [
                      DataCell(
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                // adiciona a borda inferior
                                color: Colors.grey,
                                width: 0.5,
                              ),
                              right: BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ), // separador
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          alignment: Alignment.center,
                          child: Text(item.endereco.toString()),
                        ),
                      ),
                      DataCell(
                        InkWell(
                          onTap: () {
                            if (inicio == null && separador == null ||
                                separador == '') {
                              dialogHelper.mostrarAlerta(
                                context,
                                'O scanner só será liberado após iniciar a separação e selecionar o separador.',
                              );

                              return;
                            }
                            dialogHelper.showDescricaoDialog(context, item);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  // adiciona a borda inferior
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                                right: BorderSide(
                                  color: Colors.grey,
                                  width: 0.5,
                                ), // separador
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            alignment: Alignment.center,
                            child: Text(
                              limitarTexto(item.descricao.toString(), 35),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                // adiciona a borda inferior
                                color: Colors.grey,
                                width: 0.5,
                              ),
                              right: BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ), // separador
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          alignment: Alignment.center,
                          child: Text(item.solicitado.toString()),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: 100,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 10,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (inicio != null && fim != null) {
                                dialogHelper.mostrarAlerta(
                                  context,
                                  'Itens não podem ser editados após a finalização da separação.',
                                );
                              }
                            },
                            child: AbsorbPointer(
                              absorbing: inicio != null &&
                                  fim != null, // ← bloqueia interação
                              child: InkWell(
                                onTap: () => _editarSeparado(context, item),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.separado.toString(),
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget celulaComBorda(String texto, double largura) {
    return Container(
      width: largura,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey, width: 0.5),
          top: BorderSide(color: Colors.grey, width: 0.5),
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Text(
        texto,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _editarSeparado(BuildContext context, Produto item) {
    DialogHelper dialogHelper = DialogHelper();
    if (inicio == null && separador == null || separador == '') {
      dialogHelper.mostrarAlerta(
        context,
        'Para alterar os itens separados, é necessário iniciar a separação e selecionar o separador.',
      );

      return;
    }

    final controller = TextEditingController(
      text: item.separado == 0 ? '' : item.separado.toString(),
    );
    final motivoController = TextEditingController(text: item.motivo ?? '');
    final focusNode = FocusNode();

    showDialog(
      context: context,
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          focusNode.requestFocus();
        });

        return AlertDialog(
          title: const Text("Editar Separado"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantidade separada',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: motivoController,
                decoration: const InputDecoration(
                  labelText: 'Motivo (se necessário)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                final novoValor = int.tryParse(controller.text);
                if (novoValor! > item.solicitado) {
                  Navigator.pop(context);
                  dialogHelper.mostrarAlerta(
                    context,
                    'A quantidade separada não pode exceder a quantidade solicitada.',
                  );

                  return;
                }
                if (novoValor < item.solicitado &&
                    motivoController.text == '') {
                  dialogHelper.mostrarAlerta(
                    context,
                    'Separação menor que o solicitado. Adicione um motivo para confirmar este produto.',
                  );
                  return;
                }
                item.separado = novoValor;
                item.motivo = motivoController.text.trim();

                onProdutosChange(produtos); // ← atualiza no pai
                Navigator.pop(context);
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }
}

String limitarTexto(String texto, int tamanho) {
  return texto.length > tamanho ? '${texto.substring(0, tamanho)}...' : texto;
}
