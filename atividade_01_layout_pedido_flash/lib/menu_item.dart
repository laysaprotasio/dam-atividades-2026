import 'package:flutter/material.dart';

class MenuItem {
  final String nome;
  final double preco;
  final IconData icone;
  final bool promo;
  final bool esgotado;

  const MenuItem({
    required this.nome,
    required this.preco,
    required this.icone,
    this.promo = false,
    this.esgotado = false,
  });
}