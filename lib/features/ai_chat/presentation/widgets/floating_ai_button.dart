import 'package:flutter/material.dart';
import 'package:nabd/core/constants/app_assets.dart';

class FloatingAiButton extends StatefulWidget {
  const FloatingAiButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<FloatingAiButton> createState() => _FloatingAiButtonState();
}

class _FloatingAiButtonState extends State<FloatingAiButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  // Position
  double _xPosition = 16;
  double _yPosition = 100;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      right: _xPosition,
      bottom: _yPosition,
      child: GestureDetector(
        onTap: _isDragging ? null : widget.onTap,
        onPanStart: (_) {
          setState(() {
            _isDragging = true;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            // تحديث الموقع (right و bottom)
            _xPosition -= details.delta.dx;
            _yPosition -= details.delta.dy;

            // حدود الشاشة
            _xPosition = _xPosition.clamp(16, screenWidth - 76);
            _yPosition = _yPosition.clamp(100, screenHeight - 200);
          });
        },
        onPanEnd: (_) {
          setState(() {
            _isDragging = false;
          });

          // Snap to left or right edge
          if (_xPosition < (screenWidth / 2) - 30) {
            setState(() {
              _xPosition =
                  screenWidth - 76; // Left side (remember: we use 'right')
            });
          } else {
            setState(() {
              _xPosition = 16; // Right side
            });
          }
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isDragging ? 1.2 : _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _isDragging
                          ? Colors.blue.withOpacity(0.6)
                          : Colors.blue.withOpacity(0.4),
                      blurRadius: _isDragging ? 24 : 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(AppAssets.aibot, fit: BoxFit.cover),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
