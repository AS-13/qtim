import 'package:qtim/models/product_model.dart';

// модель данных категории
class Category {
  final int id;
  final String name, image;
  final List<Product> products;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.products,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    List<Product> products = [];
    for(var product in json['products']){
      products.add(Product(
        id: product['id'],
        name: product['name'],
        description: product['description'],
        price: product['price'].toDouble(),
        image: product['image'],
      ));
    }
    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      products: products,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'products': products
    };
  }
}
