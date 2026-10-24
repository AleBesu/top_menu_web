import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/public_menu.dart';
import '../providers/public_menu_provider.dart';
import '../widgets/menu_image.dart';
import '../widgets/public_menu_views.dart';

class PublicMenuScreen extends ConsumerWidget {
  const PublicMenuScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuState = ref.watch(publicMenuProvider);
    return menuState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No se pudo cargar el menú.'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () =>
                    ref.read(publicMenuProvider.notifier).refresh(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
      data: (menu) => _MenuContent(menu: menu),
    );
  }
}

class _MenuContent extends StatelessWidget {
  final PublicMenu menu;
  const _MenuContent({required this.menu});
  @override
  Widget build(BuildContext context) {
    final isDark = menu.themeMode == ThemeMode.dark;
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: menu.accent,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      useMaterial3: true,
    );
    final restaurant = menu.restaurant;
    return Theme(
      data: theme,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  SizedBox(
                    height: 290,
                    width: double.infinity,
                    child: MenuImage(restaurant.bannerPath),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Color(0xD9000000), Color(0x18000000)],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    // right: 24,
                    bottom: 30,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1000),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.name,
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Abierto de ${restaurant.openTime} a ${restaurant.closeTime}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'NUESTRA CARTA',
                        //   style: TextStyle(
                        //     letterSpacing: 2.5,
                        //     fontSize: 12,
                        //     fontWeight: FontWeight.w700,
                        //     color: theme.colorScheme.primary,
                        //   ),
                        // ),
                        // const SizedBox(height: 12),
                        _Categories(categories: restaurant.categories),
                        const SizedBox(height: 12),
                        PublicMenuViews(
                          mode: menu.mode,
                          categories: restaurant.categories,
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: Text(
                            restaurant.name,
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Categories extends StatelessWidget {
  final List<MenuCategory> categories;
  const _Categories({required this.categories});
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final category in categories.where((c) => c.products.isNotEmpty))
        Chip(
          label: Text(category.name),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(16),
          ),
        ),
    ],
  );
}
