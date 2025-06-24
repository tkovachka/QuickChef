import 'package:QuickChef/models/recipe.dart';
import 'package:QuickChef/models/ingredient.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:math';

class RecipeService {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final String _endpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=';
  final String _unsplashApiKey = dotenv.env['UNSPLASH_API_KEY'] ?? '';
  final String _unsplashEndpoint = 'https://api.unsplash.com/search/photos';

  static const Duration _timeout = Duration(seconds: 45);
  static const int _maxRetries = 3;

  Future<List<Recipe>> getRecipesFromIngredients(
      List<Ingredient> ingredients, {
        int recipeCount = 5,
        String? cuisine,
        String? difficulty,
        int? maxTime,
      }) async {

    if (_apiKey.isEmpty) {
      throw Exception('Gemini API key not configured');
    }

    if (_unsplashApiKey.isEmpty) {
      throw Exception('Unsplash API key not configured');
    }

    if (ingredients.isEmpty) {
      throw Exception('No ingredients provided');
    }

    if (recipeCount < 1 || recipeCount > 10) {
      throw Exception('Recipe count must be between 1 and 10');
    }

    try {
      final ingList = ingredients.map((e) => e.name.toUpperCase()).join(', ');
      final prompt = _buildRecipePrompt(ingList, recipeCount, cuisine, difficulty, maxTime);

      final payload = {
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.3,
          "topK": 40,
          "topP": 0.95,
          "candidateCount": 1,
          "maxOutputTokens": 4000,
        },
        "safetySettings": [
          {
            "category": "HARM_CATEGORY_HARASSMENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          },
          {
            "category": "HARM_CATEGORY_HATE_SPEECH",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          }
        ]
      };

      final response = await _makeRequestWithRetry(payload);
      final recipes = _parseRecipesResponse(response);

      final recipesWithImages = await Future.wait(
          recipes.map((recipe) => _addImageToRecipe(recipe))
      );

      return recipesWithImages;

    } catch (e) {
      throw Exception('Failed to generate recipes: ${e.toString()}');
    }
  }

  String _buildRecipePrompt(String ingredients, int count, String? cuisine, String? difficulty, int? maxTime) {
    final basePrompt = """
Create $count unique recipes using these available ingredients: $ingredients

REQUIREMENTS:
- Return ONLY a valid JSON array of recipes
- Each recipe must follow this EXACT structure
- Use realistic cooking times and clear step-by-step instructions
- Include ingredient quantities in the ingredients list
- Steps should be detailed and numbered
- Generate unique recipe IDs
- Do NOT include imageUrl field (images will be added separately)""";

    String constraints = "";
    if (cuisine != null) constraints += "\n- Cuisine style: $cuisine";
    if (difficulty != null) constraints += "\n- Difficulty level: $difficulty";
    if (maxTime != null) constraints += "\n- Maximum cooking time: $maxTime minutes";

    return """$basePrompt$constraints

JSON FORMAT (return this exact structure):
[
  {
    "id": "recipe_001",
    "title": "Descriptive Recipe Name",
    "timeToMake": 25,
    "ingredients": ["2 cups FLOUR", "1 cup MILK", "3 EGGS", "1 tsp SALT"],
    "steps": [
      "Preheat oven to 350°F (175°C)",
      "In a large bowl, whisk together flour and salt",
      "In another bowl, beat eggs and milk until well combined",
      "Gradually add wet ingredients to dry ingredients, mixing until smooth",
      "Pour batter into greased baking dish",
      "Bake for 25-30 minutes until golden brown",
      "Let cool for 5 minutes before serving"
    ]
  }
]

IMPORTANT:
- Do NOT include imageUrl in the response
- Include cooking temperatures and times in steps
- Make ingredients list specific with quantities
- Each recipe should have 5-10 detailed steps
- Ensure JSON is valid and properly formatted
- Only use the ingredients provided in the input""";
  }

  Future<http.Response> _makeRequestWithRetry(Map<String, dynamic> payload) async {
    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        final response = await http.post(
          Uri.parse("$_endpoint$_apiKey"),
          headers: {
            'Content-Type': 'application/json',
            'User-Agent': 'QuickChef/1.0',
          },
          body: jsonEncode(payload),
        ).timeout(_timeout);

        if (response.statusCode == 200) {
          return response;
        } else if (response.statusCode == 429 && attempt < _maxRetries) {
          // Rate limit - exponential backoff
          await Future.delayed(Duration(seconds: attempt * 3));
          continue;
        } else {
          throw Exception('API request failed: ${response.statusCode} - ${response.body}');
        }

      } on SocketException {
        if (attempt == _maxRetries) rethrow;
        await Future.delayed(Duration(seconds: attempt * 2));
      } on http.ClientException {
        if (attempt == _maxRetries) rethrow;
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }

