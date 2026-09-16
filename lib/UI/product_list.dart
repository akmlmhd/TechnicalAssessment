import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  const new({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Product List'),
      ),
    );
  }
}