import 'package:flutter/cupertino.dart';

import 'product_class.dart';

class Cart extends ChangeNotifier {
  final List<Product> _product = [];
  List<Product> get getItems => _product;

  int? get count => _product.length;

  double get totalPrice {
    var total = 0.0;
    for (var item in _product) {
      total += item.price * item.quantity;
    }
    return total;
  }


  void addItem(
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

  void increement(Product product) {
    product.increement();
    notifyListeners();
  }

  void decreement(Product product) {
    product.decreement();
    notifyListeners();
  }

  void removItem(Product product) {
    _product.remove(product);
    notifyListeners();
  }

  void clearCard() {
    _product.clear();
    notifyListeners();
  }
}
