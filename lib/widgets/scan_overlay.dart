import 'package:flutter/material.dart';

class ScanOverlay extends StatefulWidget {
  final bool isDetecting;

  const ScanOverlay({super.key, required this.isDetecting});

  @override
  State<ScanOverlay> createState() => _ScanOverlayState();
}

class _ScanOverlayState extends State<ScanOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      lowerBound: 0.8,
      upperBound: 1.0,
    );
  }

  @override
  void didUpdateWidget(covariant ScanOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isDetecting) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: ScaleTransition(
          scale: _controller,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isDetecting
                    ? Colors.greenAccent
                    : Colors.white,
                width: 4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
