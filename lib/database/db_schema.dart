import 'package:sqflite/sqflite.dart';

class DBSchema {
  static Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE Pedidos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numero TEXT,
        cliente TEXT,
        endereco TEXT,
        telefone TEXT,
        email TEXT,
        comprador TEXT,
        estoque TEXT,
        observacoes TEXT,
        data_criacao TEXT,
        separador TEXT,
        inicio TEXT,
        fim TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Produtos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pedido_id INTEGER,
        endereco TEXT,
        descricao TEXT,
        solicitado INTEGER,
        separado INTEGER,
        motivo_nao_separacao TEXT,
        imagem_local TEXT,
        codigo_barras TEXT,
        FOREIGN KEY (pedido_id) REFERENCES Pedidos(id) ON DELETE CASCADE
      )
    ''');
  }
}
