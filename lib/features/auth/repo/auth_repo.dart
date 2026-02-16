import 'package:archiz_staging_admin/core/service/api_service.dart';
import 'package:archiz_staging_admin/core/utils/method.dart';
import 'package:archiz_staging_admin/core/utils/url_container.dart';
import 'package:archiz_staging_admin/common/models/response_model.dart';

class AuthRepo {
  ApiClient apiClient;

  AuthRepo({required this.apiClient});

  Future<ResponseModel> loginUser(String email, String password) async {
    Map<String, String> map = {'email': email, 'password': password};
    String url = '${UrlContainer.baseUrl}${UrlContainer.loginUrl}';
    ResponseModel responseModel =
        await apiClient.request(url, Method.postMethod, map, passHeader: false);
    return responseModel;
  }

  Future<ResponseModel> forgetPassword(String email) async {
    Map<String, String> map = {'email': email};
    String url = '${UrlContainer.baseUrl}${UrlContainer.forgotPasswordUrl}';
    ResponseModel responseModel =
        await apiClient.request(url, Method.postMethod, map, passHeader: false);
    return responseModel;
  }
}
