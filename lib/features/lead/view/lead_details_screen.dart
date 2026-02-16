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
import 'package:archiz_staging_admin/features/lead/controller/lead_controller.dart';
import 'package:archiz_staging_admin/features/lead/repo/lead_repo.dart';
import 'package:archiz_staging_admin/features/lead/widget/lead_attachment.dart';
import 'package:archiz_staging_admin/features/lead/widget/lead_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadDetailsScreen extends StatefulWidget {
  const LeadDetailsScreen({super.key, required this.id});
  final String id;

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LeadRepo(apiClient: Get.find()));
    final controller = Get.put(LeadController(leadRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadLeadDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.leadDetails.tr,
        isShowActionBtn: true,
        isShowActionBtnTwo: true,
        actionWidget: IconButton(
          onPressed: () {
            Get.toNamed(RouteHelper.updateLeadScreen, arguments: widget.id);
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
              Get.find<LeadController>().deleteLead(widget.id);
              Navigator.pop(context);
            },
                title: LocalStrings.deleteLead.tr,
                subTitle: LocalStrings.deleteLeadWarningMSg.tr,
                image: MyImages.exclamationImage);
          },
          icon: const Icon(
            Icons.delete,
            size: 20,
          ),
        ),
      ),
      body: GetBuilder<LeadController>(
        builder: (controller) {
          return controller.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).cardColor,
                  onRefresh: () async {
                    await controller.loadLeadDetails(widget.id);
                  },
                  child: ContainedTabBarView(
                    tabBarProperties: TabBarProperties(
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelColor: ColorResources.blueGreyColor,
                        labelColor:
                            Theme.of(context).textTheme.bodyLarge!.color,
                        labelStyle: regularDefault,
                        indicatorColor: ColorResources.secondaryColor,
                        labelPadding: const EdgeInsets.symmetric(
                            vertical: Dimensions.space15)),
                    tabs: [
                      Text(
                        LocalStrings.profile.tr,
                      ),
                      Text(
                        LocalStrings.attachments.tr,
                      ),
                    ],
                    views: [
                      LeadProfile(
                        leadModel: controller.leadDetailsModel.data!,
                      ),
                      LeadAttachment(
                        leadModel: controller.leadDetailsModel.data!,
                      ),
                    ],
                  ));
        },
      ),
    );
  }
}
