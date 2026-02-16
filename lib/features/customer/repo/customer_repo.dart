import 'package:archiz_staging_admin/core/service/api_service.dart';
import 'package:archiz_staging_admin/core/utils/method.dart';
import 'package:archiz_staging_admin/core/utils/url_container.dart';
import 'package:archiz_staging_admin/common/models/response_model.dart';
import 'package:archiz_staging_admin/features/customer/model/contact_post_model.dart';
import 'package:archiz_staging_admin/features/customer/model/customer_post_model.dart';

class CustomerRepo {
  ApiClient apiClient;
  CustomerRepo({required this.apiClient});

  Future<ResponseModel> getAllCustomers() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.customersUrl}";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getCustomerDetails(customerId) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.customersUrl}/id/$customerId";
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

  Future<ResponseModel> getCustomerGroups() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/client_groups";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getCountries() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/countries";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> getCurrencies() async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.miscellaneousUrl}/currencies";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> submitCustomer(CustomerPostModel customerModel,
      {String? customerId, bool isUpdate = false}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.customersUrl}";

    Map<String, dynamic> params = {
      "company": customerModel.company,
      "vat": customerModel.vat,
      "phonenumber": customerModel.phoneNumber,
      "website": customerModel.website,
      //"default_language": customerModel.defaultLanguage,
      "default_currency": customerModel.defaultCurrency,
      "address": customerModel.address,
      "city": customerModel.city,
      "state": customerModel.state,
      "zip": customerModel.zip,
      "country": customerModel.country,
      "billing_street": customerModel.billingStreet,
      "billing_city": customerModel.billingCity,
      "billing_state": customerModel.billingState,
      "billing_zip": customerModel.billingZip,
      "billing_country": customerModel.billingCountry,
      "shipping_street": customerModel.shippingStreet,
      "shipping_city": customerModel.shippingCity,
      "shipping_state": customerModel.shippingState,
      "shipping_zip": customerModel.shippingZip,
      "shipping_country": customerModel.shippingCountry,
    };

    if (customerModel.groupsIn != null) {
      int i = 0;
      for (var group in customerModel.groupsIn!) {
        params['groups_in[$i]'] = group;
        i++;
      }
    }

    ResponseModel responseModel = await apiClient.request(
        isUpdate ? '$url/id/$customerId' : url,
        isUpdate ? Method.putMethod : Method.postMethod,
        params,
        passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> deleteCustomer(customerId) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.customersUrl}/id/$customerId";
    ResponseModel responseModel = await apiClient
        .request(url, Method.deleteMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> searchCustomer(keysearch) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.customersUrl}/search/$keysearch";
    ResponseModel responseModel =
        await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> createContact(ContactPostModel contactModel) async {
    String url =
        "${UrlContainer.baseUrl}${UrlContainer.contactsUrl}/id/${contactModel.customerId}";

    Map<String, dynamic> params = {
      "firstname": contactModel.firstName,
      "lastname": contactModel.lastName,
      "email": contactModel.email,
      "title": contactModel.title,
      "phonenumber": contactModel.phone,
      "password": contactModel.password,
    };

    ResponseModel responseModel = await apiClient
        .request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }
}
