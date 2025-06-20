import 'package:flutter/material.dart';
import 'package:proekt/models/ingredient.dart';
import 'package:proekt/screens/loading_screen.dart';
import 'package:proekt/services/recipe_detection_service.dart';
import 'package:proekt/ui/custom_button.dart';
import 'package:proekt/ui/custom_text.dart';
import 'package:proekt/ui/custom_colors.dart';
import 'package:proekt/widgets/ingredient_card.dart';

class IngredientsScreen extends StatefulWidget {
  const IngredientsScreen({super.key});

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  List<Ingredient> ingredients = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    ingredients = (args?['ingredients'] as List<Ingredient>?) ?? [];
  }

  void _findRecipes() async {
    Navigator.pushNamed(
      context,
      '/loading',
      arguments: {'messageGroup':2}
    );

    final recipes = await RecipeService().getRecipesFromIngredients(ingredients);

    if (!context.mounted) return;
    Navigator.popAndPushNamed(context, '/recipes', arguments: {
      'recipes': recipes,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.cream,
      appBar: AppBar(
        backgroundColor: CustomColor.cream,
        elevation: 0,
        iconTheme: const IconThemeData(color: CustomColor.darkOrange),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TitleText(text: "Ingredients detected"),
            Expanded(
              child: ListView(
                children: [
                  ...ingredients.map((item) => IngredientCard(
                        ingredient: item,
                        onDelete: () {},
                      )),
                  GestureDetector(
                    onTap: () {
                      //todo add new ingredient
                    },
                    child: const NormalText(
                        text: "+ Add Ingredient",
                        color: CustomColor.darkOrange),
                  ),
                ],
              ),
            ),
            CustomButton(
              text: "Find Recipes",
              onPressed: _findRecipes,
            ),
          ],
        ),
      ),
    );
  }
}
