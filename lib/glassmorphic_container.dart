import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_constant.dart';

class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.blur = 5.0,
    this.padding,
    this.margin
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstant.BORDER_RADIUS_XL),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding ?? const EdgeInsets.all(AppConstant.PADDING_MEDIUM),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppConstant.SURFACE_COLOR.withOpacity(0.3),
                  AppConstant.SURFACE_COLOR.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppConstant.BORDER_RADIUS_XL),
              border: Border.all(
                color: AppConstant.SURFACE_COLOR.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}