import 'package:app_separacao/models/pedido.dart';
import 'package:app_separacao/models/produto.dart';
import 'package:app_separacao/providers/services/pedido_service.dart';
import 'package:app_separacao/providers/services/produto_service.dart';
import 'package:app_separacao/views/aba_cliente.dart';
import 'package:app_separacao/views/aba_observacao.dart';
import 'package:app_separacao/utils/dialog_helper.dart';
import 'package:app_separacao/views/aba_separacao.dart';
import 'package:app_separacao/views/tabela_produtos.dart';
import 'package:flutter/material.dart';

class AbasTestes extends StatefulWidget {
  final int pedidoId;
  final dynamic id;
  const AbasTestes({super.key, required this.pedidoId, required this.id});

  @override
  State<AbasTestes> createState() => _AbasTestesState();
}

class _AbasTestesState extends State<AbasTestes> with TickerProviderStateMixin {
  late TabController _tabController;

  Pedido? lpedido;
  List<Produto> lprodutos = [];
  String? separadorSelecionado;
  DateTime? inicio;
  DateTime? fim;

  ProdutoService produtoService = ProdutoService();
  PedidoService pedidoService = PedidoService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    carregarDados();
  }

  Future<void> carregarDados() async {
    final pedido = await pedidoService.carregarPedido(widget.pedidoId);
    final produtos = await produtoService.carregarProdutos(widget.pedidoId);

    if (!mounted) return;

    setState(() {
      lpedido = pedido;
      lprodutos = produtos;
      separadorSelecionado = pedido?.separador;
      inicio = DateTime.tryParse(pedido?.inicio ?? '');
      fim = DateTime.tryParse(pedido?.fim ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final alturaTotal = MediaQuery.of(context).size.height;
    final alturaAbas = alturaTotal * 0.40;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Orçamento: ${widget.id}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => DialogHelper().mostrarConfirmacaoVoltar(context),
        ),
        backgroundColor: const Color.fromRGBO(254, 121, 0, 1),
      ),
      body: lpedido == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  height: alturaAbas,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.grey.shade200,
                        child: TabBar(
                          controller: _tabController,
                          labelColor: const Color.fromRGBO(254, 121, 0, 1),
                          unselectedLabelColor: Colors.black,
                          indicatorColor: const Color.fromRGBO(254, 121, 0, 1),
                          tabs: const [
                            Tab(text: 'Cliente'),
                            Tab(text: 'Observações'),
                            Tab(text: 'Separação'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            AbaCliente(
                              pedido: lpedido!,
                              pedidoId: widget.pedidoId,
                            ),
                            AbaObservacoes(
                              pedido: lpedido!,
                              pedidoId: widget.pedidoId,
                            ),
                            SeparacaoAba(
                              pedido: lpedido!,
                              produtos: lprodutos,
                              separadorSelecionado: separadorSelecionado,
                              inicio: inicio,
                              fim: fim,
                              onSeparadorChange: (novo) =>
                                  setState(() => separadorSelecionado = novo),
                              onInicio: (data) => setState(() => inicio = data),
                              onFim: (data) => setState(() => fim = data),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabelaPage(
                    inicio: inicio,
                    fim: fim,
                    produtos: lprodutos,
                    separador: separadorSelecionado,
                    onProdutosChange: (novos) =>
                        setState(() => lprodutos = novos),
                  ),
                ),
              ],
            ),
    );
  }
}
