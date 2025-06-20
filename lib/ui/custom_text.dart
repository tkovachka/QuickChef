

import 'package:flutter/cupertino.dart';
import 'package:QuickChef/ui/custom_colors.dart';

class TitleText extends StatelessWidget{
  final String text;

  const TitleText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: CustomColor.darkBrown
      ),
    );
  }

}

class NormalText extends StatelessWidget{
  final String text;
  final double? size;
  final Color? color;
  final VoidCallback? onPressed;

  const NormalText({super.key, required this.text, this.size, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: size ?? 16,
          fontWeight: FontWeight.bold,
          color: color ?? CustomColor.brown
      ),
    );
  }
}
