// import 'package:archiz_staging_admin/features/visit/controller/visit_controller.dart';
// import 'package:async/async.dart';
// import 'package:archiz_staging_admin/common/components/app-bar/custom_appbar.dart';
// import 'package:archiz_staging_admin/common/components/buttons/rounded_button.dart';
// import 'package:archiz_staging_admin/common/components/buttons/rounded_loading_button.dart';
// import 'package:archiz_staging_admin/common/components/custom_drop_down_button_with_text_field.dart';
// import 'package:archiz_staging_admin/common/components/custom_loader/custom_loader.dart';
// import 'package:archiz_staging_admin/common/components/text-form-field/custom_amount_text_field.dart';
// import 'package:archiz_staging_admin/common/components/text-form-field/custom_drop_down_text_field.dart';
// import 'package:archiz_staging_admin/common/components/text-form-field/custom_text_field.dart';
// import 'package:archiz_staging_admin/core/helper/string_format_helper.dart';
// import 'package:archiz_staging_admin/core/utils/dimensions.dart';
// import 'package:archiz_staging_admin/core/utils/local_strings.dart';
// import 'package:archiz_staging_admin/core/utils/style.dart';
// import 'package:archiz_staging_admin/features/lead/controller/lead_controller.dart';
// import 'package:archiz_staging_admin/features/lead/model/sources_model.dart';
// import 'package:archiz_staging_admin/features/lead/model/statuses_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class AddVisitScreen extends StatefulWidget {
//   const AddVisitScreen({super.key});
//
//   @override
//   State<AddVisitScreen> createState() => _AddVisitScreenState();
// }
//
// class _AddVisitScreenState extends State<AddVisitScreen> {
//   final AsyncMemoizer<SourcesModel> sourcesMemoizer = AsyncMemoizer();
//   final AsyncMemoizer<StatusesModel> statusesMemoizer = AsyncMemoizer();
//
//   @override
//   void dispose() {
//     Get.find<VisitController>().clearData();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: LocalStrings.createNewVisit.tr,
//       ),
//       body: GetBuilder<VisitController>(
//         builder: (controller) {
//           return SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.all(Dimensions.space15),
//               child: Column(
//                 spacing: Dimensions.space15,
//                 children: [
//                   FutureBuilder(
//                       future:
//                       sourcesMemoizer.runOnce(controller.loadVisitSources),
//                       builder: (context, sourceList) {
//                         if (sourceList.data?.status ?? false) {
//                           return CustomDropDownTextField(
//                             hintText: LocalStrings.selectSource.tr,
//                             onChanged: (value) {
//                               controller.sourceController.text =
//                                   value.toString();
//                             },
//                             selectedValue: controller.sourceController.text,
//                             items: controller.sourcesModel.data!.map((value) {
//                               return DropdownMenuItem(
//                                 value: value.id,
//                                 child: Text(
//                                   value.name?.tr ?? '',
//                                   style: regularDefault.copyWith(
//                                       color: Theme.of(context)
//                                           .textTheme
//                                           .bodyMedium!
//                                           .color),
//                                 ),
//                               );
//                             }).toList(),
//                           );
//                         } else if (sourceList.data?.status == false) {
//                           return CustomDropDownWithTextField(
//                               selectedValue: LocalStrings.noSourceFound.tr,
//                               list: [LocalStrings.noSourceFound.tr]);
//                         } else {
//                           return const CustomLoader(isFullScreen: false);
//                         }
//                       }),
//                   FutureBuilder(
//                       future:
//                       statusesMemoizer.runOnce(controller.loadVisitStatuses),
//                       builder: (context, statusList) {
//                         if (statusList.data?.status ?? false) {
//                           return CustomDropDownTextField(
//                             hintText: LocalStrings.selectStatus.tr,
//                             onChanged: (value) {
//                               controller.statusController.text =
//                                   value.toString();
//                               print('Status ${value.toString()} -> ${statusList.data?.message}');
//                             },
//                             selectedValue: controller.statusController.text,
//                             items: controller.statusesModel.data!.map((value) {
//                               return DropdownMenuItem(
//                                 value: value.id,
//                                 child: Text(
//                                   value.name?.tr ?? '',
//                                   style: regularDefault.copyWith(
//                                       color: Converter.hexStringToColor(
//                                           value.color ?? '')),
//                                 ),
//                               );
//                             }).toList(),
//                           );
//                         } else if (statusList.data?.status == false) {
//                           return CustomDropDownWithTextField(
//                               selectedValue: LocalStrings.noStatusFound.tr,
//                               list: [LocalStrings.noStatusFound.tr]);
//                         } else {
//                           return const CustomLoader(isFullScreen: false);
//                         }
//                       }),
//                   CustomTextField(
//                     labelText: LocalStrings.name.tr,
//                     controller: controller.nameController,
//                     focusNode: controller.nameFocusNode,
//                     textInputType: TextInputType.text,
//                     nextFocus: controller.valueFocusNode,
//                     onChanged: (value) {
//                       return;
//                     },
//                   ),
//                   CustomAmountTextField(
//                     controller: controller.valueController,
//                     hintText: LocalStrings.leadValue.tr,
//                     currency: '\$',
//                     onChanged: (value) {
//                       return;
//                     },
//                   ),
//                   CustomTextField(
//                     labelText: LocalStrings.position.tr,
//                     controller: controller.titleController,
//                     focusNode: controller.titleFocusNode,
//                     textInputType: TextInputType.text,
//                     nextFocus: controller.emailFocusNode,
//                     onChanged: (value) {
//                       return;
//                     },
//                   ),
//                   CustomTextField(
//                     labelText: LocalStrings.email.tr,
//                     controller: controller.emailController,
//                     focusNode: controller.emailFocusNode,
//                     textInputType: TextInputType.text,
//                     nextFocus: controller.websiteFocusNode,
//                     onChanged: (value) {
//                       return;
//                     },
//                   ),
//                   CustomTextField(
//                     labelText: LocalStrings.website.tr,
//                     controller: controller.websiteController,
//                     focusNode: controller.websiteFocusNode,
//                     textInputType: TextInputType.text,
//                     nextFocus: controller.phoneNumberFocusNode,
//                     onChanged: (value) {
//                       return;
//                     },
//                   ),
//                   CustomTextField(
//                     labelText: LocalStrings.phone.tr,
//                     controller: controller.phoneNumberController,
//                     focusNode: controller.phoneNumberFocusNode,
//                     textInputType: TextInputType.number,
//                     nextFocus: controller.companyFocusNode,
//                     onChanged: (value) {
//                       return;
//                     },
//                   ),
//                   CustomTextField(
//                     labelText: LocalStrings.company.tr,
//                     controller: controller.companyController,
//                     focusNode: controller.companyFocusNode,
//                     textInputType: TextInputType.text,
//                     nextFocus: controller.addressFocusNode,
//                     onChanged: (value) {
//                       return;
//                     },
//                   ),
//                   CustomTextField(
//                     labelText: LocalStrings.address.tr,
//                     controller: controller.addressController,
//                     focusNode: controller.addressFocusNode,
//                     textInputType: TextInputType.text,
//                     onChanged: (value) {
//                       return;
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10),
//         child: GetBuilder<VisitController>(builder: (controller) {
//           return controller.isSubmitLoading
//               ? const RoundedLoadingBtn()
//               : RoundedButton(
//             text: LocalStrings.submit.tr,
//             press: () {
//               controller.submitVisit();
//             },
//           );
//         }),
//       ),
//     );
//   }
// }

