import 'package:QuickChef/screens/favourites_screen.dart';
import 'package:QuickChef/screens/recent_recipes_screen.dart';
import 'package:flutter/material.dart';
import 'package:QuickChef/screens/loading_screen.dart';
import 'package:QuickChef/ui/custom_colors.dart';
import 'package:QuickChef/screens/home_screen.dart';
import 'package:QuickChef/screens/picture_screen.dart';
import 'package:QuickChef/screens/ingredients_screen.dart';
import 'package:QuickChef/screens/recipes_screen.dart';
import 'package:QuickChef/screens/recipe_details_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

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
        '/favourites': (_) => const MyFavouritesScreen(),
        '/recent': (_) => const RecentRecipesScreen(),
      },
    );
  }
}
