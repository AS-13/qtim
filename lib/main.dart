import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qtim/ui/categories_page.dart';
import 'package:qtim/ui/product_detail_page.dart';
import 'package:qtim/ui/products_page.dart';
import 'package:qtim/ui/profile_page.dart';
import 'models/product_model.dart';
import 'ui/cart_page.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  final _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const CategoriesPage()),
      GoRoute(path: '/products', builder: (context, state){
        var extra = state.extra as Map<String, dynamic>;
        return ProductsPage(
          products: extra['products'] as List<Product>,
          name: extra['name'] as String
        );
      }),
      GoRoute(path: '/details', builder: (context, state){
        return ProductDetailPage(product: state.extra as Product);
      }),
      GoRoute(path: '/cart', builder: (context, state) => CartPage()),
      GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
    ],
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
