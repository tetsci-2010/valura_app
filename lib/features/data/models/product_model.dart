import 'package:valura/features/data/models/item_model.dart';

class ProductModel {
  final int id;
  final String name;
  final num total;
  final List<ItemModel> items;

  const ProductModel({required this.id, required this.name, required this.total, required this.items});
}
