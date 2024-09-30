import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qtim/providers/cart_provider.dart';
import 'package:qtim/providers/catalog_provider.dart';

import 'package:badges/badges.dart' as badges;

import 'package:qtim/models/category_model.dart' as categoryModel;

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // загружаем данные корзины
    final cart = ref.watch(cartProvider);

    // загружаем данные каталога
    final catalog = ref.watch(catalogProvider);

    if (catalog.value == null) {
      // пока нет данных идет загрузка
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории'),
        actions: [
          InkWell(
            onTap: (){
              // переходим на экран профиля
              GoRouter.of(context).push('/profile');
            },
            child: const Icon(Icons.account_circle_outlined),
          ),
          const SizedBox(width: 8,),
          cart.isNotEmpty ? Container(
            margin: const EdgeInsets.only(top: 16, right: 12),
            child: InkWell(
              onTap: (){
                // переходим на экран корзины
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
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: catalog.value!.length,
          itemBuilder: (context, index){
            categoryModel.Category category = catalog.value![index];
            return InkWell(
              onTap: (){
                // переходим на экран списка продуктов
                GoRouter.of(context).push('/products', extra: {"products": category.products, "name": category.name});
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(horizontal: 12),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      category.image,
                      height: 64,
                    ),
                    Column(children: [
                      Text(
                        catalog.value![index].name,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8,),
                      Text(
                        "${catalog.value![index].products.length} "
                            "${catalog.value![index].products.length > 4
                            ? "продуктов" : catalog.value![index].products.length > 1
                            ? "продукта" : "продукт"}",
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black12,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
