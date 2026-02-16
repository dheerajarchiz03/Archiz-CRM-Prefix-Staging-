import 'dart:async';
import 'dart:convert';
import 'package:archiz_staging_admin/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:archiz_staging_admin/common/models/response_model.dart';
import 'package:archiz_staging_admin/features/payment/model/payment_details_model.dart';
import 'package:archiz_staging_admin/features/payment/model/payment_model.dart';
import 'package:archiz_staging_admin/features/payment/repo/payment_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  PaymentRepo paymentRepo;
  PaymentController({required this.paymentRepo});

  bool isLoading = true;
  PaymentsModel paymentsModel = PaymentsModel();
  PaymentDetailsModel paymentDetailsModel = PaymentDetailsModel();

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();

    await loadPayments();
    isLoading = false;
    update();
  }

  Future<void> loadPayments() async {
    ResponseModel responseModel = await paymentRepo.getAllPayments();
    if (responseModel.status) {
      paymentsModel =
          PaymentsModel.fromJson(jsonDecode(responseModel.responseJson));
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }

  Future<void> loadPaymentDetails(paymentId) async {
    ResponseModel responseModel =
        await paymentRepo.getPaymentDetails(paymentId);
    if (responseModel.status) {
      paymentDetailsModel =
          PaymentDetailsModel.fromJson(jsonDecode(responseModel.responseJson));
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isLoading = false;
    update();
  }

  // Search Payments
  TextEditingController searchController = TextEditingController();
  String keysearch = "";

  Future<void> searchPayment() async {
    keysearch = searchController.text;
    ResponseModel responseModel = await paymentRepo.searchPayment(keysearch);
    if (responseModel.status) {
      paymentsModel =
          PaymentsModel.fromJson(jsonDecode(responseModel.responseJson));
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isLoading = false;
    update();
  }

  bool isSearch = false;
  void changeSearchIcon() {
    isSearch = !isSearch;
    update();

    if (!isSearch) {
      searchController.clear();
      initialData();
    }
  }
}
