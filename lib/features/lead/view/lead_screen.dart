import 'package:archiz_staging_admin/common/components/app-bar/custom_appbar.dart';
import 'package:archiz_staging_admin/common/components/custom_fab.dart';
import 'package:archiz_staging_admin/common/components/custom_loader/custom_loader.dart';
import 'package:archiz_staging_admin/common/components/no_data.dart';
import 'package:archiz_staging_admin/common/components/overview_card.dart';
import 'package:archiz_staging_admin/common/components/search_field.dart';
import 'package:archiz_staging_admin/core/route/route.dart';
import 'package:archiz_staging_admin/core/service/api_service.dart';
import 'package:archiz_staging_admin/core/utils/color_resources.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/core/utils/local_strings.dart';
import 'package:archiz_staging_admin/core/utils/style.dart';
import 'package:archiz_staging_admin/features/lead/controller/lead_controller.dart';
import 'package:archiz_staging_admin/features/lead/repo/lead_repo.dart';
import 'package:archiz_staging_admin/features/lead/widget/lead_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class LeadScreen extends StatefulWidget {
  const LeadScreen({super.key});

  @override
  State<LeadScreen> createState() => _LeadScreenState();
}

class _LeadScreenState extends State<LeadScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LeadRepo(apiClient: Get.find()));
    final controller = Get.put(LeadController(leadRepo: Get.find()));
    controller.isLoading = true;
    super.initState();
    handleScroll();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialData();
    });
  }

  bool showFab = true;
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  void handleScroll() async {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (showFab) setState(() => showFab = false);
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!showFab) setState(() => showFab = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeadController>(builder: (controller) {
      return Scaffold(
        appBar: CustomAppBar(
          title: LocalStrings.leads.tr,
          isShowActionBtn: true,
          actionWidget: IconButton(
              onPressed: () => controller.changeSearchIcon(),
              icon: Icon(controller.isSearch ? Icons.clear : Icons.search)),
        ),
        floatingActionButton: AnimatedSlide(
          offset: showFab ? Offset.zero : const Offset(0, 2),
          duration: const Duration(milliseconds: 300),
          child: AnimatedOpacity(
            opacity: showFab ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: CustomFAB(
                isShowIcon: true,
                isShowText: false,
                press: () {
                  Get.toNamed(RouteHelper.addLeadScreen);
                }),
          ),
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
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Visibility(
                        visible: controller.isSearch,
                        child: SearchField(
                          title: LocalStrings.leadDetails.tr,
                          searchController: controller.searchController,
                          onTap: () => controller.searchLead(),
                        ),
                      ),
                      if (controller.leadsModel.overview != null)
                        ExpansionTile(
                          title: Row(
                            children: [
                              Container(
                                width: Dimensions.space3,
                                height: Dimensions.space15,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: Dimensions.space5),
                              Text(
                                LocalStrings.leadSummery.tr,
                                style: regularLarge.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color),
                              ),
                            ],
                          ),
                          shape: const Border(),
                          initiallyExpanded: true,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.space15),
                              child: SizedBox(
                                height: 80,
                                child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return OverviewCard(
                                          name: controller.leadsModel
                                              .overview![index].status!.tr,
                                          number: controller
                                              .leadsModel.overview![index].total
                                              .toString(),
                                          color: ColorResources.blueColor);
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                            width: Dimensions.space5),
                                    itemCount:
                                        controller.leadsModel.overview!.length),
                              ),
                            ),
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.all(Dimensions.space15),
                        child: Row(
                          children: [
                            Text(
                              LocalStrings.leads.tr,
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
                      controller.leadsModel.data?.isNotEmpty ?? false
                          ? ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.space15),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return LeadCard(
                                  index: index,
                                  leadModel: controller.leadsModel,
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: Dimensions.space10),
                              itemCount: controller.leadsModel.data!.length)
                          : const NoDataWidget(),
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
