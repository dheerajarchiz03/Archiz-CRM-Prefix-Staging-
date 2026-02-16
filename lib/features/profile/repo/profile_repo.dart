import 'package:archiz_staging_admin/core/service/api_service.dart';
import 'package:archiz_staging_admin/core/utils/method.dart';
import 'package:archiz_staging_admin/core/utils/url_container.dart';
import 'package:archiz_staging_admin/common/models/response_model.dart';

class ProfileRepo {
  ApiClient apiClient;
  ProfileRepo({required this.apiClient});

  Future<ResponseModel> getData() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.profileUrl}";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }
}
