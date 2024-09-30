import 'package:qtim/models/product_model.dart';

// модель данных корзины
class CartProduct {
  final int id;
  final Product product;
  int count;

  CartProduct({
    required this.id,
    required this.product,
    required this.count,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      id: json['id'],
      product: Product.fromJson(json['product']),
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product,
      'count': count,
    };
  }
}
