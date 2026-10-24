class Product {
  final String id, name, description, price;
  final String? imagePath;
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imagePath,
  });
}
