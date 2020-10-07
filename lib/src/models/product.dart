import 'package:flutter/foundation.dart';

enum Category { all, accessories, clothing, home }

class Product {
  final int id;
  final String name;
  final double price;
  final Category category;
  final double salePrice;

  /// TODO: Delete [isFeatured] after adding the real products to the database.
  /// and it's here only for the mocked data;
  final bool isFeatured;

  const Product({
    @required this.category,
    @required this.id,
    @required this.isFeatured,
    @required this.name,
    @required this.price,
    this.salePrice,
  })  : assert(category != null),
        assert(id != null),
        assert(isFeatured != null),
        assert(name != null),
        assert(price != null);

  String get assetName => '$id-0.jpg';
  String get assetPackage => 'shrine_images';

  @override
  String toString() => '$name (id=$id)';
}
