import 'dart:convert';

import 'package:archiz_staging_admin/features/visit/controller/visit_controller.dart';
import 'package:async/async.dart';
import 'package:archiz_staging_admin/common/components/app-bar/custom_appbar.dart';
import 'package:archiz_staging_admin/common/components/buttons/rounded_button.dart';
import 'package:archiz_staging_admin/common/components/buttons/rounded_loading_button.dart';
import 'package:archiz_staging_admin/common/components/custom_drop_down_button_with_text_field.dart';
import 'package:archiz_staging_admin/common/components/custom_loader/custom_loader.dart';
import 'package:archiz_staging_admin/common/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:archiz_staging_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/core/utils/local_strings.dart';
import 'package:archiz_staging_admin/core/utils/style.dart';
import 'package:archiz_staging_admin/core/utils/color_resources.dart';
import 'package:archiz_staging_admin/features/customer/model/customer_model.dart';
import 'package:archiz_staging_admin/features/ticket/controller/ticket_controller.dart';
import 'package:archiz_staging_admin/features/ticket/model/departments_model.dart';
import 'package:archiz_staging_admin/features/ticket/model/priorities_model.dart';
import 'package:archiz_staging_admin/features/ticket/model/services_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/components/card/custom_card.dart';
import '../../../common/components/divider/custom_divider.dart';
import '../../../core/helper/date_converter.dart';

class AddReviewVisitScreen extends StatefulWidget {
  const AddReviewVisitScreen({super.key});

  @override
  State<AddReviewVisitScreen> createState() => _AddReviewVisitScreenState();
}

class _AddReviewVisitScreenState extends State<AddReviewVisitScreen> {
  final AsyncMemoizer<CustomersModel> customersMemoizer = AsyncMemoizer();
  final AsyncMemoizer<DepartmentModel> departmentMemoizer = AsyncMemoizer();
  final AsyncMemoizer<PriorityModel> priorityMemoizer = AsyncMemoizer();
  final AsyncMemoizer<ServiceModel> serviceMemoizer = AsyncMemoizer();

  String selectedRating = 'Select Rating';
  List<Map<String, String>> extraExpenses = [];

  DateTime? nextVisitDate;
  TimeOfDay? nextVisitTime;

