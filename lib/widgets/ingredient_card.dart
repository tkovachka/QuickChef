import 'dart:io';
import 'package:flutter/material.dart';
import 'package:proekt/models/ingredient.dart';
import 'package:proekt/ui/custom_colors.dart';
import 'package:proekt/ui/custom_text.dart';

class IngredientCard extends StatelessWidget {
  final Ingredient ingredient;
  final VoidCallback onDelete;

  const IngredientCard({
    super.key,
    required this.ingredient,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider imageProvider;

    if (ingredient.imageUrl.startsWith('http') || ingredient.imageUrl.startsWith('https')) {
      imageProvider = NetworkImage(ingredient.imageUrl);
    } else {
      imageProvider = FileImage(File(ingredient.imageUrl));
    }

    return Card(
      color: CustomColor.white,
      child: ListTile(
        leading: CircleAvatar(backgroundImage: imageProvider),
        title: NormalText(text: ingredient.name),
        trailing: IconButton(
          icon: const Icon(Icons.close, color: CustomColor.darkOrange),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
