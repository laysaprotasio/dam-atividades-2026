import 'package:flutter/material.dart';
import 'package:vendas_app/src/application/helpers/currency_helper.dart';
import 'package:vendas_app/src/models/order_model.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Pegando o pedido passado via argumentos de rota
    final order = ModalRoute.of(context)!.settings.arguments as OrderModel;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido #${order.id.substring(0, 8)}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informações do Cliente',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Nome: ${order.client.name}'),
            Text('E-mail: ${order.client.email}'),
            Text('Telefone: ${order.client.phone}'),
            const Divider(height: 32),
            const Text(
              'Itens do Pedido',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1.8),
                    1: FlexColumnWidth(0.6),
                    2: FlexColumnWidth(1.4),
                    3: FlexColumnWidth(1.4),
                  },
                  border: TableBorder(
                    horizontalInside: BorderSide(color: Colors.grey.shade300),
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade100),
                      children: const [
                        _TableHeaderCell('Produto'),
                        _TableHeaderCell('Qtd', align: TextAlign.right),
                        _TableHeaderCell('Preço Unitário', align: TextAlign.right),
                        _TableHeaderCell('Subtotal', align: TextAlign.right),
                      ],
                    ),
                    ...order.items.map((item) {
                      return TableRow(
                        children: [
                          _TableCell(item.product.name),
                          _TableCell('${item.quantity}', align: TextAlign.right),
                          _TableCell(
                            CurrencyHelper.format(item.product.price),
                            align: TextAlign.right,
                          ),
                          _TableCell(
                            CurrencyHelper.format(item.total),
                            align: TextAlign.right,
                            bold: true,
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Valor Total Geral:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    CurrencyHelper.format(order.totalAmount),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final String text;
  final TextAlign align;

  const _TableHeaderCell(this.text, {this.align = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Text(
        text,
        textAlign: align,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool bold;
  final TextAlign align;

  const _TableCell(this.text, {this.bold = false, this.align = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      textAlign: align,
      maxLines: align == TextAlign.right ? 1 : 2,
      overflow: align == TextAlign.right ? null : TextOverflow.ellipsis,
      style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
      child: align == TextAlign.right
          ? Align(
              alignment: Alignment.centerRight,
              child: FittedBox(fit: BoxFit.scaleDown, child: textWidget),
            )
          : textWidget,
    );
  }
}
