import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:QuickChef/models/ingredient.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IngredientDetectionService {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final String _endpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=';

  static const Duration _timeout = Duration(seconds: 30);
  static const int _maxRetries = 3;

  Future<List<Ingredient>> detectIngredients(String imagePath) async {
    if (_apiKey.isEmpty) {
      throw Exception('Gemini API key not configured');
    }

    if (!await File(imagePath).exists()) {
      throw Exception('Image file does not exist');
    }

    try {
      final imageBytes = await File(imagePath).readAsBytes();

      // Validate file size (max 20MB for Gemini)
      if (imageBytes.length > 20 * 1024 * 1024) {
        throw Exception('Image file too large (max 20MB)');
      }

      final base64Image = base64Encode(imageBytes);

      const prompt = """
Analyze this food image and identify ALL visible ingredients. 
Return ONLY a JSON array of ingredient names with a first uppercase letter.
Include both primary ingredients and visible seasonings/garnishes.
Focus on actual food items, not cooking utensils or plates.

Format: ["INGREDIENT1", "INGREDIENT2", "INGREDIENT3"]

Be specific (e.g., "RED BELL PEPPER" not just "PEPPER").
""";

      final payload = {
        "contents": [
          {
            "parts": [
              {"text": prompt},
              {
                "inlineData": {
                  "mimeType": _getMimeType(imagePath),
                  "data": base64Image
                }
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.1,
          "topK": 40,
          "topP": 0.95,
          "candidateCount": 1,
          "maxOutputTokens": 500,
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
      return _parseIngredientsResponse(response, imagePath);

    } catch (e) {
      throw Exception('Failed to detect ingredients: ${e.toString()}');
    }
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
          // Rate limit hit - wait before retry
          await Future.delayed(Duration(seconds: attempt * 2));
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

  List<Ingredient> _parseIngredientsResponse(http.Response response, String imagePath) {
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

      try {
        final cleanContent = _cleanJsonResponse(content);
        final ingredientsList = jsonDecode(cleanContent) as List;

        return ingredientsList
            .where((item) => item is String && item.trim().isNotEmpty)
            .map((name) => Ingredient(
            name: (name as String).trim(),
            imageUrl: imagePath
        ))
            .toList();

      } catch (jsonError) {
        return _parseTextResponse(content, imagePath);
      }

    } catch (e) {
      throw Exception('Failed to parse API response: ${e.toString()}');
    }
  }

  String _cleanJsonResponse(String content) {
    // Remove markdown code blocks if present
    String cleaned = content.replaceAll(RegExp(r'```json\s*'), '').replaceAll(RegExp(r'\s*```'), '');

    // Find JSON array pattern
    final jsonMatch = RegExp(r'\[[\s\S]*\]').firstMatch(cleaned);
    return jsonMatch?.group(0) ?? cleaned;
  }

  List<Ingredient> _parseTextResponse(String content, String imagePath) {
    final lines = content.split(RegExp(r'\n|,'));
    return lines
        .where((line) => line.trim().isNotEmpty)
        .map((line) {
      // Clean up bullet points, numbers, etc.
      String cleaned = line.trim()
          .replaceAll(RegExp(r'^[-*•]\s*'), '')
          .replaceAll(RegExp(r'^\d+\.\s*'), '');

      return Ingredient(
      name: cleaned.toUpperCase(),
          imageUrl: imagePath
      );
    })
        .where((ingredient) => ingredient.name.isNotEmpty)
        .toList();
  }

  String _getMimeType(String imagePath) {
    final extension = imagePath.toLowerCase().split('.').last;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      default:
        return 'image/jpeg'; // Default fallback
    }
  }
}