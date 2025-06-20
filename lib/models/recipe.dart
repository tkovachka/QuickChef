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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'timeToMake': timeToMake,
      'ingredients': ingredients,
      'steps': steps,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      timeToMake: json['timeToMake'] as int,
      ingredients: List<String>.from(json['ingredients']),
      steps: List<String>.from(json['steps']),
    );
  }
}
