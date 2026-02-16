import 'package:archiz_staging_admin/common/components/app-bar/custom_appbar.dart';
import 'package:archiz_staging_admin/common/components/card/custom_card.dart';
import 'package:archiz_staging_admin/common/components/custom_loader/custom_loader.dart';
import 'package:archiz_staging_admin/common/components/dialog/warning_dialog.dart';
import 'package:archiz_staging_admin/common/components/divider/custom_divider.dart';
import 'package:archiz_staging_admin/common/components/table_item.dart';
import 'package:archiz_staging_admin/core/helper/string_format_helper.dart';
import 'package:archiz_staging_admin/core/route/route.dart';
import 'package:archiz_staging_admin/core/service/api_service.dart';
import 'package:archiz_staging_admin/core/utils/color_resources.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/core/utils/images.dart';
import 'package:archiz_staging_admin/core/utils/local_strings.dart';
import 'package:archiz_staging_admin/core/utils/style.dart';
import 'package:archiz_staging_admin/features/estimate/controller/estimate_controller.dart';
import 'package:archiz_staging_admin/features/estimate/repo/estimate_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EstimateDetailsScreen extends StatefulWidget {
  const EstimateDetailsScreen({super.key, required this.id});
  final String id;

  @override
  State<EstimateDetailsScreen> createState() => _EstimateDetailsScreenState();
}

class _EstimateDetailsScreenState extends State<EstimateDetailsScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(EstimateRepo(apiClient: Get.find()));
    final controller = Get.put(EstimateController(estimateRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadEstimateDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.estimateDetails.tr,
        isShowActionBtn: true,
        isShowActionBtnTwo: true,
        actionWidget: IconButton(
          onPressed: () {
            Get.toNamed(RouteHelper.updateEstimateScreen, arguments: widget.id);
          },
          icon: const Icon(
            Icons.edit,
            size: 20,
          ),
        ),
        actionWidgetTwo: IconButton(
          onPressed: () {
            const WarningAlertDialog().warningAlertDialog(context, () {
              Get.back();
              Get.find<EstimateController>().deleteEstimate(widget.id);
              Navigator.pop(context);
            },
                title: LocalStrings.deleteEstimate.tr,
                subTitle: LocalStrings.deleteEstimateWarningMSg.tr,
                image: MyImages.exclamationImage);
          },
          icon: const Icon(
            Icons.delete,
            size: 20,
          ),
        ),
      ),
      body: GetBuilder<EstimateController>(
        builder: (controller) {
          return controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async {
                    await controller.loadEstimateDetails(widget.id);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.space15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.estimateDetailsModel.data!
                                        .formattedNumber ??
                                    '${controller.estimateDetailsModel.data!.prefix ?? ''}${controller.estimateDetailsModel.data!.number ?? ''}',
                                style: mediumLarge,
                              ),
                              Text(
                                Converter.estimateStatusString(controller
                                        .estimateDetailsModel.data!.status ??
                                    ''),
                                style: lightDefault.copyWith(
                                    color: ColorResources.estimateStatusColor(
                                        controller.estimateDetailsModel.data!
                                                .status ??
                                            '')),
                              )
                            ],
                          ),
                          const SizedBox(height: Dimensions.space10),
                          CustomCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(LocalStrings.company.tr,
                                        style: lightSmall),
                                    Text(LocalStrings.referenceNo.tr,
                                        style: lightSmall),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        controller.estimateDetailsModel.data!
                                                .clientData?.company ??
                                            '',
                                        style: regularDefault),
                                    Text(
                                        controller.estimateDetailsModel.data!
                                                .referenceNo ??
                                            '-',
                                        style: regularDefault),
                                  ],
                                ),
                                const CustomDivider(space: Dimensions.space10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(LocalStrings.estimateDate.tr,
                                        style: lightSmall),
                                    Text(LocalStrings.dueDate.tr,
                                        style: lightSmall),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        controller.estimateDetailsModel.data!
                                                .date ??
                                            '',
                                        style: regularDefault),
                                    Text(
                                        controller.estimateDetailsModel.data!
                                                .expiryDate ??
                                            '-',
                                        style: regularDefault),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.space10),
                            child: Text(
                              LocalStrings.items.tr,
                              style: mediumLarge.copyWith(
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                          ),
                          CustomCard(
                            child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return TableItem(
                                    title: controller.estimateDetailsModel.data!
                                            .items![index].description ??
                                        '',
                                    qty: controller.estimateDetailsModel.data!
                                            .items![index].qty ??
                                        '',
                                    unit: controller.estimateDetailsModel.data!
                                            .items![index].unit ??
                                        '',
                                    rate: controller.estimateDetailsModel.data!
                                            .items![index].rate ??
                                        '',
                                    total:
                                        '${double.parse(controller.estimateDetailsModel.data!.items![index].rate ?? '0') * double.parse(controller.estimateDetailsModel.data!.items![index].qty ?? '0')}',
                                    currency: controller.estimateDetailsModel
                                        .data!.currencySymbol,
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const CustomDivider(
                                        space: Dimensions.space10),
                                itemCount: controller
                                    .estimateDetailsModel.data!.items!.length),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(Dimensions.space10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      LocalStrings.subtotal.tr,
                                      style: lightDefault,
                                    ),
                                    Text(
                                      '${controller.estimateDetailsModel.data!.currencySymbol ?? ''}${controller.estimateDetailsModel.data!.subTotal ?? ''}',
                                      style: regularDefault,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: Dimensions.space10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      LocalStrings.discount.tr,
                                      style: lightDefault,
                                    ),
                                    Text(
                                      controller.estimateDetailsModel.data!
                                              .discountTotal ??
                                          '',
                                      style: regularDefault,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: Dimensions.space10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        LocalStrings.tax.tr,
                                        style: lightDefault,
                                      ),
                                      Text(
                                        controller.estimateDetailsModel.data!
                                                .totalTax ??
                                            '',
                                        style: regularDefault,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: Dimensions.space10),
                          if (controller
                                  .estimateDetailsModel.data!.clientNote !=
                              '')
                            CustomCard(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocalStrings.clientNote.tr,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const Divider(
                                    color: ColorResources.blueGreyColor,
                                    thickness: 0.50,
                                  ),
                                  Text(
                                    controller.estimateDetailsModel.data!
                                            .clientNote ??
                                        '-',
                                    style: lightSmall,
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: Dimensions.space10),
                          if (controller.estimateDetailsModel.data!.terms != '')
                            CustomCard(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocalStrings.terms.tr,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const Divider(
                                    color: ColorResources.blueGreyColor,
                                    thickness: 0.50,
                                  ),
                                  Text(
                                    controller
                                            .estimateDetailsModel.data!.terms ??
                                        '-',
                                    style: lightSmall,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
