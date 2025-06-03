import 'package:flutter/material.dart';
import 'package:proekt/ui/custom_colors.dart';
import 'package:proekt/ui/custom_text.dart';
import 'package:proekt/widgets/recipe_card.dart';
import 'package:proekt/models/recipe.dart';

class RecipesScreen extends StatelessWidget {
  //todo get recipes from ai service
  final List<Recipe> recipes = [
    Recipe(
      id: '1',
      title: 'Spaghetti',
      imageUrl: 'https://via.placeholder.com/300',
      timeToMake: 30,
      ingredients: ['Tomato', 'Pasta'],
      steps: ['Boil water', 'Cook pasta'],
    ),
    Recipe(
      id: '2',
      title: 'Salad',
      imageUrl: 'https://via.placeholder.com/300',
      timeToMake: 10,
      ingredients: ['Lettuce', 'Tomato'],
      steps: ['Mix ingredients'],
    ),
  ];

  RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.cream,
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
                        title: r.title,
                        imageUrl: r.imageUrl,
                        timeToMake: r.timeToMake,
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
    );
  }
}
