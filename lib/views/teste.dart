import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_separacao/bloc/separacao_bloc.dart';
import 'package:app_separacao/models/pedido.dart';
import 'package:app_separacao/models/produto.dart';
import 'package:app_separacao/utils/dialog_helper.dart';
import 'package:app_separacao/utils/separador_helper.dart';

class SeparacaoAba2 extends StatelessWidget {
  final Pedido pedido;
  final List<Produto> produtos;

  const SeparacaoAba2({
    super.key,
    required this.pedido,
    required this.produtos,
  });

  @override
  Widget build(BuildContext context) {
    final separadores = [
      'Separador 1',
      'Separador 2',
      'Separador 3',
      'Separador 4'
    ];
    final dialogHelper = DialogHelper();
    final separadorHelper = SeparadorHelper();

    return BlocBuilder<SeparacaoBloc, SeparacaoState>(
      builder: (context, state) {
        DateTime? inicio;
        DateTime? fim;
        String? separador;

        if (state is SeparacaoEmAndamento) {
          inicio = state.inicio;
          fim = state.fim;
          separador = state.separador;
        }

        return Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Coluna do separador
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Separador:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      if (inicio == null) {
                        dialogHelper.mostrarAlerta(context,
                            'Inicie a separação para habilitar o campo de separador.');
                      } else if (fim != null) {
                        dialogHelper.mostrarAlerta(context,
                            'Separador não pode ser alterado após finalização.');
                      }
                    },
                    child: AbsorbPointer(
                      absorbing: inicio == null || fim != null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: separadores.contains(separador)
                                ? separador
                                : null,
                            hint: const Text('Selecione o Separador',
                                style: TextStyle(color: Colors.grey)),
                            items: separadores.map((sep) {
                              return DropdownMenuItem(
                                  value: sep,
                                  child: Text(sep,
                                      style: const TextStyle(fontSize: 16)));
                            }).toList(),
                            onChanged: (valor) {
                              context
                                  .read<SeparacaoBloc>()
                                  .add(SelecionarSeparador(valor!));
                            },
                            icon: const Icon(Icons.arrow_drop_down),
                            dropdownColor: Colors.white,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

              // Coluna dos botões
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: inicio == null
                        ? () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirmar Início'),
                                content: const Text(
                                    'Deseja iniciar a separação agora?'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancelar')),
                                  ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<SeparacaoBloc>()
                                          .add(IniciarSeparacao());
                                      Navigator.pop(context);
                                      dialogHelper.mostrarConfirmacao(context,
                                          'Separação iniciada com sucesso!');
                                    },
                                    child: const Text('Confirmar'),
                                  ),
                                ],
                              ),
                            );
                          }
                        : null,
                    child: const Text('Iniciar Separação'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    inicio != null
                        ? 'Início: ${inicio.day}/${inicio.month}/${inicio.year} ${inicio.hour}:${inicio.minute.toString().padLeft(2, '0')}'
                        : 'Início: --/--/---- --:--',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 35),
                  ElevatedButton(
                    onPressed: fim == null
                        ? () {
                            showDialog(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text('Confirmar Finalização'),
                                content: const Text(
                                    'Tem certeza que deseja finalizar a separação?'),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext),
                                      child: const Text('Cancelar')),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final produtosComErro = produtos
                                          .where((p) =>
                                              p.separado! < p.solicitado &&
                                              (p.motivo == null ||
                                                  p.motivo!.trim().isEmpty))
                                          .toList();

                                      Navigator.pop(dialogContext);

                                      if (inicio == null) {
                                        dialogHelper.mostrarAlerta(context,
                                            'A separação ainda não foi iniciada.');
                                        return;
                                      }

                                      if (separador == null ||
                                          separador.isEmpty) {
                                        dialogHelper.mostrarAlerta(context,
                                            'Selecione um separador antes de finalizar.');
                                        return;
                                      }

                                      if (produtosComErro.isNotEmpty) {
                                        final nomes = produtosComErro
                                            .map((p) => '- ${p.descricao}')
                                            .join('\n');
                                        dialogHelper.mostrarAlerta(context,
                                            'Produtos com separação menor que o solicitado e/ou sem motivo:\n$nomes');
                                        return;
                                      }

                                      context
                                          .read<SeparacaoBloc>()
                                          .add(FinalizarSeparacao());

                                      await separadorHelper
                                          .confirmarFinalizacao(
                                        context: context,
                                        pedido: pedido,
                                        produtos: produtos,
                                        separador: separador,
                                        inicio: inicio,
                                        fim: DateTime.now(),
                                      );
                                    },
                                    child: const Text('Confirmar'),
                                  ),
                                ],
                              ),
                            );
                          }
                        : null,
                    child: const Text('Finalizar Separação'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fim != null
                        ? 'Fim: ${fim.day}/${fim.month}/${fim.year} ${fim.hour}:${fim.minute.toString().padLeft(2, '0')}'
                        : 'Fim: --/--/---- --:--',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
