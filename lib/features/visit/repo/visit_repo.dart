import 'package:archiz_staging_admin/core/service/api_service.dart';
import 'package:archiz_staging_admin/core/utils/method.dart';
import 'package:archiz_staging_admin/core/utils/url_container.dart';
import 'package:archiz_staging_admin/common/models/response_model.dart';
import 'package:archiz_staging_admin/features/lead/model/lead_create_model.dart';
import 'package:archiz_staging_admin/features/visit/model/visit_create_model.dart';

class VisitRepo {
  ApiClient apiClient;
  VisitRepo({required this.apiClient});

  Future<ResponseModel> getAllVisits() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.visitUrl}";
    ResponseModel responseModel =
    await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getVisitDetails(visitId) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.visitUrl}/visite/id/$visitId";
    ResponseModel responseModel =
    await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> attachmentDownload(String attachmentKey) async {
    String url = "${UrlContainer.leadAttachmentUrl}/$attachmentKey";
    ResponseModel responseModel =
    await apiClient.request(url, Method.postMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getAllCustomers() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.customersUrl}";
    ResponseModel responseModel =
    await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getCustomerContacts(customerId) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.contactsUrl}/id/$customerId";
    ResponseModel responseModel =
    await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getTicketDepartments() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/ticket_departments";
    ResponseModel responseModel =
    await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getTicketPriorities() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/ticket_priorities";
    ResponseModel responseModel =
    await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }
  Future<ResponseModel> createVisit(VisitCreateModel visitModel,
      {String? visitId, bool isUpdate = false}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.visitUrl}";
    print('====>Visit url: ${url.toString()}');
    print('====>Visit Data: ${visitModel.client} - ${visitModel.name} - ${visitModel.department} -'
        ' ${visitModel.priority} - ${visitModel.visitDate} - ${visitModel.description} - ${visitModel.status} ');
    Map<String, dynamic> params = {
      "client_id": visitModel.client,
      "contact_name": visitModel.name,
      "department": visitModel.department,
      "priority": visitModel.priority,
      "visit_date": visitModel.visitDate,
      "purpose": visitModel.description,
      "status": visitModel.status,
    };

    ResponseModel responseModel = await apiClient.request(
        isUpdate ? '$url/id/$visitId' : url,
        isUpdate ? Method.putMethod : Method.postMethod,
        params,
        passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> deleteVisit(leadId) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.visitUrl}/id/$leadId";
    ResponseModel responseModel = await apiClient
        .request(url, Method.deleteMethod, null, passHeader: true);
    return responseModel;
  }
  Future<ResponseModel> startVisit(visitId) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.visitUrl}/visit_timeline/$visitId";
    ResponseModel responseModel = await apiClient
        .request(url, Method.postMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> stopVisit(visitId) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.visitUrl}/visit_timeline/$visitId";
    ResponseModel responseModel = await apiClient
        .request(url, Method.putMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> searchLead(keysearch) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.visitUrl}/search/$keysearch";
    ResponseModel responseModel =
    await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }
}
