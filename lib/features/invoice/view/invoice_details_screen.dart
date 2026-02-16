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
import 'package:archiz_staging_admin/features/invoice/controller/invoice_controller.dart';
import 'package:archiz_staging_admin/features/invoice/repo/invoice_repo.dart';
import 'package:archiz_staging_admin/features/invoice/widget/invoice_payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceDetailsScreen extends StatefulWidget {
  const InvoiceDetailsScreen({super.key, required this.id});
  final String id;

  @override
  State<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(InvoiceRepo(apiClient: Get.find()));
    final controller = Get.put(InvoiceController(invoiceRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadInvoiceDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.invoiceDetails.tr,
        isShowActionBtn: true,
        isShowActionBtnTwo: true,
        actionWidget: IconButton(
          onPressed: () {
            Get.toNamed(RouteHelper.updateInvoiceScreen, arguments: widget.id);
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
              Get.find<InvoiceController>().deleteInvoice(widget.id);
              Navigator.pop(context);
            },
                title: LocalStrings.deleteInvoice.tr,
                subTitle: LocalStrings.deleteInvoiceWarningMSg.tr,
                image: MyImages.exclamationImage);
          },
          icon: const Icon(
            Icons.delete,
            size: 20,
          ),
        ),
      ),
      body: GetBuilder<InvoiceController>(
        builder: (controller) {
          return controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async {
                    await controller.loadInvoiceDetails(widget.id);
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
                                '${controller.invoiceDetailsModel.data!.prefix ?? ''}${controller.invoiceDetailsModel.data!.number ?? ''}',
                                style: mediumLarge,
                              ),
                              Text(
                                Converter.invoiceStatusString(controller
                                        .invoiceDetailsModel.data!.status ??
                                    ''),
                                style: lightDefault.copyWith(
                                    color: ColorResources.invoiceStatusColor(
                                        controller.invoiceDetailsModel.data!
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
                                    Text(LocalStrings.project.tr,
                                        style: lightSmall),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        controller.invoiceDetailsModel.data!
                                                .clientData?.company ??
                                            '',
                                        style: regularDefault),
                                    Text(
                                        controller.invoiceDetailsModel.data!
                                                .projectData?.name ??
                                            '-',
                                        style: regularDefault),
                                  ],
                                ),
                                const CustomDivider(space: Dimensions.space10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(LocalStrings.invoiceDate.tr,
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
                                        controller.invoiceDetailsModel.data!
                                                .date ??
                                            '',
                                        style: regularDefault),
                                    Text(
                                        controller.invoiceDetailsModel.data!
                                                .duedate ??
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
                                    title: controller.invoiceDetailsModel.data!
                                            .items![index].description ??
                                        '',
                                    qty: controller.invoiceDetailsModel.data!
                                            .items![index].qty ??
                                        '',
                                    unit: controller.invoiceDetailsModel.data!
                                            .items![index].unit ??
                                        '',
                                    rate: controller.invoiceDetailsModel.data!
                                            .items![index].rate ??
                                        '',
                                    total:
                                        '${double.parse(controller.invoiceDetailsModel.data!.items![index].rate ?? '0') * double.parse(controller.invoiceDetailsModel.data!.items![index].qty ?? '0')}',
                                    currency: controller.invoiceDetailsModel
                                        .data!.currencySymbol,
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const CustomDivider(
                                        space: Dimensions.space10),
                                itemCount: controller
                                    .invoiceDetailsModel.data!.items!.length),
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
                                      '${controller.invoiceDetailsModel.data!.currencySymbol ?? ''}${controller.invoiceDetailsModel.data!.subtotal ?? ''}',
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
                                      controller.invoiceDetailsModel.data!
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
                                        controller.invoiceDetailsModel.data!
                                                .totalTax ??
                                            '',
                                        style: regularDefault,
                                      ),
                                    ],
                                  ),
                                ),
                                if (controller.invoiceDetailsModel.data!
                                        .payments?.isNotEmpty ??
                                    false)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: Dimensions.space10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          LocalStrings.totalPaid.tr,
                                          style: lightDefault,
                                        ),
                                        Text(
                                          '- ${controller.invoiceDetailsModel.data!.currencySymbol ?? ''}${(double.parse(controller.invoiceDetailsModel.data!.total ?? '') - double.parse(controller.invoiceDetailsModel.data!.totalLeftToPay ?? '')).toStringAsFixed(2)}',
                                          style: regularDefault,
                                        ),
                                      ],
                                    ),
                                  ),
                                const CustomDivider(space: Dimensions.space10),
                                controller.invoiceDetailsModel.data!.payments
                                            ?.isNotEmpty ??
                                        false
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            LocalStrings.amountDue.tr,
                                            style: regularDefault.copyWith(
                                                color: ColorResources.redColor),
                                          ),
                                          Text(
                                            '${controller.invoiceDetailsModel.data!.currencySymbol ?? ''}${controller.invoiceDetailsModel.data!.totalLeftToPay ?? ''}',
                                            style: mediumDefault.copyWith(
                                                color: ColorResources.redColor),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            LocalStrings.total.tr,
                                            style: regularLarge.copyWith(
                                                color: ColorResources.redColor),
                                          ),
                                          Text(
                                            '${controller.invoiceDetailsModel.data!.currencySymbol ?? ''}${controller.invoiceDetailsModel.data!.total ?? ''}',
                                            style: mediumLarge.copyWith(
                                                color: ColorResources.redColor),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          if (controller.invoiceDetailsModel.data!.payments
                                  ?.isNotEmpty ??
                              false) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.space10),
                              child: Text(
                                LocalStrings.transactions.tr,
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
                                    return InvoicePayment(
                                        currency: controller.invoiceDetailsModel
                                                .data!.currencySymbol ??
                                            '',
                                        payment: controller.invoiceDetailsModel
                                            .data!.payments![index]);
                                  },
                                  separatorBuilder: (context, index) =>
                                      const CustomDivider(
                                          space: Dimensions.space10),
                                  itemCount: controller.invoiceDetailsModel
                                      .data!.payments!.length),
                            ),
                          ],
                          const SizedBox(height: Dimensions.space10),
                          if (controller.invoiceDetailsModel.data!.clientNote !=
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
                                    controller.invoiceDetailsModel.data!
                                            .clientNote ??
                                        '-',
                                    style: lightSmall,
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: Dimensions.space10),
                          if (controller.invoiceDetailsModel.data!.adminNote !=
                              '')
                            CustomCard(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocalStrings.adminNote.tr,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const Divider(
                                    color: ColorResources.blueGreyColor,
                                    thickness: 0.50,
                                  ),
                                  Text(
                                    controller.invoiceDetailsModel.data!
                                            .adminNote ??
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
