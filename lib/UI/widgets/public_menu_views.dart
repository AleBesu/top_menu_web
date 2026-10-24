import 'package:flutter/material.dart';
import 'package:menu_web/core/enum/menu_layout_mode.dart';
import 'package:menu_web/core/models/menu_category.dart';
import 'package:menu_web/core/models/product.dart';

import '../../core/models/public_menu.dart';
import 'menu_image.dart';

String displayPrice(String raw) {
  final number = double.tryParse(raw.replaceAll(',', '.'));
  return number == null ? '$raw \$' : '${number.toStringAsFixed(2)} \$';
}

class PublicMenuViews extends StatelessWidget {
  final List<MenuCategory> categories;
  final MenuLayoutMode mode;
  const PublicMenuViews({
    super.key,
    required this.categories,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final visible = categories.where((c) => c.products.isNotEmpty).toList();
    if (visible.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Text('La carta todavía no tiene platos disponibles.'),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final c in visible) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 16),
            child: Text(
              c.name.toUpperCase(),
              style: TextStyle(
                fontSize: 15,
                letterSpacing: 2,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          if (mode == MenuLayoutMode.list)
            ...c.products.map((p) => _ListTile(product: p)),
          if (mode == MenuLayoutMode.cards)
            ...c.products.map((p) => _CardTile(product: p)),
          if (mode == MenuLayoutMode.classic) _ClassicCategory(category: c),
          if (mode == MenuLayoutMode.grid)
            LayoutBuilder(
              builder: (context, constraints) {
                final count = constraints.maxWidth > 800
                    ? 3
                    : constraints.maxWidth > 480
                    ? 2
                    : 2;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: count,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: constraints.maxWidth < 390 ? 260 : 300,
                  ),
                  itemCount: c.products.length,
                  itemBuilder: (context, index) =>
                      _GridTile(product: c.products[index]),
                );
              },
            ),
          const SizedBox(height: 15),
        ],
      ],
    );
  }
}

class _ListTile extends StatelessWidget {
  final Product product;
  const _ListTile({required this.product});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 88,
            height: 88,
            child: MenuImage(product.imagePath),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                product.description,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          displayPrice(product.price),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    ),
  );
}

class _CardTile extends StatelessWidget {
  final Product product;
  const _CardTile({required this.product});
  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    margin: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 210,
          width: double.infinity,
          child: MenuImage(product.imagePath),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    displayPrice(product.price),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              if (product.description.isNotEmpty) ...[
                const SizedBox(height: 7),
                Text(product.description),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class _GridTile extends StatelessWidget {
  final Product product;
  const _GridTile({required this.product});
  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    margin: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: MenuImage(product.imagePath)),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                product.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 7),
              Text(
                displayPrice(product.price),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ClassicCategory extends StatelessWidget {
  final MenuCategory category;
  const _ClassicCategory({required this.category});
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          for (final p in category.products)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          p.name,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        displayPrice(p.price),
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  if (p.description.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      p.description,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    ),
  );
}