  @override
  void dispose() {
    Get.find<VisitController>().clearData();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.addReview.tr,
      ),
      body: GetBuilder<VisitController>(
        builder: (controller) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.space15, horizontal: Dimensions.space20),
              child: Column(
                children: [
                  CustomTextField(
                    labelText: LocalStrings.addComment.tr,
                    textInputType: TextInputType.multiline,
                    maxLines: 4,
                    focusNode: controller.contactFocusNode,
                    controller: controller.contactController,
                    onChanged: (value) {
                      return;
                    },
                  ),
                  const SizedBox(height: Dimensions.space15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedRating,
                        style: regularDefault.copyWith(fontSize: 12, color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          // fillColor: Colors.white,
                          fillColor: Theme.of(context).cardColor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorResources.getTextFieldDisableBorder()),
                            borderRadius: BorderRadius.circular(Dimensions.space8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorResources.getTextFieldDisableBorder()),
                            borderRadius: BorderRadius.circular(Dimensions.space8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorResources.getTextFieldDisableBorder()),
                            borderRadius: BorderRadius.circular(Dimensions.space8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: [
                          'Select Rating',
                          '1 Star',
                          '2 Star',
                          '3 Star',
                          '4 Star',
                          '5 Star',
                        ].map((rating) {
                          return DropdownMenuItem<String>(
                            value: rating,
                            child: Text(
                              rating,
                              style: regularDefault.copyWith(fontSize: 12, color: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.color!,),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRating = value!;
                          });
                          // or if using controller:
                          // controller.selectedRating = value!;
                          // controller.update();
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: Dimensions.space10),
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Extra Expenses', style: regularDefault.copyWith(fontSize: 12, color: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.color!,)),
                          const SizedBox(height: Dimensions.space5),
                          // First row (with plus button)
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: DropdownButtonFormField<String>(
                                  value: '--Select--',
                                  style: regularDefault.copyWith(fontSize: 12, color: Colors.black),
                                  decoration: InputDecoration(
                                    filled: true,
                                    // fillColor: Colors.white,
                                    fillColor: Theme.of(context).cardColor,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: ColorResources.getTextFieldDisableBorder()),
                                      borderRadius: BorderRadius.circular(Dimensions.space8),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: ColorResources.getTextFieldDisableBorder()),
                                      borderRadius: BorderRadius.circular(Dimensions.space8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: ColorResources.getTextFieldDisableBorder()),
                                      borderRadius: BorderRadius.circular(Dimensions.space8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  items: [
                                    '--Select--',
                                    'Metro',
                                    'Parking',
                                    'Actual KM',
                                    'Other',
                                  ].map((type) => DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(type, style: regularDefault.copyWith(fontSize: 12, color:Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.color!,)),
                                  )).toList(),
                                  onChanged: (value) {
                                    // handle if you want to store the first row as well
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Enter expense',
                                    filled: true,
                                    // fillColor: Colors.white,
                                    fillColor: Theme.of(context).cardColor,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: ColorResources.getTextFieldDisableBorder()),
                                      borderRadius: BorderRadius.circular(Dimensions.space8),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: ColorResources.getTextFieldDisableBorder()),
                                      borderRadius: BorderRadius.circular(Dimensions.space8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: ColorResources.getTextFieldDisableBorder()),
                                      borderRadius: BorderRadius.circular(Dimensions.space8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                  style: regularDefault.copyWith(fontSize: 12, color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.color!,),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 25,
                                height: 25,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6), // Set your desired radius
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero, // Remove internal padding
                                    iconSize: 18, // Icon size
                                    icon: Icon(Icons.add, color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        extraExpenses.add({'type': '--Select--', 'amount': ''});
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          // Render added expense rows

                          ...List.generate(extraExpenses.length, (index) => buildExpenseRow(index)),

                        ],
                      ),
                    ),
                  const SizedBox(height: Dimensions.space15),
                  // Date Selection Field
                  GestureDetector(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(Dimensions.space15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                          color: ColorResources.getTextFieldDisableBorder(),
                        ),
                        borderRadius: BorderRadius.circular(Dimensions.space8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              controller.selectedDate != null
                                  ? '${controller.selectedDate!.day}/${controller.selectedDate!.month}/${controller.selectedDate!.year}'
                                  : 'Select Date',
                              style: regularDefault.copyWith(
                                fontSize: Dimensions.space12,
                                color: controller.selectedDate != null
                                    ? (controller.selectedVisitType == 'future' ? Colors.black : Colors.grey.shade500)
                                    : ColorResources.blueGreyColor,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.calendar_today_outlined,
                            color: ColorResources.getIconColor(),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.space15),
                  // Time Selection Field
                  GestureDetector(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(Dimensions.space15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                          color: ColorResources.getTextFieldDisableBorder(),
                        ),
                        borderRadius: BorderRadius.circular(Dimensions.space8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              controller.selectedTime != null
                                  ? '${controller.selectedTime!.hour.toString().padLeft(2, '0')}:${controller.selectedTime!.minute.toString().padLeft(2, '0')}'
                                  : 'Select Time',
                              style: regularDefault.copyWith(
                                fontSize: Dimensions.space12,
                                color: controller.selectedTime != null
                                    ? (controller.selectedVisitType == 'future' ? Colors.black : Colors.grey.shade500)
                                    : ColorResources.blueGreyColor,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.access_time_outlined,
                            color: ColorResources.getIconColor(),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Extra Expenses label
                  const SizedBox(height: Dimensions.space15),
                  CustomTextField(
                    labelText: LocalStrings.purpose.tr,
                    textInputType: TextInputType.multiline,
                    maxLines: 4,
                    focusNode: controller.descriptionFocusNode,
                    controller: controller.descriptionController,
                    onChanged: (value) {
                      return;
                    },
                  ),
                  const SizedBox(height: Dimensions.space25),
                  controller.isSubmitLoading
                      ? const RoundedLoadingBtn()
                      : RoundedButton(
                    text: LocalStrings.save.tr,
                    press: () {
                      // controller.submitVisit(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildExpenseRow(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          // Dropdown for expense type
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              value: extraExpenses[index]['type'],
              style: regularDefault.copyWith(fontSize: 12, color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                // fillColor: Colors.white,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorResources.getTextFieldDisableBorder()),
                  borderRadius: BorderRadius.circular(Dimensions.space8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorResources.getTextFieldDisableBorder()),
                  borderRadius: BorderRadius.circular(Dimensions.space8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorResources.getTextFieldDisableBorder()),
                  borderRadius: BorderRadius.circular(Dimensions.space8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: [
                '--Select--',
                'Metro',
                'Parking',
                'Actual KM',
                'Other',
              ].map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type, style: regularDefault.copyWith(fontSize: 12, color: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.color!,)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  extraExpenses[index]['type'] = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          // Text field for amount
          Expanded(
            flex: 3,
            child: TextFormField(
              initialValue: extraExpenses[index]['amount'],
              onChanged: (val) {
                setState(() {
                  extraExpenses[index]['amount'] = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter expense',
                filled: true,
                fillColor: Theme.of(context).cardColor,
                // fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorResources.getTextFieldDisableBorder()),
                  borderRadius: BorderRadius.circular(Dimensions.space8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorResources.getTextFieldDisableBorder()),
                  borderRadius: BorderRadius.circular(Dimensions.space8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorResources.getTextFieldDisableBorder()),
                  borderRadius: BorderRadius.circular(Dimensions.space8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: regularDefault.copyWith(fontSize: 12, color: Theme.of(
                context,
              ).textTheme.bodyMedium!.color!,),
            ),
          ),
          const SizedBox(width: 8),
          // Delete button
          // IconButton(
          //   icon: Icon(Icons.delete, color: Colors.red),
          //   onPressed: () {
          //     setState(() {
          //       extraExpenses.removeAt(index);
          //     });
          //   },
          // ),
          SizedBox(
            width: 25,
            height: 25,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6), // Set your desired radius
              ),
              child: IconButton(
                padding: EdgeInsets.zero, // Remove internal padding
                iconSize: 15, // Icon size
                icon: Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  setState(() {
                    extraExpenses.removeAt(index);
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
