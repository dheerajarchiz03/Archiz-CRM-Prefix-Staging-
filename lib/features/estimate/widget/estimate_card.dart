import 'package:archiz_staging_admin/common/components/divider/custom_divider.dart';
import 'package:archiz_staging_admin/common/components/text/text_icon.dart';
import 'package:archiz_staging_admin/core/helper/string_format_helper.dart';
import 'package:archiz_staging_admin/core/route/route.dart';
import 'package:archiz_staging_admin/core/utils/color_resources.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/features/estimate/model/estimate_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EstimateCard extends StatelessWidget {
  const EstimateCard({
    super.key,
    required this.index,
    required this.estimateModel,
  });
  final int index;
  final EstimatesModel estimateModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteHelper.estimateDetailsScreen,
            arguments: estimateModel.data![index].id!);
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                left: BorderSide(
                  width: 5.0,
                  color: ColorResources.estimateStatusColor(
                      estimateModel.data![index].status ?? ''),
                ),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          estimateModel.data![index].formattedNumber ??
                              '${estimateModel.data![index].prefix ?? ''}${estimateModel.data![index].number ?? ''}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          '${estimateModel.data![index].currencySymbol}${estimateModel.data![index].total}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const CustomDivider(space: Dimensions.space10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextIcon(
                          text: Converter.estimateStatusString(
                              estimateModel.data![index].status ?? '1'),
                          icon: Icons.check_circle_outline_rounded,
                        ),
                        TextIcon(
                          text: estimateModel.data![index].expiryDate ?? '',
                          icon: Icons.calendar_month,
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
