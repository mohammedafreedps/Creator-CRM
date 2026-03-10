import 'package:afui/afui.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? initialValue;
  final String hintText;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    this.focusNode,
    this.controller,
    this.initialValue,
    required this.hintText,
    this.prefixIcon,
    this.onChanged,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        widget.controller ??
        TextEditingController(text: widget.initialValue ?? "");
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialValue != oldWidget.initialValue &&
        widget.controller == null) {
      _controller.text = widget.initialValue ?? "";
    }
  }

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
        focusNode: widget.focusNode,
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: widget.prefixIcon != null
                ? context.spacing.s1
                : context.spacing.s4,
            vertical: context.spacing.s3,
          ),
          hintText: widget.hintText,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        ),
      ),
    );
  }
}