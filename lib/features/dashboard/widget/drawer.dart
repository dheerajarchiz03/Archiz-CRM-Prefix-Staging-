import 'package:archiz_staging_admin/common/components/circle_image_button.dart';
import 'package:archiz_staging_admin/common/components/dialog/warning_dialog.dart';
import 'package:archiz_staging_admin/core/route/route.dart';
import 'package:archiz_staging_admin/core/utils/local_strings.dart';
import 'package:archiz_staging_admin/features/dashboard/controller/dashboard_controller.dart';
import 'package:archiz_staging_admin/features/dashboard/model/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:archiz_staging_admin/core/utils/color_resources.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/core/utils/style.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key, required this.homeModel});
  final DashboardModel homeModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: ColorResources.blueGreyColor,
                    radius: 42,
                    child: CircleImageWidget(
                      imagePath: homeModel.staff?.profileImage ?? '',
                      isAsset: false,
                      isProfile: true,
                      width: 80,
                      height: 80,
                    ),
                  ),
                  const SizedBox(width: Dimensions.space20),
                  SizedBox(
                    width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${homeModel.staff?.firstName ?? ''} ${homeModel.staff?.lastName ?? ''}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: mediumLarge,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Get.toNamed(RouteHelper.profileScreen);
                            },
                            child: Text(
                              LocalStrings.viewProfile.tr,
                              style: semiBoldLarge.copyWith(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  decoration: TextDecoration.underline),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    homeModel.menuItems?.customers ?? false
                        ? ListTile(
                            leading: Icon(
                              Icons.group_outlined,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            title: Text(
                              LocalStrings.customers.tr,
                              style: regularDefault.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: Dimensions.space12,
                              color: ColorResources.contentTextColor,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Get.toNamed(RouteHelper.customerScreen);
                            },
                          )
                        : const SizedBox.shrink(),
                    homeModel.menuItems?.projects ?? false
                        ? ListTile(
                            leading: Icon(
                              Icons.task_outlined,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            title: Text(
                              LocalStrings.projects.tr,
                              style: regularDefault.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: Dimensions.space12,
                              color: ColorResources.contentTextColor,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Get.toNamed(RouteHelper.projectScreen);
                            },
                          )
                        : const SizedBox.shrink(),
                    homeModel.menuItems?.tasks ?? false
                        ? ListTile(
                            leading: Icon(
                              Icons.task_alt_rounded,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            title: Text(
                              LocalStrings.tasks.tr,
                              style: regularDefault.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: Dimensions.space12,
                              color: ColorResources.contentTextColor,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Get.toNamed(RouteHelper.taskScreen);
                            },
                          )
                        : const SizedBox.shrink(),
                    homeModel.menuItems?.invoices ?? false
                        ? ListTile(
                            leading: Icon(
                              Icons.assignment_outlined,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            title: Text(
                              LocalStrings.invoices.tr,
                              style: regularDefault.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: Dimensions.space12,
                              color: ColorResources.contentTextColor,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Get.toNamed(RouteHelper.invoiceScreen);
                            },
                          )
                        : const SizedBox.shrink(),
                    homeModel.menuItems?.contracts ?? false
                        ? ListTile(
                            leading: Icon(
                              Icons.article_outlined,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            title: Text(
                              LocalStrings.contracts.tr,
                              style: regularDefault.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: Dimensions.space12,
                              color: ColorResources.contentTextColor,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Get.toNamed(RouteHelper.contractScreen);
                            },
                          )
                        : const SizedBox.shrink(),
                    homeModel.menuItems?.tickets ?? false
                        ? ListTile(
                            leading: Icon(
                              Icons.confirmation_number_outlined,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            title: Text(
                              LocalStrings.tickets.tr,
                              style: regularDefault.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: Dimensions.space12,
                              color: ColorResources.contentTextColor,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Get.toNamed(RouteHelper.ticketScreen);
                            },
                          )
                        : const SizedBox.shrink(),
                    homeModel.menuItems?.leads ?? false
                        ? ListTile(
                            leading: Icon(
                              Icons.markunread_mailbox_outlined,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            title: Text(
                              LocalStrings.leads.tr,
                              style: regularDefault.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: Dimensions.space12,
                              color: ColorResources.contentTextColor,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Get.toNamed(RouteHelper.leadScreen);
                            },
                          )
                        : const SizedBox.shrink(),
                    homeModel.menuItems?.estimates ?? false
                        ? ListTile(
                            leading: Icon(
                              Icons.add_chart_outlined,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            title: Text(
                              LocalStrings.estimates.tr,
                              style: regularDefault.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: Dimensions.space12,
                              color: ColorResources.contentTextColor,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Get.toNamed(RouteHelper.estimateScreen);
                            },
                          )
                        : const SizedBox.shrink(),
                    homeModel.menuItems?.proposals ?? false
                        ? ListTile(
                            leading: Icon(
                              Icons.document_scanner_outlined,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            title: Text(
                              LocalStrings.proposals.tr,
                              style: regularDefault.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: Dimensions.space12,
                              color: ColorResources.contentTextColor,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Get.toNamed(RouteHelper.proposalScreen);
                            },
                          )
                        : const SizedBox.shrink(),
                    homeModel.menuItems?.payments ?? false
                        ? ListTile(
                            leading: Icon(
                              Icons.account_balance_wallet_outlined,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            title: Text(
                              LocalStrings.payments.tr,
                              style: regularDefault.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: Dimensions.space12,
                              color: ColorResources.contentTextColor,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Get.toNamed(RouteHelper.paymentScreen);
                            },
                          )
                        : const SizedBox.shrink(),
                    homeModel.menuItems?.items ?? false
                        ? ListTile(
                            leading: Icon(
                              Icons.add_box_outlined,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            title: Text(
                              LocalStrings.visit.tr,
                              style: regularDefault.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: Dimensions.space12,
                              color: ColorResources.contentTextColor,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Get.toNamed(RouteHelper.itemScreen);
                            },
                          )
                        : const SizedBox.shrink(),
                    ListTile(
                      leading: Icon(
                        Icons.account_circle_outlined,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                      title: Text(
                        LocalStrings.settings.tr,
                        style: regularDefault.copyWith(
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: Dimensions.space12,
                        color: ColorResources.contentTextColor,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Get.toNamed(RouteHelper.settingsScreen);
                      },
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: Dimensions.space20,
                color: Colors.red,
              ),
              title: Text(
                LocalStrings.logout.tr,
                style: regularDefault.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color),
              ),
              onTap: () {
                const WarningAlertDialog().warningAlertDialog(
                  context,
                  () {
                    Get.back();
                    Get.find<DashboardController>().logout();
                  },
                  title: LocalStrings.logout.tr,
                  subTitle: LocalStrings.logoutSureWarningMSg.tr,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
