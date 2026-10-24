import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menu_web/core/models/menu_category.dart';
import 'package:menu_web/core/models/menu_config.dart';

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

class _MenuContent extends StatefulWidget {
  final MenuConfig menu;
  const _MenuContent({required this.menu});

  @override
  State<_MenuContent> createState() => _MenuContentState();
}

class _MenuContentState extends State<_MenuContent> {
  int currentScreenIndex = 0;

  List<Widget> bodyList = [];

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        bodyList = [
          _MenuBody(menu: widget.menu, theme: Theme.of(context)),
          const Center(child: Text('Favoritos')),
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.menu.themeMode == ThemeMode.dark;
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: widget.menu.primaryColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      useMaterial3: true,
    );

    return Theme(
      data: theme,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: widget.menu.primaryColor.withOpacity(0.8),
          currentIndex: currentScreenIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_outlined),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favoritos',
            ),
          ],
          onTap: (value) {
            setState(() {
              currentScreenIndex = value;
            });
          },
        ),
        body: bodyList.isEmpty ? SizedBox() : bodyList[currentScreenIndex],
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

class _MenuBody extends StatefulWidget {
  final MenuConfig menu;
  final ThemeData theme;
  const _MenuBody({required this.menu, required this.theme});

  @override
  State<_MenuBody> createState() => _MenuBodyState();
}

class _MenuBodyState extends State<_MenuBody> {
  @override
  Widget build(BuildContext context) {
    final restaurant = widget.menu;

    return CustomScrollView(
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
                      mode: widget.menu.mode,
                      categories: restaurant.categories,
                    ),
                    const SizedBox(height: 30),
                    Divider(
                      color: widget.theme.colorScheme.outline.withOpacity(0.6),
                      endIndent: 25,
                      indent: 25,
                      thickness: 0.5,
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(restaurant.name, style: TextStyle()),
                          SizedBox(height: 8),
                          if (restaurant.numberPhone != null)
                            Text(
                              restaurant.numberPhone!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          SizedBox(height: 2),
                          if (restaurant.address != null)
                            Text(
                              restaurant.address!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
