import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/data/api/api_client.dart';
import 'package:sixam_mart/helper/global_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class WishListRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  WishListRepo({required this.apiClient,required this.sharedPreferences});

  // Future<Response> getWishList() async {
  //   return await apiClient.getData(AppConstants.wishListGetUri);
  // }
  // GET
  Future<Response> getWishList() async {
    return await GlobalHelper.getDataForController(AppConstants.wishListGetUri, AppConstants.WISH_LIST_LIST, sharedPreferences, apiClient);
  }

  // UPDATE
  Future updateWishList() async {
    await GlobalHelper.updateDataForController(AppConstants.wishListGetUri, AppConstants.WISH_LIST_LIST, sharedPreferences, apiClient);
  }
  Future<Response> addWishList(int? id, bool isStore) async {
    return await apiClient.postData('${AppConstants.addWishListUri}${isStore ? 'store_id=' : 'item_id='}$id', null);
  }

  Future<Response> removeWishList(int? id, bool isStore) async {
    return await apiClient.deleteData('${AppConstants.removeWishListUri}${isStore ? 'store_id=' : 'item_id='}$id');
  }
}
