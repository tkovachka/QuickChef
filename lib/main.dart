import 'package:flutter/material.dart';
import 'package:QuickChef/screens/loading_screen.dart';
import 'package:QuickChef/ui/custom_colors.dart';
import 'screens/home_screen.dart';
import 'screens/picture_screen.dart';
import 'screens/ingredients_screen.dart';
import 'screens/recipes_screen.dart';
import 'screens/recipe_details_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'assets',
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: CustomColor.cream),
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      routes: {
        '/home': (_) => const HomeScreen(),
        '/picture': (_) => const PictureScreen(),
        '/loading': (_) => const LoadingScreen(),
        '/ingredients': (_) => const IngredientsScreen(),
        '/recipes': (_) => const RecipesScreen(),
        '/recipe_details': (_) => const RecipeDetailsScreen(),
        '/favourites': (_) => const Placeholder(), // todo change to faves
        '/recent': (_) => const Placeholder(), // todo change to recent
      },
    );
  }
}
