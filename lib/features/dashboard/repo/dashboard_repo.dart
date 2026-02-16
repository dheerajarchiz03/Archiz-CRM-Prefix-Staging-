import 'package:archiz_staging_admin/core/service/api_service.dart';
import 'package:archiz_staging_admin/core/utils/method.dart';
import 'package:archiz_staging_admin/core/utils/url_container.dart';
import 'package:archiz_staging_admin/common/models/response_model.dart';

class DashboardRepo {
  ApiClient apiClient;
  DashboardRepo({required this.apiClient});

  Future<ResponseModel> getData() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.dashboardUrl}";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> logout() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.logoutUrl}';
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }
}
