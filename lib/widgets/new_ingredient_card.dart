import 'package:flutter/material.dart';
import 'package:proekt/models/ingredient.dart';
import 'package:proekt/ui/custom_colors.dart';

class NewIngredientCard extends StatefulWidget {
  final void Function(Ingredient) onSubmit;
  final VoidCallback onCancel;

  const NewIngredientCard({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<NewIngredientCard> createState() => _NewIngredientCardState();
}

class _NewIngredientCardState extends State<NewIngredientCard> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      final newIngredient = Ingredient(name: name, imageUrl: '');
      widget.onSubmit(newIngredient);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomColor.white,
      child: ListTile(
        leading: const Icon(Icons.edit, color: CustomColor.darkOrange),
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Ingredient name',
            border: InputBorder.none,
          ),
          autofocus: true,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: _submit,
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: widget.onCancel,
            ),
          ],
        ),
      ),
    );
  }
}
