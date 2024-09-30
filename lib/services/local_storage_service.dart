import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/product_model.dart';

part 'local_storage_service.g.dart';

@DriftDatabase(tables: [CartItems])
class LocalStorageService extends _$LocalStorageService {
  LocalStorageService() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Product>> getCartItems() async {
    final items = await select(cartItems).get();
    return items.map((item) => Product(
      id: item.id,
      name: item.name,
      description: item.description,
      price: item.price,
      image: item.image,
    )).toList();
  }

  Future<void> addToCart(Product product) => into(cartItems).insert(CartItemsCompanion(
    id: Value(product.id),
    name: Value(product.name),
    description: Value(product.description),
    price: Value(product.price),
    image: Value(product.image),
  ));

  Future<void> removeFromCart(int productId) => (delete(cartItems)..where((tbl) => tbl.id.equals(productId))).go();

  Future<void> clearCart() => delete(cartItems).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File('${dbFolder.path}/db.sqlite');
    return NativeDatabase(file);
  });
}

@DataClassName('CartItem')
class CartItems extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  RealColumn get price => real()();
  TextColumn get image => text()();
}
