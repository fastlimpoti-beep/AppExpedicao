import 'package:app_separacao/models/pedido.dart';
import 'package:app_separacao/services/pedido_service.dart';
import 'package:flutter/material.dart';

class AbaObservacoes extends StatefulWidget {
  final int? pedidoId;
  final Pedido pedido;
  const AbaObservacoes({
    super.key,
    required this.pedidoId,
    required this.pedido,
  });

  @override
  State<AbaObservacoes> createState() => _AbaObservacoesState();
}

class _AbaObservacoesState extends State<AbaObservacoes> {
  late Future<Pedido?> futurePedido;
  bool dadosCarregados = false;

  PedidoService pedidoService = PedidoService();
  Pedido? lpedido;

  @override
  void initState() {
    super.initState();
    futurePedido = pedidoService.carregarPedido(
      widget.pedidoId!,
    ); // substitua pela sua função real
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
                  children: [_buildInfoRow("Cliente", pedido.observacoes)],
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text("Nenhum dado de observação encontrado."),
          );
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
