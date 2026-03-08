import 'package:afui/afui.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String hintText;
  final IconData? prefixIcon;
  const AppTextField({
    super.key,
    this.focusNode,
    this.controller,
    required this.hintText,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.spacing.s5),
      padding: EdgeInsets.all(context.spacing.s1),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(context.radius.md),
      ),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: prefixIcon != null
                ? context.spacing.s1
                : context.spacing.s4,
            vertical: context.spacing.s3,
          ),
          hintText: hintText,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        ),
      ),
    );
  }
}
