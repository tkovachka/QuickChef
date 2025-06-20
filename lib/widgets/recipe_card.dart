import 'dart:io';

import 'package:flutter/material.dart';
import 'package:QuickChef/ui/custom_colors.dart';
import 'package:QuickChef/ui/custom_text.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int timeToMake;
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.timeToMake,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(8),
        color: CustomColor.white,
        child: Column(
          children: [
            Image.network(imageUrl,
                width: double.infinity, height: 150, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  NormalText(text: title),
                  NormalText(text:'$timeToMake min', color: CustomColor.orange),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
