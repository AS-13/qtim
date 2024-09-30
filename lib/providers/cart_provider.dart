import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qtim/models/cart_product.dart';
import 'package:qtim/models/product_model.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartProduct>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartProduct>> {
  CartNotifier() : super([]);

  void addProduct(Product product) {
    // добавление продукта
    if(state.any((obj) => obj.id == product.id)){
      // если продукт уже есть в корзине, мы ему добавляем кол-во
      int index = state.indexWhere((obj) => obj.id == product.id);
      state[index].count++;
      CartProduct cartProduct = state[index];
      state = state.where((p) => p.id != product.id).toList();
      state.insert(index, cartProduct);
    }else{
      // если продукта нет в корзине, мы добавляем его в корзину
      state = [...state, CartProduct(
          id: product.id,
          product: product,
          count: 1
      )];
    }
  }

  void removeProduct(Product product, {bool allRemove = false}) {
    // удаление продукта
    int index = state.indexWhere((obj) => obj.id == product.id);
    if(state.any((obj) => obj.id == product.id && state[index].count > 1) && !allRemove){
      // если продукт уже есть в корзине, мы убираем 1 ед кол-ва в корзине
      state[index].count--;
      CartProduct cartProduct = state[index];
      state = state.where((p) => p.id != product.id).toList();
      state.insert(index, cartProduct);
    }else{
      // если продукта в корзине нет или нам нужно удалить его из корзины
      state = state.where((p) => p.id != product.id).toList();
    }
  }

  void clearCart() {
    // очищаем корзину
    state = [];
  }

  // получаем общую сумму корзины
  double get totalPrice => state.fold(0, (sum, product) => sum + product.product.price * product.count);
}
