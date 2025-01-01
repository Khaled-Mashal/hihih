import 'package:get/get_connect/http/src/response/response.dart';
// import 'package:saffari_customer_app/data/api/api_client.dart';
// import 'package:saffari_customer_app/helper/global_helper.dart';
// import 'package:saffari_customer_app/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/data/api/api_client.dart';
import 'package:sixam_mart/helper/global_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';

class PaymentMethodRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  PaymentMethodRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getPaymentMethodList() async {
    return await GlobalHelper.getDataForController(
        AppConstants.PAYMENT_METHOD_URL,
        AppConstants.PAYMENT_METHOD_LIST,
        sharedPreferences,
        apiClient);
  }

  Future updatePaymentMethodList() async {
    await GlobalHelper.updateDataForController(AppConstants.PAYMENT_METHOD_URL,
        AppConstants.PAYMENT_METHOD_LIST, sharedPreferences, apiClient);
  }

  Future<Response> sendUserAccountNumber(
      String apiUrl, Map<String, dynamic> body) async {
    return await apiClient.postData('/$apiUrl', body);
  }

  Future<Response> sendUserOTP(String apiUrl, Map<String, dynamic> body) async {
    return await apiClient.postData('/$apiUrl', body);
  }
}
