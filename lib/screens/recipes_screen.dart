import 'package:QuickChef/ui/custom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:QuickChef/ui/custom_colors.dart';
import 'package:QuickChef/ui/custom_text.dart';
import 'package:QuickChef/widgets/recipe_card.dart';
import 'package:QuickChef/models/recipe.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final recipes = (args?['recipes'] as List<Recipe>?) ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: CustomColor.darkOrange),
      ),
      body: Column(
        children: [
          const TitleText(text: "Recipe Suggestions"),
          Expanded(
            child: ListView(
              children: recipes
                  .map((r) => RecipeCard(
                        recipe: r,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/recipe_details',
                          arguments: r,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavBar(currentRoute: '/recent'),
    );
  }
}
