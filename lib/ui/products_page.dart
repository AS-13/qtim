import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qtim/providers/cart_provider.dart';

import '../models/product_model.dart';

import 'package:badges/badges.dart' as badges;

class ProductsPage extends ConsumerWidget {
  const ProductsPage({
    super.key,
    required this.name,
    required this.products,
  });

  final String name;
  final List<Product> products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // загрузка данных корзины
    final cart = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          InkWell(
            onTap: (){
              // переход в профиль
              GoRouter.of(context).push('/profile');
            },
            child: const Icon(Icons.account_circle_outlined),
          ),
          const SizedBox(width: 8,),
          cart.isNotEmpty ? Container(
            margin: const EdgeInsets.only(top: 16, right: 12),
            child: InkWell(
              onTap: (){
                // переход в корзину
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            // получаем индекс товара в корзине если он там есть
            int i = cart.indexWhere((obj) => obj.id == products[index].id);
            return InkWell(
              onTap: (){
                // переходим на экран карточки продукта
                GoRouter.of(context).push('/details', extra: products[index]);
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  border: Border.all(
                    color: Colors.black54,
                    width: .3,
                  ),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(10)
                  ),
                ),
                child: Column(
                  children: [
                    Image.network(products[index].image,),
                    const SizedBox(height: 8,),
                    Text(
                      products[index].name,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                    Text(
                      "${products[index].price} ₽",
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 8,),
                    // отображаем редактирование кол-ва ед продукта в корзине
                    // или кнопку добавления в корзину
                    i>-1 && cart[i].count > 0 ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              // убираем ед товара из корзины
                              ref.read(cartProvider.notifier).removeProduct(products[index]);
                            },
                            child: const Icon(Icons.remove, size: 28, color: Colors.blueGrey,),
                          ),
                          const SizedBox(width: 20,),
                          Text(
                            "${cart[i].count}",
                            style: const TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(width: 20,),
                          InkWell(
                            onTap: (){
                              // добавляем ед товара в корзину
                              ref.read(cartProvider.notifier).addProduct(products[index]);
                            },
                            child: const Icon(Icons.add, size: 28, color: Colors.blueGrey,),
                          ),
                        ],),
                    ) : ElevatedButton(
                      onPressed: () {
                        // добавляем товар в корзину
                        ref.read(cartProvider.notifier).addProduct(products[index]);
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
                    const SizedBox(height: 8,),
                  ],
                ),
              ),
            );
          },
          padding: const EdgeInsets.all(10),
        ),
      ),
    );
  }
}
