import 'package:app_separacao/bloc/blocs/teste_bloc.dart';
import 'package:app_separacao/utils/dialog_helper.dart';
import 'package:app_separacao/views/nova/bloc.dart';
import 'package:app_separacao/views/nova/bloc_cliente.dart';
import 'package:app_separacao/views/nova/bloc_obs.dart';
import 'package:app_separacao/views/nova/bloc_tabela.dart';
import 'package:flutter/material.dart';

class TelaPedido extends StatefulWidget {
  final int pedidoId;

  const TelaPedido({super.key, required this.pedidoId});

  @override
  State<TelaPedido> createState() => _TelaPedidoState();
}

class _TelaPedidoState extends State<TelaPedido> {
  late final TesteBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = TesteBloc();
  }

  @override
  void dispose() {
    bloc.dispose(); // ← importante para fechar o stream
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Orçamento: ${widget.pedidoId}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => DialogHelper().mostrarConfirmacaoVoltar(context),
          ),
          backgroundColor: const Color.fromRGBO(254, 121, 0, 1),
        ),
        body: Column(
          children: [
            // Parte superior: TabBar + TabBarView (40%)
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  TabBar(
                    labelColor: const Color.fromRGBO(254, 121, 0, 1),
                    unselectedLabelColor: Colors.black,
                    indicatorColor: const Color.fromRGBO(254, 121, 0, 1),
                    tabs: [
                      Tab(text: 'Cliente'),
                      Tab(text: 'Observação'),
                      Tab(text: 'Separação'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ClienteTab(
                            pedidoId: widget.pedidoId), // Dados do cliente
                        ObservacaoTab(
                            pedidoId: widget.pedidoId), // Texto da observação
                        BlocPage(bloc: bloc), // Sua tela Bloc
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Parte inferior: Lista de produtos (60%)
            Expanded(
              flex: 6,
              child: TabelaProdutos(
                pedidoId: widget.pedidoId,
                bloc: bloc,
              ), // Lista vinda do servidor
            ),
          ],
        ),
      ),
    );
  }
}
