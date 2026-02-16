import 'package:async/async.dart';
import 'package:archiz_staging_admin/common/components/app-bar/custom_appbar.dart';
import 'package:archiz_staging_admin/common/components/buttons/rounded_button.dart';
import 'package:archiz_staging_admin/common/components/buttons/rounded_loading_button.dart';
import 'package:archiz_staging_admin/common/components/custom_date_form_field.dart';
import 'package:archiz_staging_admin/common/components/custom_drop_down_button_with_text_field.dart';
import 'package:archiz_staging_admin/common/components/custom_loader/custom_loader.dart';
import 'package:archiz_staging_admin/common/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:archiz_staging_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:archiz_staging_admin/common/components/text/text_icon.dart';
import 'package:archiz_staging_admin/core/helper/date_converter.dart';
import 'package:archiz_staging_admin/core/utils/color_resources.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/core/utils/local_strings.dart';
import 'package:archiz_staging_admin/core/utils/style.dart';
import 'package:archiz_staging_admin/common/models/currencies_model.dart';
import 'package:archiz_staging_admin/features/customer/model/customer_model.dart';
import 'package:archiz_staging_admin/features/estimate/controller/estimate_controller.dart';
import 'package:archiz_staging_admin/features/item/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEstimateScreen extends StatefulWidget {
  const AddEstimateScreen({super.key});

  @override
  State<AddEstimateScreen> createState() => _AddEstimateScreenState();
}

class _AddEstimateScreenState extends State<AddEstimateScreen> {
  final AsyncMemoizer<CustomersModel> customersMemoizer = AsyncMemoizer();
  final AsyncMemoizer<CurrenciesModel> currenciesMemoizer = AsyncMemoizer();
  final AsyncMemoizer<ItemsModel> itemsMemoizer = AsyncMemoizer();

  @override
  void dispose() {
    Get.find<EstimateController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.addEstimate.tr,
      ),
      body: GetBuilder<EstimateController>(
        builder: (controller) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.space15, horizontal: Dimensions.space10),
              child: Column(
                spacing: Dimensions.space15,
                children: [
                  CustomTextField(
                    labelText: LocalStrings.number.tr,
                    controller: controller.numberController,
                    focusNode: controller.numberFocusNode,
                    textInputType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocalStrings.enterNumber.tr;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      return;
                    },
                  ),

                  FutureBuilder(
                      future:
                          customersMemoizer.runOnce(controller.loadCustomers),
                      builder: (context, customerList) {
                        if (customerList.data?.status ?? false) {
                          return CustomDropDownTextField(
                            hintText: LocalStrings.selectClient.tr,
                            dropDownColor: Theme.of(context).cardColor,
                            onChanged: (value) {
                              controller.clientController.text = value.userId;
                              controller.billingStreetController.text =
                                  value.billingStreet;
                            },
                            selectedValue: controller.clientController.text,
                            items:
                                controller.customersModel.data!.map((customer) {
                              return DropdownMenuItem(
                                value: customer,
                                child: Text(
                                  customer.company ?? '',
                                  style: regularDefault.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color),
                                ),
                              );
                            }).toList(),
                          );
                        } else if (customerList.data?.status == false) {
                          return CustomDropDownWithTextField(
                              selectedValue: LocalStrings.noClientFound.tr,
                              list: [LocalStrings.noClientFound.tr]);
                        } else {
                          return const CustomLoader(isFullScreen: false);
                        }
                      }),

                  Row(
                    children: [
                      Expanded(
                        child: CustomDateFormField(
                          labelText: LocalStrings.date.tr,
                          onChanged: (DateTime? value) {
                            controller.dateController.text =
                                DateConverter.formatDate(value!);
                          },
                        ),
                      ),
                      const SizedBox(width: Dimensions.space5),
                      Expanded(
                        child: CustomDateFormField(
                          labelText: LocalStrings.dueDate.tr,
                          onChanged: (DateTime? value) {
                            controller.dueDateController.text =
                                DateConverter.formatDate(value!);
                          },
                        ),
                      ),
                    ],
                  ),

