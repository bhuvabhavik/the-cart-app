import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thecartapp/cart_provider.dart';
import 'package:thecartapp/product_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(
        builder: (BuildContext context) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            home: ProductListScreen(),
          );
        },
      ),
    );
  }
}
