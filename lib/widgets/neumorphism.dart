import 'package:flutter/material.dart';
import 'package:flutter_compass_app/constants/app_colors.dart';

class Neumorphism extends StatelessWidget {
  const Neumorphism(
      {super.key,
      required this.child,
      this.distance = 30,
      this.blur = 50,
      this.margin,
      this.padding,
      this.isReverse = false,
      this.innerShadow = false});
  final Widget child;
  final double distance;
  final double blur;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool isReverse;
  final bool innerShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        shape: BoxShape.circle,
        boxShadow: isReverse
            ? [
                BoxShadow(
                  color: AppColors.primaryDarkColor,
                  blurRadius: blur,
                  offset: Offset(-distance, -distance),
                ),
                BoxShadow(
                  color: AppColors.white,
                  blurRadius: blur,
                  offset: Offset(distance, distance),
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.white,
                  blurRadius: blur,
                  offset: Offset(-distance, -distance),
                ),
                BoxShadow(
                  color: AppColors.primaryDarkColor,
                  blurRadius: blur,
                  offset: Offset(distance, distance),
                ),
              ],
      ),
      child: innerShadow ? TopGradientContainer(child: child) : child,
    );
  }
}

class TopGradientContainer extends StatelessWidget {
  const TopGradientContainer({
    super.key,
    required this.child,
    this.margin,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDarkColor, AppColors.white],
        ),
      ),
      child: child,
    );
  }
}
