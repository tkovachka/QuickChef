import 'package:proekt/models/recipe.dart';
import 'package:proekt/models/ingredient.dart';

class RecipeService {
  Future<List<Recipe>> getRecipesFromIngredients(List<Ingredient> ingredients) async {
    await Future.delayed(const Duration(seconds: 7));

    return [
      Recipe(
        id: '1',
        title: 'Tomato Pasta',
        imageUrl: 'https://cdn.apartmenttherapy.info/image/upload/f_jpg,q_auto:eco,c_fill,g_auto,w_1500,ar_4:3/k%2FPhoto%2FRecipes%2F2023-01-Caramelized-Tomato-Paste-Pasta%2F06-CARAMELIZED-TOMATO-PASTE-PASTA-039',
        timeToMake: 25,
        ingredients: ['Tomato', 'Pasta'],
        steps: ['Boil pasta', 'Add tomato sauce'],
      ),
      Recipe(
        id: '2',
        title: 'Cheesy Omelette',
        imageUrl: 'https://cheeseknees.com/wp-content/uploads/2021/09/Cheese-Omelette-1-1.jpg',
        timeToMake: 15,
        ingredients: ['Eggs', 'Cheese'],
        steps: ['Beat eggs', 'Add cheese', 'Cook on pan'],
      ),
    ];
  }
}
