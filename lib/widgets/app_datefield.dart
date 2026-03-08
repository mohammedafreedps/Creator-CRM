import 'package:afui/afui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDateField extends StatefulWidget {
  final String hintText;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final IconData? prefixIcon;
  final VoidCallback? onClear;

  const AppDateField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.value,
    this.prefixIcon,
    this.onClear,
  });

  @override
  State<AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  DateTime? selectedDate;

  @override
  void initState() {
    selectedDate = widget.value;
    super.initState();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });

      widget.onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? text =
        selectedDate != null ? DateFormat('dd MMM yyyy').format(selectedDate!) : null;

    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        margin: EdgeInsets.only(bottom: context.spacing.s5),
        padding: EdgeInsets.all(context.spacing.s1),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(context.radius.md),
        ),
        child: InputDecorator(
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
            suffixIcon: selectedDate != null
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        selectedDate = null;
                      });
                      widget.onChanged(null);
                      widget.onClear?.call();
                    },
                  )
                : const Icon(Icons.calendar_today),
            contentPadding: EdgeInsets.symmetric(
              horizontal: widget.prefixIcon != null
                  ? context.spacing.s1
                  : context.spacing.s4,
              vertical: context.spacing.s3,
            ),
          ),
          child: Text(
            text ?? widget.hintText,
            style: text != null
                ? Theme.of(context).textTheme.bodyMedium
                : Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
          ),
        ),
      ),
    );
  }
}