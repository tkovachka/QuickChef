import 'package:QuickChef/models/ingredient.dart';

class IngredientDetectionService {
  Future<List<Ingredient>> detectIngredients(String imagePath) async {
    await Future.delayed(const Duration(seconds: 7));

    return [
      Ingredient(name: "Tomato", imageUrl: imagePath),
      Ingredient(name: "Cheese", imageUrl: imagePath),
    ];
  }
}
