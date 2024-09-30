import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/cart_provider.dart';

// визуализация корзины
class CartPage extends ConsumerWidget {
  CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // получаем данные корзины
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
        actions: [
          cart.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => // очищаем корзину
                  ref.read(cartProvider.notifier).clearCart(),
              child: const Text('Очистить корзину'),
            ),
          )
              : Container(),
        ],
      ),
      body: cart.isNotEmpty
          ? ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final product = cart[index];
          return InkWell(
            onTap: (){
              // переходим на страницу продукта
              GoRouter.of(context).push('/details', extra: product.product);
            },
            child: ListTile(
              leading: Image.network(product.product.image),
              title: Text(product.product.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8,),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${product.count} шт x ${product.product.price} ₽ = ',
                          style: const TextStyle(fontSize: 16),
                        ),
                        TextSpan(
                          text: '${(product.count*product.product.price).toStringAsFixed(2)} ₽',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 20,),
                      onPressed: () {
                        // уменьшаем кол-во ед продукта
                        ref.read(cartProvider.notifier).removeProduct(product.product);
                      },
                    ),
                    Text(
                      '${product.count}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 20,),
                      onPressed: () {
                        // увеличиваем кол-во ед продукта
                        ref.read(cartProvider.notifier).addProduct(product.product);
                      },
                    )
                  ],),
                ],),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // удаляем продукт из корзины
                  ref.read(cartProvider.notifier).removeProduct(product.product, allRemove: true);
                },
              ),
            ),
          );
        },
      ) // отображаем что корзина пустая
          : const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 150,
              color: Colors.black54,
            ),
          ),
          Text(
            "Корзина пустая",
            style: TextStyle(
              fontSize: 24,
              color: Colors.black54,
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          // отображаем общую сумму корзины
          "Сумма корзины: ${ref.read(cartProvider.notifier).totalPrice.toStringAsFixed(2)} руб.",
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}