                  CustomTextField(
                    labelText: LocalStrings.billingStreet.tr,
                    controller: controller.billingStreetController,
                    focusNode: controller.billingStreetFocusNode,
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocalStrings.billingStreet.tr;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      return;
                    },
                  ),

                  CustomDropDownTextField(
                    hintText: LocalStrings.selectStatus.tr,
                    onChanged: (value) {
                      controller.statusController.text = value;
                    },
                    selectedValue: controller.statusController.text,
                    dropDownColor: Theme.of(context).cardColor,
                    items: controller.estimateStatus.entries
                        .map((MapEntry element) => DropdownMenuItem(
                              value: element.key,
                              child: Text(
                                element.value,
                                style: regularDefault.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color),
                              ),
                            ))
                        .toList(),
                  ),

                  FutureBuilder(
                      future:
                          currenciesMemoizer.runOnce(controller.loadCurrencies),
                      builder: (context, currenciesList) {
                        if (currenciesList.data?.status ?? false) {
                          return CustomDropDownTextField(
                            hintText: LocalStrings.selectCurrency.tr,
                            onChanged: (value) {
                              controller.currencyController.text = value;
                            },
                            selectedValue: controller.currencyController.text,
                            dropDownColor: Theme.of(context).cardColor,
                            items: controller.currenciesModel.data!
                                .map((Currency value) {
                              return DropdownMenuItem(
                                value: value.id,
                                child: Text(
                                  value.name ?? '',
                                  style: regularDefault.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color),
                                ),
                              );
                            }).toList(),
                          );
                        } else if (currenciesList.data?.status == false) {
                          return CustomDropDownWithTextField(
                              selectedValue: LocalStrings.noCurrencyFound.tr,
                              list: [LocalStrings.noCurrencyFound.tr]);
                        } else {
                          return const CustomLoader();
                        }
                      }),
                  // Items Section Start
                  Row(
                    children: [
                      Container(
                        width: Dimensions.space3,
                        height: Dimensions.space15,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: Dimensions.space5),
                      Text(
                        LocalStrings.items.tr,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text(
                              '${LocalStrings.showQuantityAs.tr}:',
                              style: lightSmall.copyWith(
                                  color: ColorResources.blueGreyColor),
                            ),
                            const SizedBox(width: Dimensions.space5),
                            const Icon(
                              Icons.circle,
                              size: Dimensions.space15,
                              color: ColorResources.blueGreyColor,
                            ),
                            Text(
                              ' ${LocalStrings.qty.tr}',
                              style: lightSmall.copyWith(
                                  color: ColorResources.blueGreyColor),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(Dimensions.space15),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorResources.blueGreyColor,
                        ),
                        borderRadius:
                            BorderRadius.circular(Dimensions.space10)),
                    child: Column(
                      spacing: Dimensions.space15,
                      children: [
                        CustomTextField(
                          labelText: LocalStrings.itemName.tr,
                          controller: controller.itemController,
                          focusNode: controller.itemFocusNode,
                          textInputType: TextInputType.text,
                          nextFocus: controller.descriptionFocusNode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return LocalStrings.enterItemName.tr;
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            return;
                          },
                        ),
                        CustomTextField(
                          labelText: LocalStrings.description.tr,
                          textInputType: TextInputType.text,
                          controller: controller.descriptionController,
                          focusNode: controller.descriptionFocusNode,
                          nextFocus: controller.qtyFocusNode,
                          onChanged: (value) {
                            return;
                          },
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 4,
                              child: CustomTextField(
                                labelText: LocalStrings.qty.tr,
                                textInputType: TextInputType.number,
                                controller: controller.qtyController,
                                focusNode: controller.qtyFocusNode,
                                nextFocus: controller.unitFocusNode,
                                onChanged: (value) {
                                  return;
                                },
                              ),
                            ),
                            const SizedBox(width: Dimensions.space5),
                            Flexible(
                              flex: 2,
                              child: CustomTextField(
                                labelText: LocalStrings.unit.tr,
                                textInputType: TextInputType.text,
                                controller: controller.unitController,
                                focusNode: controller.unitFocusNode,
                                nextFocus: controller.rateFocusNode,
                                onChanged: (value) {
                                  return;
                                },
                              ),
                            ),
                          ],
                        ),
                        CustomTextField(
                          labelText: LocalStrings.rate.tr,
                          textInputType: TextInputType.number,
                          focusNode: controller.rateFocusNode,
                          controller: controller.rateController,
                          onChanged: (value) {
                            controller.calculateEstimateAmount();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return LocalStrings.enterRate.tr;
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  if (controller.estimateItemList.isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.estimateItemList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: Dimensions.space15),
                      itemBuilder: (context, index) {
                        return Badge(
                          offset: const Offset(-10, -10),
                          backgroundColor: ColorResources.colorRed,
                          largeSize: Dimensions.space23,
                          label: GestureDetector(
                            onTap: () {
                              controller.decreaseItemField(index);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: ColorResources.colorRed,
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.clear,
                                  color: ColorResources.colorWhite, size: 15),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(Dimensions.space15),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: ColorResources.blueGreyColor,
                                ),
                                borderRadius:
                                    BorderRadius.circular(Dimensions.space10)),
                            child: Column(
                              spacing: Dimensions.space15,
                              children: [
                                CustomTextField(
                                  labelText: LocalStrings.itemName.tr,
                                  controller: controller.estimateItemList[index]
                                      .itemNameController,
                                  textInputType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return LocalStrings.enterItemName.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (value) {
                                    return;
                                  },
                                ),
                                CustomTextField(
                                  labelText: LocalStrings.description.tr,
                                  textInputType: TextInputType.text,
                                  controller: controller.estimateItemList[index]
                                      .descriptionController,
                                  onChanged: (value) {
                                    return;
                                  },
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 4,
                                      child: CustomTextField(
                                        labelText: LocalStrings.qty.tr,
                                        textInputType: TextInputType.number,
                                        controller: controller
                                            .estimateItemList[index]
                                            .qtyController,
                                        onChanged: (value) {
                                          return;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: Dimensions.space5),
                                    Flexible(
                                      flex: 2,
                                      child: CustomTextField(
                                        labelText: LocalStrings.unit.tr,
                                        textInputType: TextInputType.text,
                                        controller: controller
                                            .estimateItemList[index]
                                            .unitController,
                                        onChanged: (value) {
                                          return;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                CustomTextField(
                                  labelText: LocalStrings.rate.tr,
                                  textInputType: TextInputType.number,
                                  controller: controller
                                      .estimateItemList[index].rateController,
                                  onChanged: (value) {
                                    controller.calculateEstimateAmount();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return LocalStrings.enterRate.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  GestureDetector(
                    onTap: () => controller.increaseItemField(),
                    child: TextIcon(
                      text: LocalStrings.addItems.tr,
                      textStyle: regularDefault.copyWith(
                          color: ColorResources.secondaryColor),
                      alignment: MainAxisAlignment.center,
                      icon: Icons.add_circle_outline_rounded,
                      iconSize: 20,
                    ),
                  ),
                  CustomTextField(
                    labelText: LocalStrings.clientNote.tr,
                    controller: controller.clientNoteController,
                    focusNode: controller.clientNoteFocusNode,
                    textInputType: TextInputType.multiline,
                    maxLines: 4,
                    nextFocus: controller.termsFocusNode,
                    onChanged: (value) {
                      return;
                    },
                  ),
                  CustomTextField(
                    labelText: LocalStrings.terms.tr,
                    controller: controller.termsController,
                    focusNode: controller.termsFocusNode,
                    textInputType: TextInputType.multiline,
                    maxLines: 4,
                    onChanged: (value) {
                      return;
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar:
          GetBuilder<EstimateController>(builder: (controller) {
        return controller.isLoading
            ? const CustomLoader()
            : controller.isSubmitLoading
                ? const RoundedLoadingBtn()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.space10),
                    child: RoundedButton(
                      text: LocalStrings.submit.tr,
                      press: () {
                        controller.submitEstimate();
                      },
                    ),
                  );
      }),
    );
  }
}
