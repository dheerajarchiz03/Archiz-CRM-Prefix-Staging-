import 'package:archiz_staging_admin/common/components/divider/custom_divider.dart';
import 'package:archiz_staging_admin/common/components/text/text_icon.dart';
import 'package:archiz_staging_admin/core/helper/date_converter.dart';
import 'package:archiz_staging_admin/core/helper/string_format_helper.dart';
import 'package:archiz_staging_admin/core/route/route.dart';
import 'package:archiz_staging_admin/core/utils/color_resources.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/core/utils/style.dart';
import 'package:archiz_staging_admin/features/ticket/model/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/visits_model.dart';

class VisitCard extends StatelessWidget {
  const VisitCard({super.key, required this.index, required this.visitsModel});

  final int index;
  final VisitsModel visitsModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          RouteHelper.visitDetailsScreen,
          arguments: visitsModel.data![index].id!,
        );
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
                  color: ColorResources.ticketStatusColor(
                    visitsModel.data![index].status!,
                  ),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${visitsModel.data![index].department}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.space0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 2,
                        child: Text(
                          Converter.parseHtmlString(
                            visitsModel.data![index].contactName ?? '',
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: lightSmall.copyWith(
                            color: ColorResources.blueGreyColor,
                          ),
                        ),
                      ),
                      // Text(visitsModel.data![index].priorityName?.tr ?? '',
                      //     style: lightSmall.copyWith(
                      //         color: ColorResources.ticketPriorityColor(
                      //             visitsModel.data![index].priority ?? ''))),
                    ],
                  ),
                  const SizedBox(height: Dimensions.space5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Distance in KM: ${visitsModel.data![index].km ?? '0'}',
                        style: lightSmall.copyWith(
                          color: ColorResources.blueGreyColor,
                          fontSize: Dimensions.space12,
                        ),
                      ),
                      Text(
                        'Rate per KM : ${visitsModel.data![index].rateKm ?? 'Pending'}',
                        style: lightSmall.copyWith(
                          color: ColorResources.blueColor,
                          fontSize: Dimensions.space12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.space5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // 'Status: ${visitsModel.data![index].id ?? '0'}',
                        'Status: ${visitsModel.data![index].state ?? 'Visit Done'}',
                        style: lightSmall.copyWith(
                          color: ColorResources.blueGreyColor,
                          fontSize: Dimensions.space12,
                        ),
                      ),
                      Text(
                        'Expense: Rs.  ${visitsModel.data![index].amount ?? 'Pending'}',
                        style: lightSmall.copyWith(
                          // color: ColorResources.ticketStatusColor(
                          //   visitsModel.data![index].status ?? '',
                          // ),
                          color: ColorResources.blueColor,
                          fontSize: Dimensions.space12,
                        ),
                      ),
                    ],
                  ),
                  const CustomDivider(space: Dimensions.space10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextIcon(
                        text: DateConverter.formatValidityDate(
                            visitsModel.data![index].createDate ?? ''),
                        icon: Icons.calendar_month,
                      ),
                      TextIcon(
                        text: DateConverter.formatValidityTime(
                            visitsModel.data![index].createDate ?? ''),
                        icon: Icons.timer,
                      ),

                    ],
                  )
                  // const CustomDivider(space: Dimensions.space5),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     TextIcon(
                  //       text: visitsModel.data![index].company ?? '',
                  //       icon: Icons.account_box_rounded,
                  //       textStyle: regularDefault.copyWith(
                  //         fontSize: Dimensions.space12,
                  //       ),
                  //     ),
                  //     TextIcon(
                  //       text: DateConverter.formatValidityDate(
                  //         visitsModel.data![index].dateCreated ?? '',
                  //       ),
                  //       icon: Icons.calendar_month,
                  //       textStyle: regularDefault.copyWith(
                  //         fontSize: Dimensions.space12,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
