import 'package:archiz_staging_admin/core/utils/color_resources.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/core/utils/style.dart';
import 'package:flutter/material.dart';

class TableItem extends StatelessWidget {
  const TableItem({
    super.key,
    required this.title,
    required this.qty,
    required this.unit,
    required this.rate,
    required this.total,
    this.currency,
  });
  final String title;
  final String qty;
  final String unit;
  final String rate;
  final String total;
  final String? currency;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width / 1.5,
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: regularDefault,
              ),
            ),
            Text(
              '${currency ?? ''}$rate x ${qty.replaceAll('.00', '')} $unit',
              style:
                  regularDefault.copyWith(color: ColorResources.blueGreyColor),
            ),
          ],
        ),
        const SizedBox(height: Dimensions.space5),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${currency ?? ''}$total',
              style: regularLarge,
            ),
          ],
        ),
      ],
    );
  }
}
