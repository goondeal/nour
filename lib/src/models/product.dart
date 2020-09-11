import 'package:flutter/foundation.dart';

enum Category {
  all,
  accessories,
  clothing,
  home
}

class Product {
  const Product({
    @required this.category,
    @required this.id,
    @required this.isFeatured,
    @required this.name,
    @required this.price,
    this.salePrice,

  }): assert(category != null),
      assert(id != null),
      assert(isFeatured != null),
      assert(name != null),
      assert(price != null);

  final Category category;
  final int id;
  final bool isFeatured;
  final String name;
  final double price;
  final double salePrice;

  String get assetName => '$id-0.jpg';
  String get assetPackage => 'shrine_images';

  @override
  String toString() => '$name (id=$id)';

}
