import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class SidebarIconData {
  final IconData icon;
  final String tooltip;

  const SidebarIconData({required this.icon, required this.tooltip});
}

class RadialSidebar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<SidebarIconData> icons;
  final bool isExpanded;
  final VoidCallback onToggle;

  const RadialSidebar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.icons,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  State<RadialSidebar> createState() => _RadialSidebarState();
}

class _RadialSidebarState extends State<RadialSidebar>
    with TickerProviderStateMixin {
  late AnimationController _staggeredController;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _fadeAnimations;

  static const double _triggerRadius = 26;
  static const double _iconSize = 52;
  static const double _arcRadius = 130;
  static const double _arcStartAngle = -80 * pi / 180;
  static const double _arcEndAngle = 80 * pi / 180;
  int get _iconCount => widget.icons.length;
  static const Duration _animDuration = Duration(milliseconds: 400);
  static const Duration _staggerDelay = Duration(milliseconds: 50);

  @override
  void initState() {
    super.initState();
    _staggeredController = AnimationController(
      duration: _animDuration,
      vsync: this,
    );

    _scaleAnimations = List.generate(_iconCount, (i) {
      final start =
          i * _staggerDelay.inMilliseconds / _animDuration.inMilliseconds;
      final end = (start + 0.5).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggeredController,
          curve: Interval(start, end, curve: Curves.easeOutBack),
        ),
      );
    });

    _fadeAnimations = List.generate(_iconCount, (i) {
      final start =
          i * _staggerDelay.inMilliseconds / _animDuration.inMilliseconds;
      final end = (start + 0.3).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggeredController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });
  }

  @override
  void didUpdateWidget(covariant RadialSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded && !oldWidget.isExpanded) {
      _staggeredController.forward(from: 0.0);
    } else if (!widget.isExpanded && oldWidget.isExpanded) {
      _staggeredController.reverse();
    }
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  double _getAngle(int index) {
    if (_iconCount == 1) return 0;
    return _arcStartAngle +
        (index * (_arcEndAngle - _arcStartAngle) / (_iconCount - 1));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final centerY = constraints.maxHeight / 2;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            _buildTrigger(centerY),
            if (widget.isExpanded) ..._buildArcIcons(centerY),
          ],
        );
      },
    );
  }

  Widget _buildTrigger(double centerY) {
    return Positioned(
      left: -_triggerRadius * 0.5,
      top: centerY - _triggerRadius,
      child: GestureDetector(
        onTap: widget.onToggle,
        onLongPress: widget.onToggle,
        child: _buildGlassyCircle(
          size: _triggerRadius * 2,
          child: AnimatedRotation(
            turns: widget.isExpanded ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: const Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: AppColors.sidebarInactive,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildArcIcons(double centerY) {
    final List<Widget> widgets = [];

    for (int i = 0; i < _iconCount; i++) {
      final angle = _getAngle(i);
      final x = _arcRadius * cos(angle);
      final y = _arcRadius * sin(angle);

      widgets.add(
        Positioned(
          left: x - _iconSize / 2,
          top: centerY + y - _iconSize / 2,
          child: AnimatedBuilder(
            animation: _staggeredController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimations[i].value,
                child: Transform.scale(
                  scale: _scaleAnimations[i].value,
                  child: child,
                ),
              );
            },
            child: _RadialIcon(
              icon: widget.icons[i].icon,
              tooltip: widget.icons[i].tooltip,
              isActive: widget.currentIndex == i,
              onTap: () => widget.onTap(i),
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  Widget _buildGlassyCircle({required double size, required Widget child}) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.sidebarBackground,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.sidebarBorder, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: AppColors.sidebarShadow,
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _RadialIcon extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final bool isActive;
  final VoidCallback onTap;

  const _RadialIcon({
    required this.icon,
    required this.tooltip,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_RadialIcon> createState() => _RadialIconState();
}

class _RadialIconState extends State<_RadialIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      preferBelow: false,
      waitDuration: const Duration(milliseconds: 400),
      child: GestureDetector(
        onTap: () {
          _controller.forward().then((_) => _controller.reverse());
          widget.onTap();
        },
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
              child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.sidebarBackground,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.sidebarBorder,
                    width: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.sidebarShadow,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: widget.isActive
                      ? ShaderMask(
                          shaderCallback: (bounds) {
                            return AppColors.sidebarActiveGradient.createShader(
                              bounds,
                            );
                          },
                          blendMode: BlendMode.srcIn,
                          child: Icon(
                            widget.icon,
                            size: 24,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          widget.icon,
                          size: 24,
                          color: AppColors.sidebarInactive,
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
