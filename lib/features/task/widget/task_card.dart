import 'package:archiz_staging_admin/common/components/divider/custom_divider.dart';
import 'package:archiz_staging_admin/common/components/text/text_icon.dart';
import 'package:archiz_staging_admin/core/helper/date_converter.dart';
import 'package:archiz_staging_admin/core/helper/string_format_helper.dart';
import 'package:archiz_staging_admin/core/route/route.dart';
import 'package:archiz_staging_admin/core/utils/color_resources.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/core/utils/style.dart';
import 'package:archiz_staging_admin/features/task/model/tasks_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.index,
    required this.taskModel,
  });
  final int index;
  final TasksModel taskModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteHelper.taskDetailsScreen,
            arguments: taskModel.data![index].id!);
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                left: BorderSide(
                  width: 5.0,
                  color: ColorResources.taskStatusColor(
                      taskModel.data![index].status!),
                ),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 1.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${taskModel.data![index].name}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: Dimensions.space3),
                              Text(
                                taskModel.data![index].projectData?.name ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: lightSmall.copyWith(
                                    color: ColorResources.blueGreyColor),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              Converter.taskPriorityString(
                                  taskModel.data![index].priority ?? ''),
                              style: regularDefault.copyWith(
                                color: ColorResources.taskStatusColor(
                                    taskModel.data![index].priority ?? ''),
                              ),
                            ),
                            const SizedBox(height: Dimensions.space3),
                            Text(
                              taskModel.data![index].relType?.capitalizeFirst ??
                                  '-',
                              style: lightSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const CustomDivider(space: Dimensions.space10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextIcon(
                          text: Converter.taskStatusString(
                              taskModel.data![index].status ?? ''),
                          icon: Icons.check_circle_outline_rounded,
                        ),
                        TextIcon(
                          text: DateConverter.formatValidityDate(
                              taskModel.data![index].dateAdded ?? ''),
                          icon: Icons.calendar_month,
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
