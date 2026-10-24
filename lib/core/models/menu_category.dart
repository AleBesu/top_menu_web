import 'package:menu_web/core/models/product.dart';

class MenuCategory {
  final String id, name;
  final List<Product> products;
  const MenuCategory({
    required this.id,
    required this.name,
    this.products = const [],
  });
}
