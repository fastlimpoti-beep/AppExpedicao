import 'package:flutter/material.dart';
import 'package:app_separacao/bloc/blocs/teste_bloc.dart';
import 'package:app_separacao/bloc/blocs/teste_event.dart';
import 'package:app_separacao/bloc/blocs/teste_state.dart';
import 'package:app_separacao/models/produto.dart';

class TabelaProdutos extends StatefulWidget {
  final TesteBloc bloc;
  final int pedidoId;

  const TabelaProdutos({super.key, required this.bloc, required this.pedidoId});

  @override
  State<TabelaProdutos> createState() => _TabelaProdutosState();
}

class _TabelaProdutosState extends State<TabelaProdutos> {
  @override
  void initState() {
    super.initState();
    widget.bloc.inputSeparacao.add(CarregarProdutosSeparacao(widget.pedidoId));
  }

  void _editarSeparado(BuildContext context, Produto item) {
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
                final novoValor =
                    int.tryParse(controller.text) ?? item.separado;
                final novoMotivo = motivoController.text.trim();
                widget.bloc.inputSeparacao.add(
                  AtualizarProdutoSeparado(
                    produtoId: item.id!,
                    separado: novoValor!,
                    motivo: novoMotivo,
                    pedidoId: widget.pedidoId,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SeparacaoState>(
      stream: widget.bloc.outputSeparacao,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data is! SeparacaoCompletaState) {
          return const Center(child: CircularProgressIndicator());
        }

        final state = snapshot.data as SeparacaoCompletaState;
        final produtos = state.produtos;

        if (produtos.isEmpty) {
          return const Center(child: Text("Nenhum produto encontrado."));
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 16,
            headingRowHeight: 40,
            columns: const [
              DataColumn(label: Text('Endereço')),
              DataColumn(label: Text('Descrição')),
              DataColumn(label: Text('Solicitado')),
              DataColumn(label: Text('Separado')),
            ],
            rows: produtos.map((produto) {
              return DataRow(cells: [
                DataCell(Text(produto.endereco)),
                DataCell(Text(produto.descricao)),
                DataCell(Text(produto.solicitado.toString())),
                DataCell(
                  Container(
                    width: 100,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                    child: InkWell(
                      onTap: () => _editarSeparado(context, produto),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            produto.separado.toString(),
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
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}
