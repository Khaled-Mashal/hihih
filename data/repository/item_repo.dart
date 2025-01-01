import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/data/api/api_client.dart';
import 'package:sixam_mart/data/model/body/review_body.dart';
import 'package:sixam_mart/helper/global_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:get/get.dart';

class ItemRepo extends GetxService {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
 ItemRepo({required this.apiClient, required this.sharedPreferences});

  // Future<Response> getPopularItemList(String type) async {
  //   return await apiClient.getData('${AppConstants.popularItemUri}?type=$type');
  // }
   // GET
  Future<Response> getPopularItemList(String type, String moduleID) async {
    return await GlobalHelper.getDataForController('${AppConstants.popularItemUri}?type=$type', '${AppConstants.POPULAR_ITEM_LIST}_$type-$moduleID', sharedPreferences, apiClient,isModuleIdRquired: true);
  }

  // UPDATE
  Future updatePopularItemList(String type, String moduleID) async {
    await GlobalHelper.updateDataForController('${AppConstants.popularItemUri}?type=$type', '${AppConstants.POPULAR_ITEM_LIST}_$type-$moduleID', sharedPreferences, apiClient,isModuleIdRquired: true);
  }

  // Future<Response> getReviewedItemList(String type) async {
  //   return await apiClient.getData('${AppConstants.reviewedItemUri}?type=$type');
  // }
    // GET
  Future<Response> getReviewedItemList(String type, String moduleID) async {
    return await GlobalHelper.getDataForController('${AppConstants.reviewedItemUri}?type=$type', '${AppConstants.REVIEWED_ITEM_LIST}_$type-$moduleID', sharedPreferences, apiClient,isModuleIdRquired: true);
  }

  // UPDATE
  Future updateReviewedItemList(String type, String moduleID) async {
    await GlobalHelper.updateDataForController('${AppConstants.reviewedItemUri}?type=$type', '${AppConstants.REVIEWED_ITEM_LIST}_$type-$moduleID', sharedPreferences, apiClient,isModuleIdRquired: true);
  }

  Future<Response> submitReview(ReviewBody reviewBody) async {
    return await apiClient.postData(AppConstants.reviewUri, reviewBody.toJson());
  }

  Future<Response> submitDeliveryManReview(ReviewBody reviewBody) async {
    return await apiClient.postData(AppConstants.deliveryManReviewUri, reviewBody.toJson());
  }

  // Future<Response> getItemDetails(int? itemID) async {
  //   return apiClient.getData('${AppConstants.itemDetailsUri}$itemID');
  // }

 // GET
  Future<Response> getItemDetails(int? itemID) async {
    return await GlobalHelper.getDataForController('${AppConstants.itemDetailsUri}$itemID', '${AppConstants.ITEM_DETAILS}_$itemID', sharedPreferences, apiClient);
  }

  // UPDATE
  Future updateItemDetails(int? itemID) async {
    await GlobalHelper.updateDataForController('${AppConstants.itemDetailsUri}$itemID', '${AppConstants.ITEM_DETAILS}_$itemID', sharedPreferences, apiClient);
  }
  
}
