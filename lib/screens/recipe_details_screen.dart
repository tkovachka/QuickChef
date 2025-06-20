import 'package:QuickChef/services/recipe_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:QuickChef/ui/custom_colors.dart';
import 'package:QuickChef/ui/custom_text.dart';
import '../models/recipe.dart';

class RecipeDetailsScreen extends StatefulWidget {
  const RecipeDetailsScreen({super.key});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  late Recipe recipe;
  bool isFav = false;
  final storageService = RecipeStorageService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    recipe = ModalRoute.of(context)!.settings.arguments as Recipe;
    _loadFavourite();
  }

  Future<void> _loadFavourite() async {
    final fav = await storageService.isFavourite(recipe);
    if (mounted) {
      setState(() => isFav = fav);
    }
  }

  Future<void> _toggleFavourite() async {
    setState(() => isFav = !isFav);
    await storageService.toggleFavourite(recipe);
  }


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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalText(
                    text: '${recipe.timeToMake} min',
                    color: CustomColor.orange,
                  ),
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: CustomColor.darkOrange,
                    ),
                    onPressed: _toggleFavourite,
                  ),
                ],
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
