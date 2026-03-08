import 'package:afui/afui.dart';
import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final VoidCallback? onClear;
  final IconData? prefixIcon;

  const AppDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.value,
    this.onClear,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.spacing.s5),
      padding: EdgeInsets.symmetric(horizontal: context.spacing.s2),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(context.radius.md),
      ),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: value != null
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClear,
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.spacing.s2,
            vertical: context.spacing.s3,
          ),
        ),
      ),
    );
  }
}