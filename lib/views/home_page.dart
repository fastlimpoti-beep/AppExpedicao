import 'package:app_separacao/providers/services/json_service.dart';
import 'package:app_separacao/utils/dialog_helper.dart';
import 'package:app_separacao/views/abas_pai.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  DialogHelper dialogHelper = DialogHelper();

  final jsonS = JsonService();

  void _buscarPedido() {
    final id = int.tryParse(_controller.text);
    if (id != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AbasTestes(pedidoId: id, id: _controller.text),
        ),
      );
      FocusScope.of(context).unfocus();
    } else {
      dialogHelper.mostrarAlerta(context, 'Digite um ID válido!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "Bem Vindo(a)",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            Image.asset('assets/fastlimpo_logo.png', height: 250),
            TextField(
              cursorColor: Color.fromRGBO(254, 121, 0, 1), // Cor do cursor
              controller: _controller,
              style: const TextStyle(
                // Estilo do texto digitado
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: 'Digite o ID do pedido',
                labelStyle: TextStyle(
                  // Estilo do rótulo
                  color: Color.fromRGBO(254, 121, 0, 1),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Color.fromRGBO(254, 121, 0, 0.1), // Fundo do campo
                prefixIcon: Icon(
                  Icons.search,
                  color: Color.fromRGBO(254, 121, 0, 1),
                ), // Ícone à esquerda
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(254, 121, 0, 1),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _buscarPedido,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(11, 125, 167, 1),
                foregroundColor: Color.fromRGBO(255, 255, 255, 1),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Borda arredondada
                ),
                elevation: 4, // Sombra
              ),
              child: Text('Buscar'),
            ),
            ElevatedButton(
              onPressed: () async {
                //    await jsonS.importarPedidoDoJson(context);
                await jsonS.importarPedidoDoJsonFromServer(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(11, 125, 167, 1),
                foregroundColor: Color.fromRGBO(255, 255, 255, 1),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Borda arredondada
                ),
                elevation: 4, // Sombra
              ),
              child: Text('JSON'),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
