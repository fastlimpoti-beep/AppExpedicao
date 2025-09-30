import 'package:app_separacao/views/nova/bloc.dart';
import 'package:app_separacao/views/home_page.dart';
import 'package:app_separacao/views/teste.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela de Separação',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(254, 121, 0, 1),
        ),
      ),
      home: HomePage(),
    );
  }
}
