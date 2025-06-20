import 'package:QuickChef/services/recipe_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:QuickChef/models/ingredient.dart';
import 'package:QuickChef/screens/loading_screen.dart';
import 'package:QuickChef/services/recipe_detection_service.dart';
import 'package:QuickChef/ui/custom_button.dart';
import 'package:QuickChef/ui/custom_text.dart';
import 'package:QuickChef/ui/custom_colors.dart';
import 'package:QuickChef/widgets/ingredient_card.dart';
import 'package:QuickChef/widgets/new_ingredient_card.dart';

class IngredientsScreen extends StatefulWidget {
  const IngredientsScreen({super.key});

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  List<Ingredient> ingredients = [];
  bool isAdding = false;

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
    await RecipeStorageService().saveRecentRecipes(recipes);

    if (!context.mounted) return;
    Navigator.popAndPushNamed(context, '/recipes', arguments: {
      'recipes': recipes,
    });
  }

  void _addIngredient(Ingredient ingredient) {
    setState(() {
      ingredients.add(ingredient);
      isAdding = false;
    });
  }

  void _removeIngredient(Ingredient ingredient) {
    setState(() {
      ingredients.remove(ingredient);
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
                        onDelete: () => _removeIngredient(item),
                      )),
                  if (isAdding)
                    NewIngredientCard(
                      onSubmit: _addIngredient,
                      onCancel: () => setState(() => isAdding = false),
                    ),
                  if (!isAdding)
                  GestureDetector(
                    onTap: () => setState(() => isAdding = true),
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
