class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final int timeToMake;
  final List<String> ingredients;
  final List<String> steps;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.timeToMake,
    required this.ingredients,
    required this.steps,
  });
}
