import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart/data/api/api_client.dart';
import 'package:sixam_mart/data/model/body/place_order_body.dart';
import 'package:sixam_mart/helper/global_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  OrderRepo({required this.apiClient, required this.sharedPreferences});

  // Future<Response> getRunningOrderList(int offset) async {
  //   return await apiClient.getData('${AppConstants.runningOrderListUri}?offset=$offset&limit=${50}');
  // }
  // GET
  Future<Response> getRunningOrderList(int offset) async {
    return await GlobalHelper.getDataForController('${AppConstants.runningOrderListUri}?offset=$offset&limit=${50}', '${AppConstants.RUNNING_ORDER_LIST}_$offset', sharedPreferences, apiClient);
  }

  // UPDATE
  Future updateRunningOrderList(int offset) async {
    await GlobalHelper.updateDataForController('${AppConstants.runningOrderListUri}?offset=$offset&limit=${50}', '${AppConstants.RUNNING_ORDER_LIST}_$offset', sharedPreferences, apiClient);
  }


  // Future<Response> getHistoryOrderList(int offset) async {
  //   return await apiClient.getData('${AppConstants.historyOrderListUri}?offset=$offset&limit=10');
  // }

  // GET
  Future<Response> getHistoryOrderList(int offset) async {
    return await GlobalHelper.getDataForController('${AppConstants.historyOrderListUri}?offset=$offset&limit=10', '${AppConstants.HISTORY_ORDER_LIST}_$offset', sharedPreferences, apiClient);
  }

  // UPDATE
  Future updateHistoryOrderList(int offset) async {
    await GlobalHelper.updateDataForController('${AppConstants.historyOrderListUri}?offset=$offset&limit=10', '${AppConstants.HISTORY_ORDER_LIST}_$offset', sharedPreferences, apiClient);
  }

  // Future<Response> getOrderDetails(String orderID) async {
  //   return await apiClient.getData('${AppConstants.orderDetailsUri}$orderID');
  // }

    // GET
  Future<Response> getOrderDetails(String orderID) async {
    return await GlobalHelper.getDataForController('${AppConstants.orderDetailsUri}$orderID', '${AppConstants.ORDER}_$orderID', sharedPreferences, apiClient);
  }

  // UPDATE
  Future updateOrderDetails(String orderID) async {
    await GlobalHelper.updateDataForController('${AppConstants.orderDetailsUri}$orderID', '${AppConstants.ORDER}_$orderID', sharedPreferences, apiClient);
  }

  Future<Response> cancelOrder(String orderID, String? reason) async {
    return await apiClient.postData(AppConstants.orderCancelUri, {'_method': 'put', 'order_id': orderID, 'reason': reason});
  }

  // Future<Response> trackOrder(String? orderID) async {
  //   return await apiClient.getData('${AppConstants.trackUri}$orderID');
  // }
   // GET ///Has New Use
  Future<Response> trackOrder(String? orderID) async {
    return await GlobalHelper.getDataForController('${AppConstants.trackUri}$orderID', '${AppConstants.TRACK_ORDER}_$orderID', sharedPreferences, apiClient);
  }

  // UPDATE
  Future updateTrackOrder(String? orderID) async {
    await GlobalHelper.updateDataForController('${AppConstants.trackUri}$orderID', '${AppConstants.TRACK_ORDER}_$orderID', sharedPreferences, apiClient);
  }

  Future<Response> placeOrder(PlaceOrderBody orderBody, XFile? orderAttachment) async {
    return await apiClient.postMultipartData(
      AppConstants.placeOrderUri, orderBody.toJson(),
      [MultipartBody('order_attachment', orderAttachment)],
    );
  }

  Future<Response> placePrescriptionOrder(int? storeId, double? distance, String address, String longitude,
      String latitude, String note, List<MultipartBody> orderAttachment, String dmTips, String deliveryInstruction) async {

    Map<String, String> body = {
      'store_id': storeId.toString(),
      'distance': distance.toString(),
      'address': address,
      'longitude': longitude,
      'latitude': latitude,
      'order_note': note,
      'dm_tips': dmTips,
      'delivery_instruction': deliveryInstruction,
    };
    return await apiClient.postMultipartData(AppConstants.placePrescriptionOrderUri, body, orderAttachment);
  }

  Future<Response> getDeliveryManData(String orderID) async {
    return await apiClient.getData('${AppConstants.lastLocationUri}$orderID');
  }

  Future<Response> switchToCOD(String? orderID) async {
    return await apiClient.postData(AppConstants.codSwitchUri, {'_method': 'put', 'order_id': orderID});
  }

  Future<Response> getDistanceInMeter(LatLng originLatLng, LatLng destinationLatLng, bool isRiding) async {
    return await apiClient.getData('${AppConstants.distanceMatrixUri}'
        '?origin_lat=${originLatLng.latitude}&origin_lng=${originLatLng.longitude}'
        '&destination_lat=${destinationLatLng.latitude}&destination_lng=${destinationLatLng.longitude}&mode=${isRiding ? 'driving' : 'walking'}');
  }

  Future<Response> getRefundReasons() async {
    return await apiClient.getData(AppConstants.refundReasonUri);
  }

  Future<Response> submitRefundRequest(Map<String, String> body, XFile? data) async {
    return apiClient.postMultipartData(AppConstants.refundRequestUri, body,  [MultipartBody('image[]', data)]);
  }

  Future<Response> getExtraCharge(double? distance) async {
    return await apiClient.getData('${AppConstants.vehicleChargeUri}?distance=$distance');
  }

  Future<Response> getCancelReasons() async {
    return await apiClient.getData('${AppConstants.orderCancellationUri}?offset=1&limit=30&type=customer');
  }

  Future<Response> getDmTipMostTapped() async {
    return await apiClient.getData(AppConstants.mostTipsUri);
  }
}