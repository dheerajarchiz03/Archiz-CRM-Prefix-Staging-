import 'package:archiz_staging_admin/common/components/divider/custom_divider.dart';
import 'package:archiz_staging_admin/core/utils/color_resources.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/core/utils/local_strings.dart';
import 'package:archiz_staging_admin/core/utils/style.dart';
import 'package:archiz_staging_admin/features/dashboard/model/dashboard_model.dart';
import 'package:archiz_staging_admin/features/dashboard/widget/custom_linerprogress.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeInvoicesCard extends StatelessWidget {
  const HomeInvoicesCard({
    super.key,
    required this.invoices,
  });
  final List<DataField>? invoices;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.space5, vertical: Dimensions.space5),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.space15),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              label: Text(
                '${LocalStrings.invoices.tr} ${LocalStrings.overview.tr}',
                style: regularLarge.copyWith(
                    color: Theme.of(context).primaryColor),
              ),
              icon: Icon(Icons.assignment_outlined,
                  size: 20, color: Theme.of(context).primaryColor),
              onPressed: () {},
            ),
            const CustomDivider(space: Dimensions.space5),
            const SizedBox(height: Dimensions.space15),
            ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: Dimensions.space15),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return CustomLinerProgress(
                    name: invoices![index].status?.tr ?? '',
                    color: ColorResources.invoiceTextStatusColor(
                        invoices![index].status.toString()),
                    value: double.parse(invoices![index].percent!) / 100,
                    data: invoices![index].total.toString(),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: Dimensions.space2),
                itemCount: invoices!.length),
          ],
        ),
      ),
    );
  }
}