    throw Exception('All retry attempts failed');
  }

  Future<String> _getUnsplashImage(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_unsplashEndpoint?query=${Uri.encodeComponent(query)}&per_page=10&orientation=landscape'),
        headers: {
          'Authorization': 'Client-ID $_unsplashApiKey',
          'Accept-Version': 'v1',
        },
      ).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List?;

        if (results != null && results.isNotEmpty) {
          final randomIndex = Random().nextInt(results.length);
          final imageUrl = results[randomIndex]['urls']['regular'] as String?;

          if (imageUrl != null) {
            return imageUrl;
          }
        }
      }

      return _getDefaultImageUrl();

    } catch (e) {
      print('Failed to fetch Unsplash image for query "$query": $e');
      return _getDefaultImageUrl();
    }
  }

  Future<Recipe> _addImageToRecipe(Recipe recipe) async {
    final searchQuery = _extractImageKeywords(recipe.title);
    final imageUrl = await _getUnsplashImage(searchQuery);

    return Recipe(
      id: recipe.id,
      title: recipe.title,
      imageUrl: imageUrl,
      timeToMake: recipe.timeToMake,
      ingredients: recipe.ingredients,
      steps: recipe.steps,
    );
  }

  String _extractImageKeywords(String recipeTitle) {
    String cleaned = recipeTitle.toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), ' ') // Remove punctuation
        .replaceAll(RegExp(r'\s+'), ' ') // Normalize spaces
        .trim();

    final stopWords = {
      'quick', 'easy', 'simple', 'delicious', 'homemade', 'fresh', 'crispy',
      'creamy', 'spicy', 'sweet', 'savory', 'perfect', 'classic', 'traditional',
      'recipe', 'dish', 'with', 'and', 'or', 'the', 'a', 'an', 'for', 'in', 'on'
    };

    final words = cleaned.split(' ')
        .where((word) => word.length > 2 && !stopWords.contains(word))
        .take(3)
        .toList();

    words.add('food');

    return words.join(' ');
  }

  List<Recipe> _parseRecipesResponse(http.Response response) {
    try {
      final responseData = jsonDecode(response.body);

      if (responseData['error'] != null) {
        throw Exception('Gemini API error: ${responseData['error']['message']}');
      }

      final candidates = responseData['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        throw Exception('No response from Gemini API');
      }

      final content = candidates[0]['content']?['parts']?[0]?['text'] as String?;
      if (content == null || content.trim().isEmpty) {
        throw Exception('Empty response from Gemini API');
      }

      // Clean and parse JSON
      final cleanContent = _cleanJsonResponse(content);
      final recipesRaw = jsonDecode(cleanContent) as List;

      if (recipesRaw.isEmpty) {
        throw Exception('No recipes generated');
      }

      return recipesRaw.map((recipeData) {
        return _parseRecipe(recipeData);
      }).where((recipe) => recipe != null).cast<Recipe>().toList();

    } catch (e) {
      throw Exception('Failed to parse recipes response: ${e.toString()}');
    }
  }

  String _cleanJsonResponse(String content) {
    // Remove markdown code blocks
    String cleaned = content
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'\s*```'), '')
        .trim();

    // Find JSON array pattern
    final jsonMatch = RegExp(r'\[[\s\S]*\]').firstMatch(cleaned);
    if (jsonMatch != null) {
      return jsonMatch.group(0)!;
    }

    // If no array found, try to find individual objects and wrap them
    final objectMatches = RegExp(r'\{[\s\S]*?\}').allMatches(cleaned);
    if (objectMatches.isNotEmpty) {
      final objects = objectMatches.map((m) => m.group(0)).join(',');
      return '[$objects]';
    }

    return cleaned;
  }

  Recipe? _parseRecipe(dynamic recipeData) {
    try {
      if (recipeData is! Map<String, dynamic>) {
        return null;
      }

      // Validate required fields
      final id = recipeData['id']?.toString() ?? _generateRecipeId();
      final title = recipeData['title']?.toString();
      final timeToMake = recipeData['timeToMake'] as int?;
      final ingredients = recipeData['ingredients'] as List?;
      final steps = recipeData['steps'] as List?;

      if (title == null || timeToMake == null || ingredients == null || steps == null) {
        return null;
      }

      return Recipe(
        id: id,
        title: title,
        imageUrl: '', //replaces with unsplash url later
        timeToMake: timeToMake,
        ingredients: ingredients.cast<String>(),
        steps: steps.cast<String>(),
      );

    } catch (e) {
      return null;
    }
  }

  String _generateRecipeId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(9999);
    return 'recipe_${timestamp}_$random';
  }

  String _getDefaultImageUrl() {
    final defaultImages = [
      'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&q=80',
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=80',
      'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&q=80',
      'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400&q=80',
    ];
    return defaultImages[Random().nextInt(defaultImages.length)];
  }

}