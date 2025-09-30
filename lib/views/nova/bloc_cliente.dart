import 'package:app_separacao/models/cliente.dart';
import 'package:app_separacao/services/pedido_service.dart';
import 'package:flutter/material.dart';

class ClienteTab extends StatelessWidget {
  final int pedidoId;

  const ClienteTab({super.key, required this.pedidoId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Cliente>(
      future: PedidoService().getClienteDoPedido(pedidoId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final cliente = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome: ${cliente.nome}', style: TextStyle(fontSize: 18)),
                Text('Endereço: ${cliente.endereco}'),
                Text('Telefone: ${cliente.telefone}'),
                Text('Email: ${cliente.email}'),
                Text('Comprador: ${cliente.comprador}'),
                Text('Estoque: ${cliente.estoque}'),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar cliente'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
