import 'package:archiz_staging_admin/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:archiz_staging_admin/common/models/response_model.dart';
import 'package:archiz_staging_admin/features/privacy/model/privacy_response_model.dart';
import 'package:archiz_staging_admin/features/privacy/repo/privacy_repo.dart';
import 'package:get/get.dart';

class PrivacyController extends GetxController {
  int selectedIndex = 1;
  PrivacyRepo repo;
  bool isLoading = true;

  List<PolicyPages> list = [];
  late var selectedHtml = '';
  PrivacyController({required this.repo});

  void loadData() async {
    ResponseModel model = await repo.loadAboutData();
    if (model.status) {
      PrivacyResponseModel responseModel =
          PrivacyResponseModel.fromJson(model.responseJson);
      if (responseModel.data?.policyPages != null &&
          responseModel.data!.policyPages != null &&
          responseModel.data!.policyPages!.isNotEmpty) {
        list.clear();

        list.addAll(responseModel.data!.policyPages!);
        changeIndex(0);
        updateLoading(false);
      }
    } else {
      CustomSnackBar.error(errorList: [model.message.tr]);
      updateLoading(false);
    }
  }

  void changeIndex(int index) {
    selectedIndex = index;
    selectedHtml = list[index].dataValues?.details ?? '';
    update();
  }

  updateLoading(bool status) {
    isLoading = status;
    update();
  }
}