import 'package:archiz_staging_admin/core/helper/string_format_helper.dart';
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

import '../../lead/model/statuses_model.dart';

class AddVisitScreen extends StatefulWidget {
  const AddVisitScreen({super.key});

  @override
  State<AddVisitScreen> createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  final AsyncMemoizer<CustomersModel> customersMemoizer = AsyncMemoizer();
  final AsyncMemoizer<DepartmentModel> departmentMemoizer = AsyncMemoizer();
  final AsyncMemoizer<PriorityModel> priorityMemoizer = AsyncMemoizer();
  final AsyncMemoizer<StatusesModel> statusesMemoizer = AsyncMemoizer();

  @override
  void dispose() {
    Get.find<VisitController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: LocalStrings.createNewVisit.tr),
      body: GetBuilder<VisitController>(
        builder: (controller) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Dimensions.space15,
                horizontal: Dimensions.space20,
              ),
              child: Column(
                children: <Widget>[
                  // Visit Type Radio Buttons
                  Container(
                    width: double.infinity,
                    // padding: const EdgeInsets.all(Dimensions.space15),
                    // decoration: BoxDecoration(
                    //   border: Border.all(color: Colors.grey.shade300),
                    //   borderRadius: BorderRadius.circular(Dimensions.space8),
                    // ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Visit Type',
                          style: regularDefault.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: Dimensions.space14,
                          ),
                        ),
                        const SizedBox(height: Dimensions.space0),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'current',
                              groupValue: controller.selectedVisitType,
                              // activeColor: ColorResources.primaryColor,
                              activeColor: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.color!,
                              onChanged: (value) {
                                controller.setVisitType(value!);
                                controller.visitTypeController.text = value;
                              },
                            ),
                            Text(
                              'Current Visit',
                              style: regularDefault.copyWith(
                                fontSize: Dimensions.space15,
                                // color: ColorResources.colorBlack,
                              ),
                            ),
                            const SizedBox(width: Dimensions.space20),
                            Radio<String>(
                              value: 'future',
                              groupValue: controller.selectedVisitType,
                              activeColor: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.color!,
                              onChanged: (value) {
                                controller.setVisitType(value!);
                                controller.visitTypeController.text = value;
                              },
                            ),
                            Text(
                              'Future Visit',
                              style: regularDefault.copyWith(
                                fontSize: Dimensions.space15,
                                // color:  ColorResources.colorBlack,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: Dimensions.space15),
                  FutureBuilder(
                    future: customersMemoizer.runOnce(controller.loadCustomers),
                    builder: (context, customerList) {
                      if (customerList.data?.status ?? false) {
                        return CustomDropDownTextField(
                          hintText: LocalStrings.selectClient.tr,
                          onChanged: (value) {
                            controller.userController.text = value;
                            controller.selectedCustomer = value;
                            controller.update();
                          },
                          items: controller.customersModel.data!.map((
                            customer,
                          ) {
                            return DropdownMenuItem(
                              value: customer.userId,
                              child: Text(
                                customer.company ?? '',
                                style: regularDefault.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.color,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                      else if (customerList.data?.status == false) {
                        return CustomDropDownWithTextField(
                          selectedValue: LocalStrings.noClientFound.tr,
                          list: [LocalStrings.noClientFound.tr],
                        );
                      } else {
                        return const CustomLoader(isFullScreen: false);
                      }
                    },
                  ),


                  if (controller.selectedCustomer.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: Dimensions.space15),
                      child: FutureBuilder(
                        future: controller.loadCustomerContacts(controller.selectedCustomer),
                        builder: (context, contactsList) {
                          if (contactsList.hasData && (contactsList.data?.status ?? false)) {
                            // Contacts available
                            final contacts = controller.contactsModel.data!;

                            if (contacts.isNotEmpty) {
                              // Auto-select first contact ONLY if field is empty
                              if (controller.contactController.text.isEmpty) {
                                final first = contacts.first;
                                controller.contactController.text =
                                    "${first.firstName ?? ''} ${first.lastName ?? ''}".trim();
                              }else{
                                // controller.contactController.text = LocalStrings.noContactFound.tr;
                                controller.contactController.text = ""; // keep empty
                              }
                            }else{
                              controller.contactController.text = LocalStrings.noContactFound.tr;
                              // controller.contactController.text = ""; // keep empty
                            }

                            return CustomTextField(
                              labelText: LocalStrings.selectContact.tr,
                              controller: controller.contactController,
                              textInputType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LocalStrings.pleaseSelectContact.tr;
                                }
                                return null;
                              },
                              onChanged: (value) {},
                            );
                          }

                          // No contacts found
                          else if (contactsList.hasData && contactsList.data?.status == false) {
                            controller.contactController.text = LocalStrings.noContactFound.tr;
                            controller.contactController.text = ""; // keep empty
                            return CustomTextField(
                              labelText: LocalStrings.noContactFound.tr,
                              controller: controller.contactController,
                              textInputType: TextInputType.text,
                              validator: (value) => null,
                              onChanged: (value) {},
                            );
                          }

                          // Loading
                          else {
                            return const CustomLoader(isFullScreen: false);
                          }
                        },
                        // future: controller.loadCustomerContacts(
                        //   controller.selectedCustomer,
                        // ),
                        // builder: (context, contactsList) {
                        //   if (contactsList.hasData &&
                        //       (contactsList.data?.status ?? false)) {
                        //     return CustomTextField(
                        //       labelText: LocalStrings.selectContact.tr,
                        //       controller: controller.contactController,
                        //       // focusNode: controller.contactFocusNode,
                        //       textInputType: TextInputType.text,
                        //       // nextFocus: controller.nextFocusNode,
                        //       validator: (value) {
                        //         if (value == null || value.isEmpty) {
                        //           return LocalStrings.pleaseSelectContact.tr;
                        //         }
                        //         return null;
                        //       },
                        //       onChanged: (value) {},
                        //     );
                        //   }
                        //   else if (contactsList.hasData &&
                        //       contactsList.data?.status == false) {
                        //     return CustomTextField(
                        //       labelText: LocalStrings.noContactFound.tr,
                        //       controller: controller.contactController,
                        //       // focusNode: controller.contactFocusNode,
                        //       textInputType: TextInputType.text,
                        //       // nextFocus: controller.nextFocusNode,
                        //       validator: (value) => null,
                        //       onChanged: (value) {},
                        //     );
                        //   } else {
                        //     return const CustomLoader(isFullScreen: false);
                        //   }
                        // },
                      ),
                    ),
/*====================================*/
                  // if (controller.selectedCustomer.isNotEmpty)
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: Dimensions.space15),
                  //     child: FutureBuilder(
                  //         future: controller.loadCustomerContacts(
                  //             controller.selectedCustomer),
                  //         builder: (context, contactsList) {
                  //           if (contactsList.data?.status ?? false) {
                  //             return CustomDropDownTextField(
                  //               hintText: LocalStrings.selectContact.tr,
                  //               onChanged: (value) {
                  //                 controller.contactController.text = value;
                  //               },
                  //               items: controller.contactsModel.data!
                  //                   .map((contact) {
                  //                 return DropdownMenuItem(
                  //                   value: contact.id,
                  //                   child: Text(
                  //                     '${contact.firstName ?? ''} ${contact.lastName ?? ''}',
                  //                     style: regularDefault.copyWith(
                  //                         color: Theme.of(context)
                  //                             .textTheme
                  //                             .bodyMedium!
                  //                             .color),
                  //                   ),
                  //                 );
                  //               }).toList(),
                  //             );
                  //           } else if (contactsList.data?.status == false) {
                  //             return CustomDropDownWithTextField(
                  //                 selectedValue: LocalStrings.noContactFound.tr,
                  //                 list: [LocalStrings.noContactFound.tr]);
                  //           } else {
                  //             return const CustomLoader(isFullScreen: false);
                  //           }
                  //         }),
                  //   ),
                  const SizedBox(height: Dimensions.space15),
                  FutureBuilder(
                    future: departmentMemoizer.runOnce(
                      controller.loadDepartments,
                    ),
                    builder: (context, departmentList) {
                      if (departmentList.data?.status ?? false) {
                        return CustomDropDownTextField(
                          hintText: LocalStrings.selectDepartment.tr,
                          onChanged: (value) {
                            controller.departmentController.text = value;
                          },
                          items: controller.departmentModel.data!.map((
                            department,
                          ) {
                            return DropdownMenuItem(
                              value: department.id,
                              child: Text(
                                department.name ?? '',
                                style: regularDefault.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.color,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      } else if (departmentList.data?.status == false) {
                        return CustomDropDownWithTextField(
                          selectedValue: LocalStrings.noDepartmentFound.tr,
                          list: [LocalStrings.noDepartmentFound.tr],
                        );
                      } else {
                        return const CustomLoader(isFullScreen: false);
                      }
                    },
                  ),
                  const SizedBox(height: Dimensions.space15),
                  FutureBuilder(
                    future: priorityMemoizer.runOnce(controller.loadPriorities),
                    builder: (context, prioritiesList) {
                      if (prioritiesList.data?.status ?? false) {
                        return CustomDropDownTextField(
                          hintText: LocalStrings.selectPriority.tr,
                          onChanged: (value) {
                            controller.priorityController.text = value;
                          },
                          items: controller.priorityModel.data!.map((priority) {
                            return DropdownMenuItem(
                              value: priority.id,
                              child: Text(
                                priority.name ?? '',
                                style: regularDefault.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.color,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      } else if (prioritiesList.data?.status == false) {
                        return CustomDropDownWithTextField(
                          selectedValue: LocalStrings.noPriorityFound.tr,
                          list: [LocalStrings.noPriorityFound.tr],
                        );
                      } else {
                        return const CustomLoader(isFullScreen: false);
                      }
                    },
                  ),

                  /*  ====== TODO DATE $ TIME =============== */
                  const SizedBox(height: Dimensions.space15),
                  // Date Selection Field
                  GestureDetector(
                    onTap: controller.selectedVisitType == 'future'
                        ? () => controller.selectDate(context)
                        : null,
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
                              controller.selectedDate != null ? '${controller.selectedDate!.year}-${controller.selectedDate!.month}-${controller.selectedDate!.day}'
                                  : 'Select Date',
                              style: regularDefault.copyWith(
                                fontSize: Dimensions.space12,
                                color: controller.selectedDate != null ? (controller.selectedVisitType == 'future'
                                          ? Colors.black
                                          : Colors.grey.shade600)
                                    : ColorResources.blueGreyColor,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.calendar_today_outlined,
                            // color: ColorResources.getIconColor(),
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.color!,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.space15),
                  // Time Selection Field
                  GestureDetector(
                    onTap: controller.selectedVisitType == 'future'
                        ? () => controller.selectTime(context)
                        : null,
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
                                    ? (controller.selectedVisitType == 'future'
                                          ? Colors.black
                                          : Colors.grey.shade600)
                                    : ColorResources.blueGreyColor,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.access_time_outlined,
                            // color: ColorResources.getIconColor(),
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.color!,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  /*  ====== END TODO DATE $ TIME =============== */
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
                            controller.submitVisit();
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
}
