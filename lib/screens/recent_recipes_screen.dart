import 'package:flutter/material.dart';
import 'package:QuickChef/ui/custom_colors.dart';
import 'package:QuickChef/ui/custom_text.dart';
import 'package:QuickChef/widgets/recipe_card.dart';
import 'package:QuickChef/models/recipe.dart';
import 'package:QuickChef/services/recipe_storage_service.dart';

class RecentRecipesScreen extends StatefulWidget {
  const RecentRecipesScreen({super.key});

  @override
  State<RecentRecipesScreen> createState() => _RecentRecipesScreenState();
}

class _RecentRecipesScreenState extends State<RecentRecipesScreen> {
  final storage = RecipeStorageService();
  List<Recipe> recent = [];

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    final recents = await storage.getRecentRecipes();
    setState(() => recent = recents);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.cream,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
          color: CustomColor.darkOrange,
        ),
      ),
      backgroundColor: CustomColor.cream,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          const TitleText(text: "Recent Recipes"),
          Expanded(
            child: ListView(
              children: recent
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
        ]),
      ),
    );
  }
}
