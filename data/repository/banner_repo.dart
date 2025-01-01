import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/data/api/api_client.dart';
import 'package:sixam_mart/helper/global_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
class BannerRepo {
  final ApiClient apiClient;
    final SharedPreferences sharedPreferences;
  BannerRepo({required this.apiClient,required this.sharedPreferences});

  // Future<Response> getBannerList() async {
  //   return await apiClient.getData(AppConstants.bannerUri);
  // }
  
  Future<Response> getBannerList(String moduleID) async {
    return await GlobalHelper.getDataForController(AppConstants.bannerUri, '${AppConstants.BANNER_LIST}_$moduleID', sharedPreferences, apiClient,isModuleIdRquired: true);
  }

  Future updateBannerList(String moduleID) async {
    await GlobalHelper.updateDataForController(AppConstants.bannerUri, '${AppConstants.BANNER_LIST}_$moduleID', sharedPreferences, apiClient,isModuleIdRquired: true);
  }

  Future<Response> getTaxiBannerList() async {
    return await apiClient.getData(AppConstants.taxiBannerUri);
  }

  // Future<Response> getFeaturedBannerList() async {
  //   return await apiClient.getData('${AppConstants.bannerUri}?featured=1');
  // }
  Future<Response> getFeaturedBannerList() async {
    return await GlobalHelper.getDataForController('${AppConstants.bannerUri}?featured=1', AppConstants.FEATURED_BANNER_LIST, sharedPreferences, apiClient);
  }

  Future updateFeaturedBannerList() async {
    await GlobalHelper.updateDataForController('${AppConstants.bannerUri}?featured=1', AppConstants.FEATURED_BANNER_LIST, sharedPreferences, apiClient);
  }

}