import 'package:flutter/material.dart';
import 'package:afui/afui.dart';

void appTopSnackBar(
  BuildContext context,
  String message, {
  Color? color,
  Duration duration = const Duration(seconds: 3),
}) {
  final overlay = Overlay.of(context);

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) {
      return Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: _TopSnackBarWidget(
          message: message,
          color: color ?? context.af.colors.errorContainer,
          duration: duration,
          onDismiss: () {
            entry.remove();
          },
        ),
      );
    },
  );

  overlay.insert(entry);
}

class _TopSnackBarWidget extends StatefulWidget {
  final String message;
  final Color color;
  final Duration duration;
  final VoidCallback onDismiss;

  const _TopSnackBarWidget({
    required this.message,
    required this.color,
    required this.onDismiss,
    required this.duration,
  });

  @override
  State<_TopSnackBarWidget> createState() => _TopSnackBarWidgetState();
}

class _TopSnackBarWidgetState extends State<_TopSnackBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<Offset> slide;
  late Animation<double> fade;
  late Animation<double> scale;

  bool dismissed = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    slide = Tween(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ),
    );

    fade = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );

    scale = Tween(
      begin: 0.85,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ),
    );

    controller.forward();

    Future.delayed(widget.duration, () {
      dismiss();
    });
  }

  void dismiss() {
    if (dismissed) return;

    dismissed = true;

    controller.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < -6) {
          dismiss();
        }
      },
      child: SlideTransition(
        position: slide,
        child: FadeTransition(
          opacity: fade,
          child: ScaleTransition(
            scale: scale,
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: IntrinsicWidth(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 14,
                          spreadRadius: 0,
                          color: Colors.black26,
                          offset: Offset(0, 6),
                        )
                      ],
                    ),
                    child: Text(
                      widget.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.af.colors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}