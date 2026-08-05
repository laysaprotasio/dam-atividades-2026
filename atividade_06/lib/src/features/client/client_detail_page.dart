import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:vendas_app/src/models/client_model.dart';

class ClientDetailPage extends StatelessWidget {
  const ClientDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final client = ModalRoute.of(context)!.settings.arguments as ClientModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(client.name),
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
            Text('Nome: ${client.name}'),
            Text('E-mail: ${client.email}'),
            Text('Telefone: ${client.phone}'),
            if (client.birthDate != null) ...[
              Text('Data de Nascimento: ${DateFormat('dd/MM/yyyy').format(client.birthDate!)}'),
              Text('Idade: ${client.age} anos'),
            ] else
              const Text('Data de nascimento não informada'),
          ],
        ),
      ),
    );
  }
}
