import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:menu_web/core/enum/menu_layout_mode.dart';
import 'package:menu_web/core/models/menu_category.dart';
import 'package:menu_web/core/models/public_menu.dart';

class MenuConfig {
  // final RestaurantData restaurant;
  final MenuLayoutMode mode;
  final Color primaryColor;
  final String? numberPhone;
  final String? address;
  final ThemeMode themeMode;
  final String name, openTime, closeTime;
  final String? bannerPath;
  final List<MenuCategory> categories;

  const MenuConfig({
    required this.name,
    required this.openTime,
    required this.closeTime,

    required this.mode,
    this.primaryColor = const Color.fromARGB(255, 187, 124, 69),
    this.themeMode = ThemeMode.light,
    this.numberPhone,
    this.address,

    this.bannerPath,
    required this.categories,
  });
}

// class RestaurantData {
//   final String name, openTime, closeTime;
//   final String? bannerPath;
//   final List<MenuCategory> categories;
//   const RestaurantData({
//     required this.name,
//     required this.openTime,
//     required this.closeTime,
//     this.bannerPath,
//     required this.categories,
//   });
// }
