import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularOutlineButton extends StatelessWidget {
  const CircularOutlineButton({
    super.key,
    required this.onPressed,
    this.iconColor,
    this.backgroundColor,
    this.iconSize = 24.0,
    required this.icon,
    this.borderColor,
    this.padding,
  });

  final VoidCallback onPressed;
  final Color? iconColor;
  final Color? backgroundColor;
  final IconData icon;
  final double? iconSize;
  final Color? borderColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      splashColor: Colors.red,
      padding: padding ?? EdgeInsets.all(5.r),
      // visualDensity: VisualDensity.compact,
      //  padding: EdgeInsets.all(5.r),
      constraints: BoxConstraints(
        minWidth: iconSize! * 1,
        minHeight: iconSize! * 1,
      ),
      iconSize: iconSize,
      style: ButtonStyle(
        iconColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.green;
            }
            return iconColor;
          },
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.grey;
            }
            return backgroundColor ?? Colors.transparent;
          },
        ),
        side: WidgetStateProperty.resolveWith<BorderSide>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return const BorderSide(
                  color: Colors.green, width: 1.0);
            }
            return BorderSide(
                color: borderColor ?? Colors.black, width: 0.8);
          },
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}

/*

/// Under testing purpose
import '../../core/app_export.dart';

class CircularOutlineButton extends StatelessWidget {
  const CircularOutlineButton({
    super.key,
    required this.onPressed,
    this.iconColor,
    this.backgroundColor,
    this.iconSize = 24.0,
    required this.icon,
    this.borderColor,
  });

  final VoidCallback onPressed;
  final Color? iconColor;
  final Color? backgroundColor;
  final IconData icon;
  final double? iconSize;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipBehavior: Clip.hardEdge,
      child: IconButton(
        splashColor: Colors.red,
        padding: EdgeInsets.zero, // Set padding to zero
        constraints: BoxConstraints.tightFor(width: iconSize, height: iconSize), // Set constraints to the size of the icon
        iconSize: iconSize,
        style: ButtonStyle(
          iconColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return CustomColors.buttonGreen;
              }
              return iconColor;
            },
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return CustomColors.tertiaryGreen;
              }
              return backgroundColor?? Colors.transparent;
            },
          ),
          side: WidgetStateProperty.resolveWith<BorderSide>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return const BorderSide(
                    color: CustomColors.tertiaryGreen, width: 1.0);
              }
              return BorderSide(
                  color: borderColor?? CustomColors.blackColor, width: 0.8);
            },
          ),
        ),
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}*/
