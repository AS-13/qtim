import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qtim/models/category_model.dart';

final catalogProvider = FutureProvider<List<Category>>((ref) async {
  // загружаем каталог из json
  final String response = await rootBundle.loadString('assets/json/catalog.json');
  final data = json.decode(response);
  List<Category> categories = [];
  for(var category in data['categories']){
    categories.add(Category.fromJson(category));
  }
  return categories;
});
