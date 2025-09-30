import 'package:app_separacao/bloc/blocs/teste_bloc.dart';
import 'package:app_separacao/bloc/blocs/teste_event.dart';
import 'package:app_separacao/bloc/blocs/teste_state.dart';
import 'package:flutter/material.dart';

class BlocPage extends StatefulWidget {
  final TesteBloc bloc;

  const BlocPage({super.key, required this.bloc});

  @override
  State<BlocPage> createState() => _BlocPageState();
}

class _BlocPageState extends State<BlocPage> {
  final List<String> separadores = ['Vírgula', 'Ponto', 'Traço'];

  @override
  void initState() {
    super.initState();
    widget.bloc
        .emitirEstadoAtual(); // garante que os dados sejam reemitidos ao voltar
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<SeparacaoState>(
        stream: widget.bloc.outputSeparacao,
        builder: (context, snapshot) {
          final state = snapshot.data;

          final inicio = state?.inicio;
          final separador = state?.separador;
          final fim = state?.fim;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      widget.bloc.inputSeparacao.add(InicioSeparacao());
                    },
                    child: const Text('Iniciar Separação'),
                  ),
                  if (inicio != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text('Início: $inicio'),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  DropdownButton<String>(
                    hint: const Text('Selecionar Separador'),
                    value: separador,
                    items: separadores.map((s) {
                      return DropdownMenuItem<String>(
                        value: s,
                        child: Text(s),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        widget.bloc.inputSeparacao.add(
                          SeparadorSeparacao(separador: value),
                        );
                      }
                    },
                  ),
                  if (separador != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text('Separador: $separador'),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      widget.bloc.inputSeparacao.add(FimSeparacao());
                    },
                    child: const Text('Finalizar Separação'),
                  ),
                  if (fim != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text('Fim: $fim'),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
