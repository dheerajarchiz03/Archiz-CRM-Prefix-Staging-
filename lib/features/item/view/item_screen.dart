import 'package:archiz_staging_admin/common/components/app-bar/custom_appbar.dart';
import 'package:archiz_staging_admin/common/components/custom_loader/custom_loader.dart';
import 'package:archiz_staging_admin/common/components/no_data.dart';
import 'package:archiz_staging_admin/common/components/search_field.dart';
import 'package:archiz_staging_admin/core/service/api_service.dart';
import 'package:archiz_staging_admin/core/utils/color_resources.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/core/utils/local_strings.dart';
import 'package:archiz_staging_admin/features/item/controller/item_controller.dart';
import 'package:archiz_staging_admin/features/item/repo/item_repo.dart';
import 'package:archiz_staging_admin/features/item/widget/item_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ItemRepo(apiClient: Get.find()));
    final controller = Get.put(ItemController(itemRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemController>(builder: (controller) {
      return Scaffold(
        appBar: CustomAppBar(
          title: LocalStrings.items.tr,
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
                child: Column(
                  children: [
                    Visibility(
                      visible: controller.isSearch,
                      child: SearchField(
                        title: LocalStrings.itemDetails.tr,
                        searchController: controller.searchController,
                        onTap: () => controller.searchItem(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(Dimensions.space15),
                      child: Row(
                        children: [
                          Text(
                            LocalStrings.items.tr,
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
                    controller.itemsModel.data?.isNotEmpty ?? false
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.space15),
                              child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    return ItemCard(
                                      index: index,
                                      itemModel: controller.itemsModel,
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                          height: Dimensions.space10),
                                  itemCount:
                                      controller.itemsModel.data!.length),
                            ),
                          )
                        : const NoDataWidget(),
                  ],
                ),
              ),
      );
    });
  }
}
