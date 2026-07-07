import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedido Flash')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            SizedBox(
              height: 160,
              child: Center(child: Text('Menu Caixa')),
            ),
            ListTile(
              leading: Icon(Icons.add_shopping_cart),
              title: Text('Novo Pedido'),
            ),
            ListTile(leading: Icon(Icons.history), title: Text('Histórico')),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Cardápio')),
    );
  }
}
