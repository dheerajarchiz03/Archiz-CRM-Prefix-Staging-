import 'dart:async';
import 'dart:convert';
import 'package:archiz_staging_admin/common/components/file_download_dialog/download_dialog.dart';
import 'package:archiz_staging_admin/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:archiz_staging_admin/core/utils/local_strings.dart';
import 'package:archiz_staging_admin/common/models/response_model.dart';
import 'package:archiz_staging_admin/features/lead/model/lead_create_model.dart';
import 'package:archiz_staging_admin/features/lead/model/lead_details_model.dart';
import 'package:archiz_staging_admin/features/lead/model/lead_model.dart';
import 'package:archiz_staging_admin/features/lead/model/sources_model.dart';
import 'package:archiz_staging_admin/features/lead/model/statuses_model.dart';
import 'package:archiz_staging_admin/features/lead/repo/lead_repo.dart';
import 'package:archiz_staging_admin/features/visit/model/visit_create_model.dart';
import 'package:archiz_staging_admin/features/visit/model/visits_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../customer/model/contact_model.dart';
import '../../customer/model/customer_model.dart';
import '../../ticket/model/departments_model.dart';
import '../../ticket/model/priorities_model.dart';
import '../model/visit_details_model.dart';
import '../repo/visit_repo.dart';

class VisitController extends GetxController {
  VisitRepo visitRepo;

  VisitController({required this.visitRepo});

  bool isLoading = true;
  bool isSubmitLoading = false;
  VisitsModel visitsModel = VisitsModel();
  VisitDetailsModel visitDetailsModel = VisitDetailsModel();
  String selectedCustomer = '';
  CustomersModel customersModel = CustomersModel();
  ContactsModel contactsModel = ContactsModel();
  DepartmentModel departmentModel = DepartmentModel();
  PriorityModel priorityModel = PriorityModel();

  // Visit type radio button variables
  String selectedVisitType = 'current'; // 'current' or 'future'

  // Date and time variables
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();

    await loadVisits();
    isLoading = false;
    update();
  }

  Future<void> loadVisits() async {
    ResponseModel responseModel = await visitRepo.getAllVisits();
    if (responseModel.status) {
      visitsModel = VisitsModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }

  Future<void> loadVisitDetails(visitId) async {
    ResponseModel responseModel = await visitRepo.getVisitDetails(visitId);
    if (responseModel.status) {
      visitDetailsModel = VisitDetailsModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isLoading = false;
    update();
  }

  bool downloadLoading = false;

  Future<void> downloadAttachment(
    String attachmentType,
    String attachmentKey,
  ) async {
    downloadLoading = true;
    update();

    ResponseModel responseModel = await visitRepo.attachmentDownload(
      attachmentKey,
    );
    if (responseModel.status) {
      showDialog(
        context: Get.context!,
        builder: (context) => DownloadingDialog(
          isImage: true,
          isPdf: false,
          url: attachmentType,
          fileName: attachmentKey,
        ),
      );
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    downloadLoading = false;
    update();
  }

  Future<CustomersModel> loadCustomers() async {
    ResponseModel responseModel = await visitRepo.getAllCustomers();
    return customersModel = CustomersModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<ContactsModel> loadCustomerContacts(userId) async {
    ResponseModel responseModel = await visitRepo.getCustomerContacts(userId);
    return contactsModel = ContactsModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<DepartmentModel> loadDepartments() async {
    ResponseModel responseModel = await visitRepo.getTicketDepartments();
    return departmentModel = DepartmentModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }

  Future<PriorityModel> loadPriorities() async {
    ResponseModel responseModel = await visitRepo.getTicketPriorities();
    return priorityModel = PriorityModel.fromJson(
      jsonDecode(responseModel.responseJson),
    );
  }


  TextEditingController nameController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController visitDateController = TextEditingController();
  TextEditingController visitTypeController = TextEditingController();

  FocusNode descriptionFocusNode = FocusNode();
  FocusNode isPublicFocusNode = FocusNode();
  FocusNode departmentFocusNode = FocusNode();
  FocusNode priorityFocusNode = FocusNode();
  FocusNode userFocusNode = FocusNode();
  FocusNode contactFocusNode = FocusNode();
  FocusNode visitDateFocusNode = FocusNode();
  FocusNode visitTypeFocusNode = FocusNode();

  Future<void> submitVisit({String? visitId, bool isUpdate = false}) async {
    String name = contactController.text.toString();
    String client = userController.text.toString();
    String department = departmentController.text.toString();
    String priority = priorityController.text.toString();
    String user = userController.text.toString();
    String contact = contactController.text.toString();
    String description = descriptionController.text.toString();
    String visitDate = '${selectedDate} ${selectedTime}';
    String status = visitTypeController.text.toString();

    if (contact.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterName.tr]);
      return;
    }

    isSubmitLoading = true;
    update();

    VisitCreateModel ticketModel = VisitCreateModel(
      client: client,
      name: name,
      department: department,
      userId: user,
      contactId: contact,
      priority: priority,
      description: description,
      visitDate: visitDate,
      status: status,
    );

    ResponseModel responseModel = await visitRepo.createVisit(
      ticketModel,
      visitId: visitId,
      isUpdate: isUpdate,
    );
    if (responseModel.status) {
      Get.back();
      if (isUpdate) await loadVisitDetails(visitId);
      await initialData();
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isSubmitLoading = false;
    update();
  }

  // Delete Lead
  Future<void> deleteVisit(leadId) async {
    ResponseModel responseModel = await visitRepo.deleteVisit(leadId);

    isSubmitLoading = true;
    update();

    if (responseModel.status) {
      await initialData();
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [(responseModel.message.tr)]);
    }

    isSubmitLoading = false;
    update();
  }

  // Search Leads
  TextEditingController searchController = TextEditingController();
  String keysearch = "";

  Future<void> searchVisit() async {
    keysearch = searchController.text;
    ResponseModel responseModel = await visitRepo.searchLead(keysearch);
    if (responseModel.status) {
      visitsModel = VisitsModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );
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

  void clearData() {
    isLoading = false;
    isSubmitLoading = false;
    selectedVisitType = 'current';
    selectedDate = null;
    selectedTime = null;
  }

  // Method to handle visit type selection
  void setVisitType(String type) {
    selectedVisitType = type;
    if (type == 'current') {
      // Set current date and time for current visit
      selectedDate = DateTime.now();
      selectedTime = TimeOfDay.now();
    } else {
      // Clear date and time for future visit (user will select)
      selectedDate = null;
      selectedTime = null;
    }
    update();
  }
  @override
  void onInit() {
    super.onInit();

    // ⬅️ Set CURRENT DATE as default
    selectedDate = DateTime.now();

    // ⬅️ Set DEFAULT TIME = 20:00
    selectedTime = const TimeOfDay(hour: 20, minute: 0);
  }
  // Method to handle date selection
  Future<void> selectDate(BuildContext context) async {
    if (selectedVisitType == 'future') {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (picked != null && picked != selectedDate) {
        selectedDate = picked;
        update();
      }
    }
  }

  // Method to handle time selection
  Future<void> selectTime(BuildContext context) async {
    if (selectedVisitType == 'future') {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime ?? TimeOfDay.now(),
      );
      if (picked != null && picked != selectedTime) {
        selectedTime = picked;
        update();
      }
    }
  }
}
