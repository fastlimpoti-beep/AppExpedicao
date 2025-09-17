import 'package:app_separacao/models/pedido.dart';
import 'package:app_separacao/providers/services/pedido_service.dart';
import 'package:flutter/material.dart';

class AbaCliente extends StatefulWidget {
  final int? pedidoId;
  final Pedido pedido;
  const AbaCliente({super.key, required this.pedidoId, required this.pedido});

  @override
  State<AbaCliente> createState() => _AbaClienteState();
}

class _AbaClienteState extends State<AbaCliente> {
  late Future<Pedido?> futurePedido;
  bool dadosCarregados = false;

  PedidoService pedidoService = PedidoService();
  Pedido? lpedido;

  @override
  void initState() {
    super.initState();
    futurePedido = pedidoService.carregarPedido(widget.pedidoId!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pedido?>(
      future: futurePedido,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Erro: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          final pedido = snapshot.data!;

          if (!dadosCarregados) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  lpedido = pedido;
                  dadosCarregados = true;
                });
              }
            });
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("Cliente", pedido.cliente),
                    _buildInfoRow("Endereço", pedido.endereco),
                    _buildInfoRow("Telefone", pedido.telefone),
                    _buildInfoRow("E-mail", pedido.email),
                    _buildInfoRow("Comprador", pedido.comprador),
                    _buildInfoRow("Estoque", pedido.estoque),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: Text("Nenhum dado de pedido encontrado."));
        }
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded(child: Text(value, style: TextStyle(fontSize: 18))),
        ],
      ),
    );
  }
}
