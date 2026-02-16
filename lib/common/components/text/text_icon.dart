import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:archiz_staging_admin/core/utils/color_resources.dart';
import 'package:archiz_staging_admin/core/utils/style.dart';

class TextIcon extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final double space;
  final MainAxisAlignment alignment;
  const TextIcon({
    super.key,
    required this.text,
    this.textStyle,
    required this.icon,
    this.iconColor = ColorResources.secondaryColor,
    this.iconSize = 14,
    this.space = Dimensions.space5,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
        SizedBox(width: space),
        Text(
          text.tr,
          style: textStyle ??
              lightDefault.copyWith(color: ColorResources.blueGreyColor),
        ),
      ],
    );
  }
}
