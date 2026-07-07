import 'package:flutter/material.dart';
import 'menu_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<MenuItem> cardapio = [
    MenuItem(nome: 'Pizza Calabresa', preco: 45.00, icone: Icons.local_pizza),
    MenuItem(
      nome: 'Chopp Artesanal',
      preco: 12.00,
      icone: Icons.sports_bar,
      promo: true,
    ),
    MenuItem(
      nome: 'Hambúrguer Duplo (Esgotado)',
      preco: 32.00,
      icone: Icons.lunch_dining,
      esgotado: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedido Flash')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 160,
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomLeft,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
                ),
              ),
              child: const Text(
                'Menu Caixa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.add_shopping_cart),
              title: Text('Novo Pedido'),
            ),
            const ListTile(
              leading: Icon(Icons.history),
              title: Text('Histórico'),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cardápio Rápido',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: cardapio.length,
                itemBuilder: (context, index) {
                  final item = cardapio[index];
                  return ListTile(
                    leading: Icon(item.icone),
                    title: Text(item.nome),
                    trailing: Text('R\$ ${item.preco.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
