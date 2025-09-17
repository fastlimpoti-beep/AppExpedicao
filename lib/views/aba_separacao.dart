import 'package:app_separacao/models/pedido.dart';
import 'package:app_separacao/models/produto.dart';
import 'package:app_separacao/utils/dialog_helper.dart';
import 'package:app_separacao/utils/separador_helper.dart';
import 'package:flutter/material.dart';

class SeparacaoAba extends StatelessWidget {
  final Pedido pedido;
  final List<Produto> produtos;
  final String? separadorSelecionado;
  final DateTime? inicio;
  final DateTime? fim;
  final Function(String?) onSeparadorChange;
  final Function(DateTime) onInicio;
  final Function(DateTime) onFim;
  const SeparacaoAba({
    super.key,
    required this.pedido,
    required this.produtos,
    this.separadorSelecionado,
    this.inicio,
    this.fim,
    required this.onSeparadorChange,
    required this.onInicio,
    required this.onFim,
  });

  @override
  Widget build(BuildContext context) {
    final separadores = [
      'Separador 1',
      'Separador 2',
      'Separador 3',
      'Separador 4',
    ];

    SeparadorHelper separacaoHelper = SeparadorHelper();
    DialogHelper dialogHelper = DialogHelper();

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Coluna do separador
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Separador:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  if (inicio == null) {
                    dialogHelper.mostrarAlerta(
                      context,
                      'Inicie a separação para habilitar o campo de separador.',
                    );
                  } else if (inicio != null && fim != null) {
                    dialogHelper.mostrarAlerta(
                      context,
                      'Separador não pode ser alterado após finalização da separação.',
                    );
                  }
                },
                child: AbsorbPointer(
                  absorbing: inicio == null || (inicio != null && fim != null),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: separadores.contains(separadorSelecionado)
                            ? separadorSelecionado
                            : null,
                        hint: const Text(
                          'Selecione o Separador',
                          style: TextStyle(color: Colors.grey),
                        ),
                        items: separadores.map((sep) {
                          return DropdownMenuItem(
                            value: sep,
                            child: Text(
                              sep,
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList(),
                        onChanged: onSeparadorChange,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(11, 125, 167, 1),
                  foregroundColor: Color.fromRGBO(255, 255, 255, 1),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // Borda arredondada
                  ),
                  elevation: 4, // Sombra
                ),
                onPressed: inicio == null
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirmar Início'),
                            content: const Text(
                              'Deseja iniciar a separação agora? O horário será registrado.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  final agora = DateTime.now();
                                  onInicio(agora);
                                  Navigator.pop(context);
                                  dialogHelper.mostrarConfirmacao(
                                    context,
                                    'Separação iniciada com sucesso!',
                                  );
                                },
                                child: const Text('Confirmar'),
                              ),
                            ],
                          ),
                        );
                      }
                    : null, // ← desativa o botão se já iniciou
                child: const Text('Iniciar Separação'),
              ),
              const SizedBox(height: 8),
              Text(
                inicio != null
                    ? 'Início: ${inicio!.day}/${inicio!.month}/${inicio!.year} ${inicio!.hour}:${inicio!.minute.toString().padLeft(2, '0')}'
                    : 'Início: --/--/---- --:--',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 35),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(11, 125, 167, 1),
                  foregroundColor: Color.fromRGBO(255, 255, 255, 1),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // Borda arredondada
                  ),
                  elevation: 4, // Sombra
                ),
                onPressed: fim == null
                    ? () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text('Confirmar Finalização'),
                            content: const Text(
                              'Tem certeza que deseja finalizar a separação?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final produtosComErro = produtos
                                      .where(
                                        (p) =>
                                            p.separado! < p.solicitado &&
                                            (p.motivo == null ||
                                                p.motivo!.trim().isEmpty),
                                      )
                                      .toList();

                                  Navigator.pop(dialogContext);

                                  if (inicio == null) {
                                    dialogHelper.mostrarAlerta(
                                      context,
                                      'A separação ainda não foi iniciada. Ação indisponível.',
                                    );

                                    return;
                                  }

                                  if (separadorSelecionado == null ||
                                      separadorSelecionado!.isEmpty) {
                                    dialogHelper.mostrarAlerta(
                                      context,
                                      'Selecione um separador antes de finalizar a separação.',
                                    );

                                    return;
                                  }
                                  if (produtosComErro.isNotEmpty) {
                                    final nomes = produtosComErro
                                        .map((p) => '- ${p.descricao}')
                                        .join(
                                          '\n',
                                        ); // quebra de linha entre os produtos

                                    dialogHelper.mostrarAlerta(
                                      context,
                                      'Os seguintes produtos estão com separação menor que o solicitado e/ou sem motivo informado:\n$nomes',
                                    );

                                    return;
                                  }

                                  final fimAgora = DateTime.now();
                                  onFim(fimAgora);

                                  await separacaoHelper.confirmarFinalizacao(
                                    context: context,
                                    pedido: pedido,
                                    produtos: produtos,
                                    separador: separadorSelecionado,
                                    inicio: inicio!,
                                    fim: fimAgora,
                                  );
                                },
                                child: const Text('Confirmar'),
                              ),
                            ],
                          ),
                        );
                      }
                    : null, // ← desativa o botão se fim já foi registrado
                child: const Text('Finalizar Separação'),
              ),
              const SizedBox(height: 8),
              Text(
                fim != null
                    ? 'Fim: ${fim!.day}/${fim!.month}/${fim!.year} ${fim!.hour}:${fim!.minute.toString().padLeft(2, '0')}'
                    : 'Fim: --/--/---- --:--',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
