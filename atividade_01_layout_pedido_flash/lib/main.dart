import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const PedidoFlashApp());
}

class PedidoFlashApp extends StatelessWidget {
  const PedidoFlashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pedido Flash',
      debugShowCheckedModeBanner: true, 
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          primary: Colors.deepOrange,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F5F7),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          bodyMedium: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
