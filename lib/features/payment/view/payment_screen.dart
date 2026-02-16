import 'package:archiz_staging_admin/common/components/app-bar/custom_appbar.dart';
import 'package:archiz_staging_admin/common/components/custom_loader/custom_loader.dart';
import 'package:archiz_staging_admin/common/components/no_data.dart';
import 'package:archiz_staging_admin/common/components/search_field.dart';
import 'package:archiz_staging_admin/core/service/api_service.dart';
import 'package:archiz_staging_admin/core/utils/color_resources.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/core/utils/local_strings.dart';
import 'package:archiz_staging_admin/features/payment/controller/payment_controller.dart';
import 'package:archiz_staging_admin/features/payment/repo/payment_repo.dart';
import 'package:archiz_staging_admin/features/payment/widget/payment_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(PaymentRepo(apiClient: Get.find()));
    final controller = Get.put(PaymentController(paymentRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(builder: (controller) {
      return Scaffold(
        appBar: CustomAppBar(
          title: LocalStrings.payments.tr,
          isShowActionBtn: true,
          actionWidget: IconButton(
              onPressed: () => controller.changeSearchIcon(),
              icon: Icon(controller.isSearch ? Icons.clear : Icons.search)),
        ),
        body: controller.isLoading
            ? const CustomLoader()
            : RefreshIndicator(
                color: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).cardColor,
                onRefresh: () async {
                  await controller.initialData(shouldLoad: false);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Visibility(
                        visible: controller.isSearch,
                        child: SearchField(
                          title: LocalStrings.paymentDetails.tr,
                          searchController: controller.searchController,
                          onTap: () => controller.searchPayment(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(Dimensions.space15),
                        child: Row(
                          children: [
                            Text(
                              LocalStrings.payments.tr,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.sort_outlined,
                                    size: Dimensions.space20,
                                    color: ColorResources.blueGreyColor,
                                  ),
                                  const SizedBox(width: Dimensions.space5),
                                  Text(
                                    LocalStrings.filter.tr,
                                    style: const TextStyle(
                                        fontSize: Dimensions.fontDefault,
                                        color: ColorResources.blueGreyColor),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      controller.paymentsModel.data?.isNotEmpty ?? false
                          ? ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.space15),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return PaymentCard(
                                  index: index,
                                  paymentModel: controller.paymentsModel,
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: Dimensions.space10),
                              itemCount: controller.paymentsModel.data!.length)
                          : const NoDataWidget(),
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
