import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/data/api/api_client.dart';
import 'package:sixam_mart/helper/global_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class CouponRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  CouponRepo({required this.apiClient,required this.sharedPreferences});

  // Future<Response> getCouponList() async {
  //   return await apiClient.getData(AppConstants.couponUri);
  // }

// GET
  Future<Response> getCouponList() async {
    return await GlobalHelper.getDataForController(AppConstants.couponUri, AppConstants.COUPON_LIST, sharedPreferences, apiClient);
  }

  // UPDATE
  Future updateCouponList() async {
    await GlobalHelper.updateDataForController(AppConstants.couponUri, AppConstants.COUPON_LIST, sharedPreferences, apiClient);
  }
  Future<Response> getTaxiCouponList() async {
    return await apiClient.getData(AppConstants.taxiCouponUri);
  }

  Future<Response> applyCoupon(String couponCode, int? storeID) async {
    return await apiClient.getData('${AppConstants.couponApplyUri}$couponCode&store_id=$storeID');
  }

  Future<Response> applyTaxiCoupon(String couponCode, int? providerId) async {
    return await apiClient.getData('${AppConstants.taxiCouponApplyUri}$couponCode&provider_id=$providerId');
  }
}