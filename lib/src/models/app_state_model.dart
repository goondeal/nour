import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:nour/src/models/order.dart';

import 'package:nour/src/models/product.dart';
import 'package:nour/src/models/products_repository.dart';

// double _salesTaxRate = 0.0;
// double _shippingCostPerItem = 0.0;

class AppStateModel extends ChangeNotifier {
  /// All the available products.
  List<Product> _availableProducts;

  /// The currently selected category of products.
  Category _selectedCategory = Category.all;

  Category get selectedCategory => _selectedCategory;

  /// The IDs and quantities of products currently in the cart.
  /// {id: quantity}
  final Map<int, int> _productsInCart = <int, int>{};

  Map<int, int> get productsInCart => Map<int, int>.from(_productsInCart);

  /// Total number of items in the cart (The absolute quantity).
  int get totalCartQuantity =>
      _productsInCart.values.fold(0, (int v, int e) => v + e);

  /// Return the total prices of the items in the cart.
  double get subtotalCost {
    return _productsInCart.keys
        .map((int id) => _availableProducts[id].price * _productsInCart[id])
        .fold(0.0, (double sum, double e) => sum + e);
  }

  /// Total shipping cost for the items in the cart.
  double get shippingCost {
    return 0.0;
    //_shippingCostPerItem * _productsInCart.values.fold(0.0, (num sum, int e) => sum + e);
  }

  /// Sales tax for the items in the cart.
  double get tax => 0.0; //subtotalCost * _salesTaxRate;

  /// Total cost to order everything in the cart.
  double get totalCost => subtotalCost + shippingCost + tax;

  /// Returns a copy of the list of available products, filtered by category.
  List<Product> getProducts() {
    if (_availableProducts == null) {
      return <Product>[];
    }

    if (_selectedCategory == Category.all) {
      return List<Product>.from(_availableProducts);
    } else {
      return _availableProducts
          .where((Product p) => p.category == _selectedCategory)
          .toList();
    }
  }

  /// Adds a product to the cart and notify listners.
  void addProductToCart(int productId) {
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      _productsInCart[productId]++;
    }
    notifyListeners();
  }

  /// Removes an item from the cart and notify listners.
  void removeItemFromCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId]--;
      }
    }
    notifyListeners();
  }

  /// Returns the Product instance matching the provided id.
  /// TODO: Optimize
  Product getProductById(int id) {
    return _availableProducts.firstWhere((Product p) => p.id == id);
  }

  /// Removes everything from the cart and notify listners.
  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }

  /// Loads the list of available products from the repo.
  void loadProducts() {
    _availableProducts = ProductsRepository.loadProducts(Category.all);
    notifyListeners();
  }

  /// Updates the category type.
  void setCategory(Category newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }

  List<ProductDetails> get productsToOrder => productsInCart.entries
      .map(
        (e) => ProductDetails(
            id: e.key,
            quantity: e.value,
            price:
                getProductById(e.key).salePrice ?? getProductById(e.key).price),
      )
      .toList();


  @override
  String toString() {
    return 'AppStateModel(totalCost: $totalCost)';
  }
}
