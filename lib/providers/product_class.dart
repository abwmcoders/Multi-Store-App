class Product {
  final String name;
  final double price;
  int quantity = 1;
  final int inStock;
  final List imageUrl;
  final String documentId;
  final String suplierId;

  Product({
    required this.name,
    required this.price,
    required this.inStock,
    required this.imageUrl,
    required this.documentId,
    required this.suplierId,
  });

  void increement() {
    quantity++;
  }

  void decreement() {
    quantity--;
  }
}
