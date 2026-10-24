import 'package:flutter/material.dart';
import 'package:menu_web/UI/widgets/show_image_dialog.dart';

class MenuImage extends StatelessWidget {
  final String? url;
  final BoxFit fit;
  const MenuImage(this.url, {super.key, this.fit = BoxFit.cover});
  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(
        child: Icon(Icons.restaurant_menu_outlined, size: 34),
      ),
    );
    if (url == null || url!.isEmpty) return placeholder;
    return InkWell(
      onTap: () async {
        await showImageDialog(context, image: NetworkImage(url!));
      },
      child: Image.network(
        url!,
        fit: fit,

        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, error, stackTrace) => placeholder,
      ),
    );
  }
}
