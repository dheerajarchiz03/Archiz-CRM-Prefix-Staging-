import 'package:archiz_staging_admin/common/components/app-bar/custom_appbar.dart';
import 'package:archiz_staging_admin/common/components/buttons/add_icon_button.dart';
import 'package:archiz_staging_admin/common/components/buttons/rounded_button.dart';
import 'package:archiz_staging_admin/common/components/buttons/rounded_loading_button.dart';
import 'package:archiz_staging_admin/common/components/custom_date_form_field.dart';
import 'package:archiz_staging_admin/common/components/custom_drop_down_button_with_text_field.dart';
import 'package:archiz_staging_admin/common/components/custom_loader/custom_loader.dart';
import 'package:archiz_staging_admin/common/components/divider/custom_divider.dart';
import 'package:archiz_staging_admin/common/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:archiz_staging_admin/common/components/text-form-field/custom_multi_drop_down_text_field.dart';
import 'package:archiz_staging_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:archiz_staging_admin/common/components/text/text_icon.dart';
import 'package:archiz_staging_admin/common/models/currencies_model.dart';
import 'package:archiz_staging_admin/common/models/payment_modes_model.dart';
import 'package:archiz_staging_admin/core/helper/date_converter.dart';
import 'package:archiz_staging_admin/core/utils/color_resources.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/core/utils/local_strings.dart';
import 'package:archiz_staging_admin/core/utils/style.dart';
import 'package:archiz_staging_admin/features/customer/model/customer_model.dart';
import 'package:archiz_staging_admin/features/invoice/controller/invoice_controller.dart';
import 'package:archiz_staging_admin/features/invoice/model/invoice_item_model.dart';
import 'package:archiz_staging_admin/features/item/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class AddInvoiceScreen extends StatefulWidget {
  const AddInvoiceScreen({super.key});

  @override
  State<AddInvoiceScreen> createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  final AsyncMemoizer<CustomersModel> customersMemoizer = AsyncMemoizer();
  final AsyncMemoizer<CurrenciesModel> currenciesMemoizer = AsyncMemoizer();
  final AsyncMemoizer<PaymentModesModel> paymentModesMemoizer = AsyncMemoizer();
  final AsyncMemoizer<ItemsModel> itemsMemoizer = AsyncMemoizer();

  @override
  void dispose() {
    Get.find<InvoiceController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.addInvoice.tr,
      ),
      body: GetBuilder<InvoiceController>(
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
                    nextFocus: controller.clientFocusNode,
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
                            //selectedValue: controller.clientController.text,
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
                          currenciesMemoizer.runOnce(controller.loadCurrencies),
                      builder: (context, currenciesList) {
                        if (currenciesList.data?.status ?? false) {
                          return CustomDropDownTextField(
                            hintText: LocalStrings.selectCurrency.tr,
                            onChanged: (value) {
                              controller.currencyController.text = value;
                            },
                            //selectedValue: controller.currencyController.text,
                            items: controller.currenciesModel.data!
                                .map((currency) {
                              return DropdownMenuItem(
                                value: currency.id,
                                child: Text(
                                  currency.name ?? '',
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
                          return const CustomLoader(isFullScreen: false);
                        }
                      }),

                  FutureBuilder(
                      future: paymentModesMemoizer
                          .runOnce(controller.loadPaymentModes),
                      builder: (context, paymentModesList) {
                        if (paymentModesList.data?.status ?? false) {
                          return CustomMultiDropDownTextField(
                            controller: controller.paymentModeController,
                            hintText: LocalStrings.selectPaymentMode.tr,
                            onChanged: (options) {
                              controller.allowedPaymentModesList.clear();
                              for (var v in options) {
                                controller.allowedPaymentModesList
                                    .add(v.toString());
                              }
                              debugPrint(controller.allowedPaymentModesList
                                  .toString());
                            },
                            items: controller.paymentModesModel.data!
                                .map((paymentMode) {
                              return DropdownItem(
                                  label: paymentMode.name?.tr ?? '',
                                  value: paymentMode.id!);
                            }).toList(),
                          );
                        } else if (paymentModesList.data?.status == false) {
                          return CustomDropDownWithTextField(
                              selectedValue: LocalStrings.noPaymentModeFound.tr,
                              list: [LocalStrings.noPaymentModeFound.tr]);
                        } else {
                          return const CustomLoader(isFullScreen: false);
                        }
                      }),
                  const CustomDivider(space: Dimensions.space1),
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
                  FutureBuilder(
                      future: itemsMemoizer.runOnce(controller.loadItems),
                      builder: (context, itemsList) {
                        if (itemsList.data?.status ?? false) {
                          return Row(
                            children: [
                              Expanded(
                                flex: 10,
                                child: CustomDropDownTextField(
                                  hintText: LocalStrings.addItem.tr,
                                  onChanged: (value) {
                                    if (controller.itemController.text == '') {
                                      controller.itemController.text =
                                          value.description;
                                      controller.descriptionController.text =
                                          value.longDescription;
                                      controller.qtyController.text = '1';
                                      controller.unitController.text =
                                          value.unit;
                                      controller.rateController.text =
                                          value.rate;
                                    } else {
                                      controller.invoiceItemList
                                          .add(InvoiceItemModel(
                                        itemNameController:
                                            TextEditingController(
                                                text: value.description),
                                        descriptionController:
                                            TextEditingController(
                                                text: value.longDescription),
                                        qtyController:
                                            TextEditingController(text: '1'),
                                        unitController: TextEditingController(
                                            text: value.unit),
                                        rateController: TextEditingController(
                                            text: value.rate),
                                      ));
                                    }
                                    controller.update();
                                  },
                                  items: controller.itemsModel.data!
                                      .map((Item item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(
                                        item.description ?? '',
                                        style: regularDefault.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .color),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: AddIconButton(
                                    onTap: () {
                                      // Navigate to Add New Item Page
                                    },
                                  ))
                            ],
                          );
                        } else if (itemsList.data?.status == false) {
                          return CustomDropDownWithTextField(
                              selectedValue: LocalStrings.noItemFound.tr,
                              list: [LocalStrings.noItemFound.tr]);
                        } else {
                          return const CustomLoader(isFullScreen: false);
                        }
                      }),

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
                            controller.calculateInvoiceAmount();
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
                  if (controller.invoiceItemList.isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.invoiceItemList.length,
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
                                  controller: controller.invoiceItemList[index]
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
                                  controller: controller.invoiceItemList[index]
                                      .descriptionController,
                                  onChanged: (value) {
                                    return;
                                  },
                                ),
                                Row(
                                  spacing: Dimensions.space5,
                                  children: [
                                    Flexible(
                                      flex: 4,
                                      child: CustomTextField(
                                        labelText: LocalStrings.qty.tr,
                                        textInputType: TextInputType.number,
                                        controller: controller
                                            .invoiceItemList[index]
                                            .qtyController,
                                        onChanged: (value) {
                                          return;
                                        },
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: CustomTextField(
                                        labelText: LocalStrings.unit.tr,
                                        textInputType: TextInputType.text,
                                        controller: controller
                                            .invoiceItemList[index]
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
                                      .invoiceItemList[index].rateController,
                                  onChanged: (value) {
                                    controller.calculateInvoiceAmount();
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
      bottomNavigationBar: GetBuilder<InvoiceController>(builder: (controller) {
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
                        controller.submitInvoice();
                      },
                    ),
                  );
      }),
    );
  }
}
