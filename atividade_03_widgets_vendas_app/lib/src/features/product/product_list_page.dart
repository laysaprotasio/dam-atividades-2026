import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendas_app/src/features/cart/cart_viewmodel.dart';
import 'package:vendas_app/src/features/product/product_viewmodel.dart';
import 'package:vendas_app/src/features/cart/widgets/cart_bottom_banner.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productViewModel = context.watch<ProductViewModel>();
    final cartViewModel = context.read<CartViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'Ordenar produtos',
            onPressed: () => _showSortDialog(context, productViewModel),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/products/form'),
            tooltip: 'Adicionar Produto',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros de Categoria (Chips horizontais)
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              itemCount: productViewModel.categories.length,
              itemBuilder: (context, index) {
                final category = productViewModel.categories[index];
                final isSelected = productViewModel.currentCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      productViewModel.filterByCategory(category);
                    },
                  ),
                );
              },
            ),
          ),
          // Lista de Produtos
          Expanded(
            child: productViewModel.products.isEmpty
                ? const Center(child: Text('Nenhum produto cadastrado.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: productViewModel.products.length,
                    itemBuilder: (context, index) {
                      final product = productViewModel.products[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: product.imageUrl.isNotEmpty
                                  ? Image.network(
                                      product.imageUrl,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          _buildImageFallback(),
                                    )
                                  : _buildImageFallback(),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'R\$ ${product.price.toStringAsFixed(2)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  tooltip: product.isFavorite
                                      ? 'Remover dos favoritos'
                                      : 'Adicionar aos favoritos',
                                  icon: Icon(
                                    product.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: product.isFavorite ? Colors.red : null,
                                  ),
                                  onPressed: () =>
                                      productViewModel.toggleFavorite(product.id),
                                ),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  tooltip: 'Adicionar ao carrinho de compras',
                                  icon: const Icon(Icons.add_shopping_cart, color: Colors.blue),
                                  onPressed: () {
                                    cartViewModel.addToCart(product);
                                  },
                                ),
                                const SizedBox(width: 4),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const CartBottomBanner(),
    );
  }

  void _showSortDialog(BuildContext context, ProductViewModel productViewModel) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Ordenar por:'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              productViewModel.sortByName(ascending: true);
              Navigator.pop(context);
            },
            child: const Text('Nome (A-Z)'),
          ),
          SimpleDialogOption(
            onPressed: () {
              productViewModel.sortByName(ascending: false);
              Navigator.pop(context);
            },
            child: const Text('Nome (Z-A)'),
          ),
          SimpleDialogOption(
            onPressed: () {
              productViewModel.sortByPrice(ascending: true);
              Navigator.pop(context);
            },
            child: const Text('Preço (Menor para Maior)'),
          ),
          SimpleDialogOption(
            onPressed: () {
              productViewModel.sortByPrice(ascending: false);
              Navigator.pop(context);
            },
            child: const Text('Preço (Maior para Menor)'),
          ),
        ],
      ),
    );
  }

  Widget _buildImageFallback() {
    return Container(
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey.shade500),
    );
  }
}
