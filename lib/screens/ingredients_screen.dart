import 'package:flutter/material.dart';
import 'package:proekt/ui/custom_button.dart';
import 'package:proekt/ui/custom_text.dart';
import 'package:proekt/ui/custom_colors.dart';
import 'package:proekt/widgets/ingredient_card.dart';

class IngredientsScreen extends StatelessWidget {
  //todo get actual ingredients from service
  const IngredientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? imagePath = ModalRoute.of(context)?.settings.arguments as String?;

    debugPrint("Received image path: $imagePath");

    final List<Map<String, String>> ingredients = [
      {'name': 'Tomato', 'img': imagePath ?? 'https://via.placeholder.com/50'},
      {'name': 'Cheese', 'img': imagePath ?? 'https://via.placeholder.com/50'},
    ];

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
                    name: item['name']!,
                    imageUrl: item['img']!,
                    onDelete: () {},
                  )),
                  GestureDetector(
                    onTap: () {
                      //todo add new ingredient
                    },
                    child: const NormalText(text: "+ Add Ingredient", color: CustomColor.darkOrange),
                  ),
                ],
              ),
            ),
            CustomButton(
                text: "Find Recipes",
                //todo send to ai service for recipes and show loading screen
                onPressed: () => Navigator.pushNamed(context, '/recipes', arguments: ingredients),
            ),
          ],
        ),
      ),
    );
  }
}
