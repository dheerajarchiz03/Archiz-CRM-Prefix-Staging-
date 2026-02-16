import 'package:archiz_staging_admin/core/service/api_service.dart';
import 'package:archiz_staging_admin/core/utils/method.dart';
import 'package:archiz_staging_admin/core/utils/url_container.dart';
import 'package:archiz_staging_admin/common/models/response_model.dart';
import 'package:archiz_staging_admin/features/lead/model/lead_create_model.dart';

class LeadRepo {
  ApiClient apiClient;
  LeadRepo({required this.apiClient});

  Future<ResponseModel> getAllLeads() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.leadsUrl}";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getLeadDetails(leadId) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.leadsUrl}/id/$leadId";
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

  Future<ResponseModel> getLeadStatuses() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/leads_statuses";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getLeadSources() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/leads_sources";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> createLead(LeadCreateModel leadModel,
      {String? leadId, bool isUpdate = false}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.leadsUrl}";

    Map<String, dynamic> params = {
      "source": leadModel.source,
      "status": leadModel.status,
      "name": leadModel.name,
      "assigned": leadModel.assigned,
      "tags": leadModel.tags,
      "lead_value": leadModel.value,
      "title": leadModel.title,
      "email": leadModel.email,
      "website": leadModel.website,
      "phonenumber": leadModel.phoneNumber,
      "company": leadModel.company,
      "address": leadModel.address,
      "city": leadModel.city,
      "state": leadModel.state,
      "country": leadModel.country,
      "default_language": leadModel.defaultLanguage,
      "description": leadModel.description,
      "is_public": leadModel.isPublic,
    };

    ResponseModel responseModel = await apiClient.request(
        isUpdate ? '$url/id/$leadId' : url,
        isUpdate ? Method.putMethod : Method.postMethod,
        params,
        passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> deleteLead(leadId) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.leadsUrl}/id/$leadId";
    ResponseModel responseModel = await apiClient
        .request(url, Method.deleteMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> searchLead(keysearch) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.leadsUrl}/search/$keysearch";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }
}
