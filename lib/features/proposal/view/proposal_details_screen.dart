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
import 'package:archiz_staging_admin/features/proposal/controller/proposal_controller.dart';
import 'package:archiz_staging_admin/features/proposal/repo/proposal_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProposalDetailsScreen extends StatefulWidget {
  const ProposalDetailsScreen({super.key, required this.id});
  final String id;

  @override
  State<ProposalDetailsScreen> createState() => _ProposalDetailsScreenState();
}

class _ProposalDetailsScreenState extends State<ProposalDetailsScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ProposalRepo(apiClient: Get.find()));
    final controller = Get.put(ProposalController(proposalRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadProposalDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.proposalDetails.tr,
        isShowActionBtn: true,
        isShowActionBtnTwo: true,
        actionWidget: IconButton(
          onPressed: () {
            Get.toNamed(RouteHelper.updateProposalScreen, arguments: widget.id);
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
              Get.find<ProposalController>().deleteProposal(widget.id);
              Navigator.pop(context);
            },
                title: LocalStrings.deleteProposal.tr,
                subTitle: LocalStrings.deleteProposalWarningMSg.tr,
                image: MyImages.exclamationImage);
          },
          icon: const Icon(
            Icons.delete,
            size: 20,
          ),
        ),
      ),
      body: GetBuilder<ProposalController>(
        builder: (controller) {
          return controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async {
                    await controller.loadProposalDetails(widget.id);
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
                                controller.proposalDetailsModel.data!.subject ??
                                    '',
                                style: mediumLarge,
                              ),
                              Text(
                                Converter.proposalStatusString(controller
                                        .proposalDetailsModel.data!.status ??
                                    ''),
                                style: lightDefault.copyWith(
                                    color: ColorResources.proposalStatusColor(
                                        controller.proposalDetailsModel.data!
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
                                    Text(LocalStrings.email.tr,
                                        style: lightSmall),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        controller.proposalDetailsModel.data!
                                                .proposalTo ??
                                            '',
                                        style: regularDefault),
                                    Text(
                                        controller.proposalDetailsModel.data!
                                                .email ??
                                            '-',
                                        style: regularDefault),
                                  ],
                                ),
                                const CustomDivider(space: Dimensions.space10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(LocalStrings.date.tr,
                                        style: lightSmall),
                                    Text(LocalStrings.openTill.tr,
                                        style: lightSmall),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        controller.proposalDetailsModel.data!
                                                .date ??
                                            '',
                                        style: regularDefault),
                                    Text(
                                        controller.proposalDetailsModel.data!
                                                .openTill ??
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
                                    title: controller.proposalDetailsModel.data!
                                            .items![index].description ??
                                        '',
                                    qty: controller.proposalDetailsModel.data!
                                            .items![index].qty ??
                                        '',
                                    unit: controller.proposalDetailsModel.data!
                                            .items![index].unit ??
                                        '',
                                    rate: controller.proposalDetailsModel.data!
                                            .items![index].rate ??
                                        '',
                                    total:
                                        '${double.parse(controller.proposalDetailsModel.data!.items![index].rate ?? '0') * double.parse(controller.proposalDetailsModel.data!.items![index].qty ?? '0')}',
                                    currency: controller
                                        .proposalDetailsModel.data!.symbol,
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const CustomDivider(
                                        space: Dimensions.space10),
                                itemCount: controller
                                    .proposalDetailsModel.data!.items!.length),
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
                                      '${controller.proposalDetailsModel.data!.symbol ?? ''}${controller.proposalDetailsModel.data!.subtotal ?? ''}',
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
                                      controller.proposalDetailsModel.data!
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
                                        controller.proposalDetailsModel.data!
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
