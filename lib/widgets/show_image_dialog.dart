import 'package:flutter/material.dart';

Future<void> showImageDialog(
  BuildContext context, {
  required ImageProvider image,
}) async {
  final size = MediaQuery.of(context).size;

  await showDialog(
    context: context,
    builder: (context) => Center(
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(12),
        child: Image(
          width: size.width * 0.8,
          height: size.width * 0.8,
          image: image,
        ),
      ),
    ),
  );
}
