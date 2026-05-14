import 'package:flutter/material.dart';

/// Átomo reutilizable: checkbox con etiqueta de texto.
class CheckboxPersonalizado extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CheckboxPersonalizado({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(value: value, onChanged: onChanged),
          Flexible(
            child: Text(label, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
