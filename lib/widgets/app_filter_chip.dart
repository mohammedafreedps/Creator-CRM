import 'package:afui/afui.dart';
import 'package:flutter/material.dart';

class AppFilterChip extends StatelessWidget {

  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const AppFilterChip({
    super.key,
    required this.isSelected,
    required this.label,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left : context.af.spacing.s2),
      child: FilterChip(
        selected: isSelected,
        showCheckmark: false,
        side: BorderSide.none,
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.s2,
          vertical: context.spacing.s1,
        ),
        label: Text(label),
        onSelected: onSelected, 
      ),
    );
  }
}