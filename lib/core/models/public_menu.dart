import 'package:flutter/material.dart';

enum MenuViewMode { list, grid, cards, classic }

class Product {
  final String id, name, description, price;
  final String? imagePath;
  const Product({required this.id, required this.name, required this.description, required this.price, this.imagePath});
}

class MenuCategory {
  final String id, name;
  final List<Product> products;
  const MenuCategory({required this.id, required this.name, this.products = const []});
}

class RestaurantConfig {
  final String name, openTime, closeTime;
  final String? bannerPath;
  final List<MenuCategory> categories;
  const RestaurantConfig({required this.name, required this.openTime, required this.closeTime, this.bannerPath, required this.categories});
}

class PublicMenu {
  final RestaurantConfig restaurant;
  final MenuViewMode mode;
  final Color accent;
  final ThemeMode themeMode;
  const PublicMenu({required this.restaurant, required this.mode, this.accent = const Color(0xFFB77943), this.themeMode = ThemeMode.light});
}
