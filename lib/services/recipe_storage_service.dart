import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:QuickChef/models/recipe.dart';

class RecipeStorageService {
  static const _favouritesKey = 'favourite_recipes';
  static const _recentKey = 'recent_recipes';

  Future<List<Recipe>> getFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_favouritesKey) ?? [];
    return jsonList.map((json) => Recipe.fromJson(jsonDecode(json))).toList();
  }

  Future<void> toggleFavourite(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_favouritesKey) ?? [];
    final jsonRecipe = jsonEncode(recipe.toJson());

    if (current.contains(jsonRecipe)) {
      current.remove(jsonRecipe);
    } else {
      current.add(jsonRecipe);
    }
    await prefs.setStringList(_favouritesKey, current);
  }

  Future<bool> isFavourite(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_favouritesKey) ?? [];
    return current.contains(jsonEncode(recipe.toJson()));
  }

  Future<void> saveRecentRecipes(List<Recipe> recipes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = recipes.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_recentKey, jsonList);
  }

  Future<List<Recipe>> getRecentRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_recentKey) ?? [];
    return jsonList.map((json) => Recipe.fromJson(jsonDecode(json))).toList();
  }
}
