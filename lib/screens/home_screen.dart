import 'package:flutter/material.dart';
import 'package:QuickChef/ui/custom_button.dart';
import 'package:QuickChef/ui/custom_colors.dart';
import 'package:QuickChef/ui/custom_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 110,
                fit: BoxFit.contain,
              ),
              const NormalText(text: "QuickChef", size: 20, color:CustomColor.darkOrange),
              const SizedBox(height: 40),
              const TitleText(text: "What's cooking today?"),
              const SizedBox(height: 40),
              CustomButton(
                onPressed: () => Navigator.pushNamed(context, '/picture'),
                text: "Snap Ingredients",
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/favorites');
                },
                child: const NormalText(text: "My Favorites", color: CustomColor.darkOrange),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/recipes');
                },
                child: const NormalText(text: "Recent Recipes", color: CustomColor.darkOrange),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
