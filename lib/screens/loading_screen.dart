import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:proekt/ui/custom_colors.dart';
import 'package:proekt/ui/custom_text.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late List<String> messages;
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
      "Scanning the fridge...",
      "Enhancing contrast on tomatoes...",
      "Is that mold or blue cheese?",
      "Looking into the fridge abyss...",
      "Checking for expired hopes...",
      "Detecting hidden vegetables...",
      "Consulting the AI nutritionist...",
      "Spotting ingredients in the shadows...",
      "Running fridge diagnostics...",
      "Zooming in on suspicious cheese...",
      "Analyzing AI food pixels...",
      "Finding edible objects...",
      "Asking AI to guess your dinner...",
      "Checking calorie levels...",
      "Looking behind the milk carton...",
      "Identifying leftover mysteries...",
      "Reading barcodes with x-ray vision...",
      "Running image-to-ingredient pipeline...",
      "Extracting labels from chaos...",
      "Loading culinary vision..."
    ];

    final List<String> recipeMessages = [
      "Cooking up ideas...",
      "Plating recipes in style...",
      "Baking inspiration...",
      "Mixing delicious code...",
      "Roasting bad suggestions...",
      "Garnishing possibilities...",
      "Grilling neural networks...",
      "Simmering your best match...",
      "Measuring taste probability...",
      "AI tasting in progress...",
      "Reducing overthinking to a sauce...",
      "Cooking with logic and love...",
      "Preheating creativity...",
      "Sorting recipes by flavor...",
      "Slicing and dicing instructions...",
      "Prepping the perfect meal...",
      "Rolling out culinary genius...",
      "Linking ingredients to magic...",
      "Assembling your AI feast...",
      "Whisking your options..."
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
