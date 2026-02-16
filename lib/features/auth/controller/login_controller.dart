import 'dart:convert';

import 'package:archiz_staging_admin/features/auth/model/login_model.dart';
import 'package:archiz_staging_admin/features/auth/repo/auth_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:archiz_staging_admin/core/helper/shared_preference_helper.dart';
import 'package:archiz_staging_admin/core/route/route.dart';
import 'package:archiz_staging_admin/common/models/response_model.dart';
import 'package:archiz_staging_admin/common/components/snack_bar/show_custom_snackbar.dart';

class LoginController extends GetxController {
  AuthRepo loginRepo;

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  TextEditingController emailController =
      TextEditingController();
  TextEditingController passwordController =
      TextEditingController();

  String? email;
  String? password;
  bool remember = false;

  LoginController({required this.loginRepo});

  Future<void> checkAndGotoNextStep(LoginModel responseModel) async {
    if (remember) {
      await loginRepo.apiClient.sharedPreferences
          .setBool(SharedPreferenceHelper.rememberMeKey, true);
    } else {
      await loginRepo.apiClient.sharedPreferences
          .setBool(SharedPreferenceHelper.rememberMeKey, false);
    }
    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.userIdKey,
        responseModel.data?.staffId.toString() ?? '-1');
    print('Save Token after login: ${ responseModel.data?.accessToken.toString()}');
    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.accessTokenKey,
        responseModel.data?.accessToken.toString() ?? '');
    Get.offAndToNamed(RouteHelper.dashboardScreen);

    if (remember) {
      changeRememberMe();
    }
  }

  bool isSubmitLoading = false;

  void loginUser() async {
    isSubmitLoading = true;
    update();

    ResponseModel responseModel = await loginRepo.loginUser(
        emailController.text.toString(), passwordController.text.toString());

    if (responseModel.status) {
      LoginModel loginModel =
          LoginModel.fromJson(jsonDecode(responseModel.responseJson));
      checkAndGotoNextStep(loginModel);
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isSubmitLoading = false;
    update();
  }

  changeRememberMe() {
    remember = !remember;
    update();
  }

  void clearTextField() {
    passwordController.text = '';
    emailController.text = '';
    if (remember) {
      remember = false;
    }
    update();
  }
}
