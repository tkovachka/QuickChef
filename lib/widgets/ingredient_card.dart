import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proekt/ui/custom_colors.dart';
import 'package:proekt/ui/custom_text.dart';

class IngredientCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback onDelete;

  const IngredientCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider imageProvider;

    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      imageProvider = NetworkImage(imageUrl);
    } else {
      imageProvider = FileImage(File(imageUrl));
    }

    return Card(
      color: CustomColor.white,
      child: ListTile(
        leading: CircleAvatar(backgroundImage: imageProvider),
        title: NormalText(text: name),
        trailing: IconButton(
          icon: const Icon(Icons.close, color: CustomColor.darkOrange),
          onPressed: onDelete,
          color: CustomColor.darkOrange,
        ),
      ),
    );
  }
}
