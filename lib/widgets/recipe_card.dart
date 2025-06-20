import 'package:flutter/material.dart';
import 'package:QuickChef/ui/custom_colors.dart';
import 'package:QuickChef/ui/custom_text.dart';
import 'package:QuickChef/models/recipe.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Card(
        margin: const EdgeInsets.all(8),
        color: CustomColor.white,
        child: Column(
          children: [
            Image.network(widget.recipe.imageUrl,
                width: double.infinity, height: 150, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  NormalText(text: widget.recipe.title),
                  NormalText(
                      text: '${widget.recipe.timeToMake} min',
                      color: CustomColor.orange),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
