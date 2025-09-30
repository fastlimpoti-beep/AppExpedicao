import 'package:app_separacao/services/pedido_service.dart';
import 'package:flutter/material.dart';

class ObservacaoTab extends StatelessWidget {
  final int pedidoId;

  const ObservacaoTab({super.key, required this.pedidoId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: PedidoService().getObservacaoDoPedido(pedidoId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              snapshot.data!,
              style: TextStyle(fontSize: 16),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar observação'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
