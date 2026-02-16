import 'package:flutter/material.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/core/utils/color_resources.dart';

class AddIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color, iconColor;
  final double iconSize;

  const AddIconButton({
    super.key,
    this.icon = Icons.add,
    required this.onTap,
    this.color = ColorResources.secondaryColor,
    this.iconColor = Colors.white,
    this.iconSize = 30.00,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.space5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
