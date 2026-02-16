import 'package:archiz_staging_admin/common/components/app-bar/custom_appbar.dart';
import 'package:archiz_staging_admin/common/components/buttons/rounded_button.dart';
import 'package:archiz_staging_admin/common/components/buttons/rounded_loading_button.dart';
import 'package:archiz_staging_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/core/utils/local_strings.dart';
import 'package:archiz_staging_admin/features/customer/controller/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddContactScreen extends StatelessWidget {
  const AddContactScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.addContact.tr,
      ),
      body: GetBuilder<CustomerController>(
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
                    labelText: LocalStrings.firstName.tr,
                    controller: controller.firstNameController,
                    focusNode: controller.firstNameFocusNode,
                    textInputType: TextInputType.text,
                    nextFocus: controller.lastNameFocusNode,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocalStrings.enterFirstName.tr;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      return;
                    },
                  ),
                  CustomTextField(
                    labelText: LocalStrings.lastName.tr,
                    controller: controller.lastNameController,
                    focusNode: controller.lastNameFocusNode,
                    textInputType: TextInputType.text,
                    nextFocus: controller.emailFocusNode,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocalStrings.enterLastName.tr;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      return;
                    },
                  ),
                  CustomTextField(
                    labelText: LocalStrings.email.tr,
                    controller: controller.emailController,
                    focusNode: controller.emailFocusNode,
                    textInputType: TextInputType.text,
                    nextFocus: controller.titleFocusNode,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocalStrings.enterEmail.tr;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      return;
                    },
                  ),
                  CustomTextField(
                    labelText: LocalStrings.title.tr,
                    controller: controller.titleController,
                    focusNode: controller.titleFocusNode,
                    textInputType: TextInputType.text,
                    nextFocus: controller.phoneFocusNode,
                    onChanged: (value) {
                      return;
                    },
                  ),
                  CustomTextField(
                    labelText: LocalStrings.phone.tr,
                    controller: controller.phoneController,
                    focusNode: controller.phoneFocusNode,
                    textInputType: TextInputType.number,
                    nextFocus: controller.passwordFocusNode,
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
                  CustomTextField(
                    labelText: LocalStrings.password.tr,
                    controller: controller.passwordController,
                    focusNode: controller.passwordFocusNode,
                    textInputType: TextInputType.text,
                    isShowSuffixIcon: true,
                    isPassword: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocalStrings.enterYourPassword.tr;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      return;
                    },
                  ),
                  const SizedBox(height: Dimensions.space25),
                  controller.isSubmitLoading
                      ? const RoundedLoadingBtn()
                      : RoundedButton(
                          text: LocalStrings.submit.tr,
                          press: () {
                            controller.submitContact(id);
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
