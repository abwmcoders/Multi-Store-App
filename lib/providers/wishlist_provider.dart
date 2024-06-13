import 'package:flutter/foundation.dart';

import 'product_class.dart';

class Wish extends ChangeNotifier {
  final List<Product> _product = [];
  List<Product> get getItems => _product;

  int? get count => _product.length;

 

  void addWishItem(
    final String name,
    final double price,
    final int quantity,
    final int inStock,
    final List imageUrl,
    final String documentId,
    final String suplierId,
  ) {
    final newproduct = Product(
      name: name,
      price: price,
      inStock: inStock,
      imageUrl: imageUrl,
      documentId: documentId,
      suplierId: suplierId,
    );
    _product.add(newproduct);
    notifyListeners();
  }

  void removItem(Product product) {
    _product.remove(product);
    notifyListeners();
  }

  void clearWish() {
    _product.clear();
    notifyListeners();
  }
}
