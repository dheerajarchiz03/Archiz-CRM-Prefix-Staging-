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
import 'package:archiz_staging_admin/features/visit/controller/visit_controller.dart';
import 'package:archiz_staging_admin/features/visit/widget/visit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../repo/visit_repo.dart';

class VisitScreen extends StatefulWidget {
  const VisitScreen({super.key});

  @override
  State<VisitScreen> createState() => _VisitScreenState();
}
class _VisitScreenState extends State<VisitScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(VisitRepo(apiClient: Get.find()));
    final controller = Get.put(VisitController(visitRepo: Get.find()));
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
    return GetBuilder<VisitController>(builder: (controller) {
      return Scaffold(
        appBar: CustomAppBar(
          title: LocalStrings.visits.tr,
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
                  Get.toNamed(RouteHelper.addVisitScreen);
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
                    title: LocalStrings.visitDetails.tr,
                    searchController: controller.searchController,
                    onTap: () => controller.searchVisit(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(Dimensions.space15),
                  child: Row(
                    children: [
                      Text(
                        LocalStrings.visits.tr,
                        style: regularLarge.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .color),
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
                controller.visitsModel.data?.isNotEmpty ?? false
                    ? ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.space15),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return VisitCard(
                        index: index,
                        visitsModel: controller.visitsModel,
                      );
                    },
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: Dimensions.space10),
                    itemCount: controller.visitsModel.data!.length)
                    : const NoDataWidget(),
              ],
            ),
          ),
        ),
      );
    });
  }
}