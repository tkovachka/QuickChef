import 'package:QuickChef/ui/custom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:QuickChef/ui/custom_colors.dart';
import 'package:QuickChef/ui/custom_text.dart';
import 'package:QuickChef/widgets/recipe_card.dart';
import 'package:QuickChef/models/recipe.dart';
import 'package:QuickChef/services/recipe_storage_service.dart';

class MyFavouritesScreen extends StatefulWidget {
  const MyFavouritesScreen({super.key});

  @override
  State<MyFavouritesScreen> createState() => _MyFavouritesScreenState();
}

class _MyFavouritesScreenState extends State<MyFavouritesScreen> {
  final storage = RecipeStorageService();
  List<Recipe> favourites = [];

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    final favs = await storage.getFavourites();
    setState(() => favourites = favs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.cream,
          iconTheme: const IconThemeData(color: CustomColor.darkOrange),
          elevation: 0,
        ),
        backgroundColor: CustomColor.cream,
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              const TitleText(text: "My Favourites"),
              Expanded(
                child: ListView(
                  children: favourites
                      .map((r) => RecipeCard(
                            recipe: r,
                            onTap: () async {
                              Navigator.pushNamed(
                                context,
                                '/recipe_details',
                                arguments: r,
                              );
                              _loadFavourites();
                            }
                          ))
                      .toList(),
                ),
              )
            ])
        ),
        bottomNavigationBar: const CustomNavBar(currentRoute: '/favourites'),
    );
  }
}
