import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qtim/providers/cart_provider.dart';

import 'package:badges/badges.dart' as badges;

import '../models/product_model.dart';

class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // получаем данные корзины
    final cart = ref.watch(cartProvider);
    // получаем индекс данного продукта в корзине если он там есть
    int index = cart.indexWhere((obj) => obj.id == product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          InkWell(
            onTap: (){
              // переходим в профиль
              GoRouter.of(context).push('/profile');
            },
            child: const Icon(Icons.account_circle_outlined),
          ),
          const SizedBox(width: 8,),
          cart.isNotEmpty ? Container(
            margin: const EdgeInsets.only(top: 16, right: 12),
            child: InkWell(
              onTap: (){
                // переходим в корзину
                GoRouter.of(context).push('/cart');
              },
              child: badges.Badge(
                badgeContent: Text('${cart.length}'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ): Container(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: Column(children: [
          Image.network(product.image,),
          const SizedBox(height: 8,),
          Text(
            product.name,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
          Text(
            "${product.price} ₽",
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
          // если товар есть в корзине - предлагаем изменить его кол-во
          index > -1 && cart[index].count > 0 ? Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    // уменьшение кол-ва ед товара в корзине
                    ref.read(cartProvider.notifier).removeProduct(product);
                  },
                  child: const Icon(Icons.remove, size: 28, color: Colors.blueGrey,),
                ),
                const SizedBox(width: 20,),
                Text(
                  "${cart[index].count}",
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(width: 20,),
                InkWell(
                  onTap: (){
                    // увеличение кол-ва ед товара в корзине
                    ref.read(cartProvider.notifier).addProduct(product);
                  },
                  child: const Icon(Icons.add, size: 28, color: Colors.blueGrey,),
                ),
              ],),
          ) : ElevatedButton(
            // если товара нет в корзине, отображаем кнопку добавления его
            onPressed: () {
              // добавляем товар в корзину
              ref.read(cartProvider.notifier).addProduct(product);
            },
            child: const Text(
              'В корзину',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12,),
          Text(
            product.description,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ],),
      ),
    );
  }
}
