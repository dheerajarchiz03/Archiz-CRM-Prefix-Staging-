import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:archiz_staging_admin/common/components/app-bar/custom_appbar.dart';
import 'package:archiz_staging_admin/common/components/custom_loader/custom_loader.dart';
import 'package:archiz_staging_admin/common/components/dialog/warning_dialog.dart';
import 'package:archiz_staging_admin/core/route/route.dart';
import 'package:archiz_staging_admin/core/service/api_service.dart';
import 'package:archiz_staging_admin/core/utils/color_resources.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/core/utils/images.dart';
import 'package:archiz_staging_admin/core/utils/local_strings.dart';
import 'package:archiz_staging_admin/core/utils/style.dart';
import 'package:archiz_staging_admin/features/customer/controller/customer_controller.dart';
import 'package:archiz_staging_admin/features/customer/repo/customer_repo.dart';
import 'package:archiz_staging_admin/features/customer/widget/customer_billing.dart';
import 'package:archiz_staging_admin/features/customer/widget/customer_contacts.dart';
import 'package:archiz_staging_admin/features/customer/widget/customer_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({super.key, required this.id});
  final String id;

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(CustomerRepo(apiClient: Get.find()));
    final controller = Get.put(CustomerController(customerRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadCustomerDetails(widget.id);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.customerDetails.tr,
        isShowActionBtn: true,
        isShowActionBtnTwo: true,
        actionWidget: IconButton(
          onPressed: () {
            Get.toNamed(RouteHelper.updateCustomerScreen, arguments: widget.id);
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
              Get.find<CustomerController>().deleteCustomer(widget.id);
              Navigator.pop(context);
            },
                title: LocalStrings.deleteCustomer.tr,
                subTitle: LocalStrings.deleteCustomerWarningMSg.tr,
                image: MyImages.exclamationImage);
          },
          icon: const Icon(
            Icons.delete,
            size: 20,
          ),
        ),
      ),
      body: GetBuilder<CustomerController>(
        builder: (controller) {
          return controller.isLoading
              ? const CustomLoader()
              : ContainedTabBarView(
                  tabBarProperties: TabBarProperties(
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelColor: ColorResources.blueGreyColor,
                      labelColor: Theme.of(context).textTheme.bodyLarge!.color,
                      labelStyle: regularDefault,
                      indicatorColor: ColorResources.secondaryColor,
                      labelPadding: const EdgeInsets.symmetric(
                          vertical: Dimensions.space15)),
                  tabs: [
                      Text(
                        LocalStrings.profile.tr,
                      ),
                      Text(
                        LocalStrings.billingAndShipping.tr,
                      ),
                      Text(
                        LocalStrings.contacts.tr,
                      ),
                    ],
                  views: [
                      CustomerProfile(
                        customerModel: controller.customerDetailsModel.data!,
                      ),
                      CustomerBilling(
                        customerModel: controller.customerDetailsModel.data!,
                      ),
                      CustomerContacts(
                        id: controller.customerDetailsModel.data!.userId!,
                      ),
                    ]);
        },
      ),
    );
  }
}
