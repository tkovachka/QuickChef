import 'package:flutter/material.dart';
import 'package:QuickChef/ui/custom_colors.dart';
import 'package:QuickChef/ui/custom_text.dart';
import '../models/recipe.dart';

class RecipeDetailsScreen extends StatelessWidget {
  const RecipeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Recipe recipe = ModalRoute.of(context)!.settings.arguments as Recipe;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackButton(),
              TitleText(text: recipe.title),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  recipe.imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              NormalText(
                text: '${recipe.timeToMake} min',
                color: CustomColor.orange,
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.favorite_border,
                      color: CustomColor.darkOrange),
                  // dark orange
                  onPressed: () {
                    // TODO: implement favourites logic and state management
                  },
                ),
              ),
              const SizedBox(height: 8.0),
              const NormalText(
                text: "Ingredients:",
                color: CustomColor.orange,
              ),
              ...recipe.ingredients.map((ingredient) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: NormalText(
                      text: "• $ingredient",
                    ),
                  )),
              const SizedBox(height: 8.0),
              const NormalText(
                text: "Steps",
                color: CustomColor.orange,
              ),
              ...recipe.steps.asMap().entries.map((entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: NormalText(
                      text: "${entry.key + 1}. ${entry.value}",
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
