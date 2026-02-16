import 'package:archiz_staging_admin/common/components/divider/custom_divider.dart';
import 'package:archiz_staging_admin/common/components/text/text_icon.dart';
import 'package:archiz_staging_admin/core/helper/date_converter.dart';
import 'package:archiz_staging_admin/core/route/route.dart';
import 'package:archiz_staging_admin/core/utils/color_resources.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/core/utils/local_strings.dart';
import 'package:archiz_staging_admin/core/utils/style.dart';
import 'package:archiz_staging_admin/features/contract/model/contract_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContractCard extends StatelessWidget {
  const ContractCard({
    super.key,
    required this.index,
    required this.contractModel,
  });
  final int index;
  final ContractsModel contractModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(RouteHelper.contractDetailsScreen,
          arguments: contractModel.data![index].id),
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
                  color: Colors.lightBlue.shade600,
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
                          contractModel.data![index].subject ?? '',
                          style: regularDefault,
                        ),
                        Text(
                          contractModel.data![index].contractValue ?? '',
                          style: regularDefault,
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.space5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          contractModel.data![index].description ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: lightSmall.copyWith(
                              color: ColorResources.blueGreyColor),
                        ),
                        Text(
                          contractModel.data![index].signed == '0'
                              ? LocalStrings.notSigned.tr
                              : LocalStrings.signed.tr,
                          style: lightSmall.copyWith(
                              color: ColorResources.contractStatusColor(
                                  contractModel.data![index].signed!)),
                        ),
                      ],
                    ),
                    const CustomDivider(space: Dimensions.space10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextIcon(
                          text: contractModel.data![index].company ?? '',
                          icon: Icons.account_box_rounded,
                        ),
                        TextIcon(
                          text: DateConverter.formatValidityDate(
                              contractModel.data![index].dateAdded ?? ''),
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
