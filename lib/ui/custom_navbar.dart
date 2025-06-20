import 'package:flutter/material.dart';
import 'package:QuickChef/ui/custom_colors.dart';

class CustomNavBar extends StatelessWidget {
  final String currentRoute;

  const CustomNavBar({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: CustomColor.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            context,
            icon: Icons.home,
            route: '/home',
            isActive: currentRoute == '/home',
          ),
          _buildNavItem(
            context,
            icon: Icons.favorite,
            route: '/favourites',
            isActive: currentRoute == '/favourites',
          ),
          _buildNavItem(
            context,
            icon: Icons.history,
            route: '/recent',
            isActive: currentRoute == '/recent',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, {
        required IconData icon,
        required String route,
        required bool isActive,
      }) {
    return GestureDetector(
      onTap: () {
          if (currentRoute != route) {
            if (route == '/home') {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            } else {
              Navigator.pushReplacementNamed(context, route);
            }
          }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Icon(
          icon,
          color: isActive ? CustomColor.orange : CustomColor.brown,
          size: 28,
        ),
      ),
    );
  }
}