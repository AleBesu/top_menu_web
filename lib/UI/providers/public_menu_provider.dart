import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menu_web/core/enum/menu_layout_mode.dart';
import 'package:menu_web/core/models/menu_category.dart';
import 'package:menu_web/core/models/menu_config.dart';
import 'package:menu_web/core/models/product.dart';
import 'package:menu_web/core/repositorys/public_menu_repository.dart';

import '../../core/models/public_menu.dart';

import 'package:flutter/material.dart';

final publicMenuProvider =
    AsyncNotifierProvider<PublicMenuNotifier, MenuConfig>(
      PublicMenuNotifier.new,
    );

final _publicMenuRepositoryProvider = Provider<PublicMenuRepository>(
  (ref) => FakePublicMenuRepository(),
);

class PublicMenuNotifier extends AsyncNotifier<MenuConfig> {
  @override
  Future<MenuConfig> build() =>
      ref.watch(_publicMenuRepositoryProvider).fetchMenu();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(_publicMenuRepositoryProvider).fetchMenu(),
    );
  }

  /// Permite aceptar un snapshot recibido por WebSocket/SSE más adelante.
  void applyServerMenu(MenuConfig menu) => state = AsyncData(menu);
}

class FakePublicMenuRepository implements PublicMenuRepository {
  @override
  Future<MenuConfig> fetchMenu() async => const MenuConfig(
    mode: MenuLayoutMode.grid,
    primaryColor: Color.fromARGB(255, 30, 253, 0),
    themeMode: ThemeMode.dark,
    address: 'libertad #88 entre 1ra y 3ra, La Habana, Cuba',
    numberPhone: '+53 78129944',
    name: 'La Trattoria',
    openTime: '12:00',
    closeTime: '23:00',
    bannerPath: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=1400&auto=format',
    categories: [
      MenuCategory(
        id: 'entrantes',
        name: 'Entrantes',
        products: [
          Product(
            id: '1',
            name: 'Bruschetta al pomodoro',
            description: 'Pan tostado con tomate fresco, albahaca y aceite de oliva virgen.',
            price: '6.50',
            imagePath: 'https://images.unsplash.com/photo-1572695157366-5e585ab2b69f?w=600&auto=format',
          ),
          Product(
            id: '2',
            name: 'Burrata',
            description: 'Burrata cremosa, tomate de temporada y pesto.',
            price: '9.50',
            imagePath: 'https://images.unsplash.com/photo-1608897013039-887f21d8c804?w=600&auto=format',
          ),
        ],
      ),
      MenuCategory(
        id: 'pizzas',
        name: 'Pizzas',
        products: [
          Product(
            id: '3',
            name: 'Margherita',
            description:
                'Salsa de tomate, mozzarella fior di latte y albahaca.',
            price: '12.00',
            imagePath: 'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?w=600&auto=format',
          ),
          Product(
            id: '4',
            name: 'Diavola',
            description: 'Tomate, mozzarella, salami picante y guindilla.',
            price: '14.00',
            imagePath: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&auto=format',
          ),
        ],
      ),
      MenuCategory(
        id: 'postres',
        name: 'Postres',
        products: [
          Product(
            id: '5',
            name: 'Tiramisú',
            description: 'Mascarpone, café espresso y cacao.',
            price: '6.00',
            imagePath: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=600&auto=format',
          ),
        ],
      ),
    ],
  );
}
