import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/data/api/api_client.dart';
import 'package:sixam_mart/helper/global_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';

class ParcelRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  ParcelRepo({required this.apiClient,required this.sharedPreferences});

  // Future<Response> getParcelCategory() {
  //   return apiClient.getData(AppConstants.parcelCategoryUri);
  // }
  // GET
  Future<Response> getParcelCategory() async {
    return await GlobalHelper.getDataForController(AppConstants.parcelCategoryUri, AppConstants.PARCEL_CATEGORY_LIST, sharedPreferences, apiClient);
  }

  // UPDATE
  Future updateParcelCategory() async {
    await GlobalHelper.updateDataForController(AppConstants.parcelCategoryUri, AppConstants.PARCEL_CATEGORY_LIST, sharedPreferences, apiClient);
  }
  Future<Response> getPlaceDetails(String? placeID) async {
    return await apiClient.getData('${AppConstants.placeDetailsUri}?placeid=$placeID');
  }

}