import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:QuickChef/ui/custom_colors.dart';
import 'package:QuickChef/ui/custom_text.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  List<String> messages = [];
  int currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute
          .of(context)
          ?.settings
          .arguments as Map<String, dynamic>?;
      final int messageGroup = args?['messageGroup'] ?? 1;
      messages = _getShuffledMessages(messageGroup);
      setState(() {
        currentIndex = 0;
      });

      _timer = Timer.periodic(const Duration(seconds: 3), (_) {
        if (mounted) {
          setState(() {
            currentIndex = (currentIndex + 1) % messages.length;
          });
        }
      });
    });
  }

  List<String> _getShuffledMessages(int group) {
    final List<String> ingredientMessages = [
      "Scanning the fridge like a detective...",
      "Is that leftovers or a science experiment?",
      "Is that mold or blue cheese?",
      "Playing hide and seek with vegetables...",
      "Investigating suspicious smells...",
      "Decoding mysterious containers...",
      "Looking into the fridge abyss...",
      "Reading expiration dates like tea leaves...",
      "Consulting the AI nutritionist...",
      "Identifying edible vs. questionable items...",
      "AI says: That's definitely not chocolate...",
      "Playing 'guess that green thing'...",
      "Enhancing pixels on potato quality...",
      "Running 'sniff test' algorithms...",
      "Spotting ingredients in the shadows...",
      "Running fridge diagnostics...",
      "Zooming in on suspicious cheese...",
      "Analyzing AI food pixels...",
      "Finding edible objects...",
      "Looking behind the milk carton...",
      "Reading barcodes with x-ray vision...",
      "Running image-to-ingredient pipeline...",
      "Extracting labels from chaos...",
      "Loading culinary vision..."
    ];

    final List<String> recipeMessages = [
      "Cooking up ideas...",
      "Plating recipes in style...",
      "Roasting bad suggestions...",
      "Grilling neural networks...",
      "Measuring taste probability...",
      "Sorting recipes by flavor...",
      "Prepping the perfect meal...",
      "Assembling your AI feast...",
      "Whisking up some magic...",
      "Stirring the pot of possibilities...",
      "Seasoning recipes with AI spice...",
      "Letting ideas marinate...",
      "Preheating the recipe generator...",
      "Kneading dough-licious suggestions...",
      "Simmering down to perfection...",
      "Grilling the competition...",
      "Flipping recipes like pancakes...",
      "Tossing salad suggestions around...",
      "Beating eggs-pectations...",
    ];

    final selected = group == 2 ? recipeMessages : ingredientMessages;
    final random = Random();
    final shuffled = [...selected]..shuffle(random);
    return shuffled;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.cream,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NormalText(
              text: messages[currentIndex],
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: CustomColor.darkOrange),
          ],
        ),
      ),
    );
  }
}
