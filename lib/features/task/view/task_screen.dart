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
import 'package:archiz_staging_admin/features/task/controller/task_controller.dart';
import 'package:archiz_staging_admin/features/task/repo/task_repo.dart';
import 'package:archiz_staging_admin/features/task/widget/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(TaskRepo(apiClient: Get.find()));
    final controller = Get.put(TaskController(taskRepo: Get.find()));
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
    return GetBuilder<TaskController>(builder: (controller) {
      return Scaffold(
        appBar: CustomAppBar(
          title: LocalStrings.tasks.tr,
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
                  Get.toNamed(RouteHelper.addTaskScreen);
                }),
          ),
        ),
        body: controller.isLoading
            ? const CustomLoader()
            : RefreshIndicator(
                color: ColorResources.primaryColor,
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
                          title: LocalStrings.taskDetails.tr,
                          searchController: controller.searchController,
                          onTap: () => controller.searchTask(),
                        ),
                      ),
                      if (controller.tasksModel.overview != null)
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
                                LocalStrings.taskSummery.tr,
                                style: Theme.of(context).textTheme.bodyLarge,
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
                                          name: controller
                                                  .tasksModel
                                                  .overview![index]
                                                  .status
                                                  ?.tr ??
                                              '',
                                          number: controller
                                              .tasksModel.overview![index].total
                                              .toString(),
                                          color: ColorResources.blueColor);
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                            width: Dimensions.space5),
                                    itemCount:
                                        controller.tasksModel.overview!.length),
                              ),
                            ),
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.all(Dimensions.space15),
                        child: Row(
                          children: [
                            Text(
                              LocalStrings.tasks.tr,
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
                      controller.tasksModel.data?.isNotEmpty ?? false
                          ? ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.space15),
                              itemBuilder: (context, index) {
                                return TaskCard(
                                  index: index,
                                  taskModel: controller.tasksModel,
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: Dimensions.space10),
                              itemCount: controller.tasksModel.data!.length)
                          : const NoDataWidget(),
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
