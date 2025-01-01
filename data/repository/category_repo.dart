import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/controller/localization_controller.dart';
import 'package:sixam_mart/data/api/api_client.dart';
import 'package:sixam_mart/helper/global_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';

class CategoryRepo {
  final ApiClient apiClient;
    final SharedPreferences sharedPreferences;
  CategoryRepo({required this.apiClient,required this.sharedPreferences});

  // Future<Response> getCategoryList(bool allCategory) async {
  //   return await apiClient.getData(AppConstants.categoryUri, headers: allCategory ? {
  //     'Content-Type': 'application/json; charset=UTF-8',
  //     AppConstants.localizationKey: Get.find<LocalizationController>().locale.languageCode
  //   } : null);
  // }

 // GET
  Future<Response> getCategoryList(bool allCategory, String moduleID) async {
    return await GlobalHelper.getDataForController(AppConstants.categoryUri, '${AppConstants.CATEGORY_LIST}_$moduleID', sharedPreferences, apiClient,
        headers: allCategory
            ? {'Content-Type': 'application/json; charset=UTF-8', AppConstants.localizationKey: Get.find<LocalizationController>().locale.languageCode }
            : null,isModuleIdRquired: !allCategory);
  }

  // UPDATE
  Future updateCategoryList(bool allCategory, String moduleID) async {
    await GlobalHelper.updateDataForController(AppConstants.categoryUri, '${AppConstants.CATEGORY_LIST}_$moduleID', sharedPreferences, apiClient,
        headers: allCategory
            ? {'Content-Type': 'application/json; charset=UTF-8', AppConstants.localizationKey: Get.find<LocalizationController>().locale.languageCode }
            : null,isModuleIdRquired: !allCategory);
  }

  
  // Future<Response> getSubCategoryList(String? parentID) async {
  //   return await apiClient.getData('${AppConstants.subCategoryUri}$parentID');
  // }
   // GET
  Future<Response> getSubCategoryList(String? parentID) async {
    return await GlobalHelper.getDataForController('${AppConstants.subCategoryUri}$parentID', '${AppConstants.SUB_CATEGORY_LIST}_$parentID', sharedPreferences, apiClient);
  }

  // UPDATE
  Future updateSubCategoryList(String? parentID) async {
    await GlobalHelper.updateDataForController('${AppConstants.subCategoryUri}$parentID', '${AppConstants.SUB_CATEGORY_LIST}_$parentID', sharedPreferences, apiClient);
  }


  // Future<Response> getCategoryItemList(String? categoryID, int offset, String type) async {
  //   return await apiClient.getData('${AppConstants.categoryItemUri}$categoryID?limit=10&offset=$offset&type=$type');
  // }

  // GET
  Future<Response> getCategoryItemList(String? categoryID, int offset, String type) async {
    return await GlobalHelper.getDataForController(
        '${AppConstants.categoryItemUri}$categoryID?limit=10&offset=$offset&type=$type', '${AppConstants.CATEGORY_ITEM_LIST}_$categoryID-$offset-$type', sharedPreferences, apiClient);
  }

  // UPDATE
  Future updateCategoryItemList(String? categoryID, int offset, String type) async {
    await GlobalHelper.updateDataForController(
        '${AppConstants.categoryItemUri}$categoryID?limit=10&offset=$offset&type=$type', '${AppConstants.CATEGORY_ITEM_LIST}_$categoryID-$offset-$type', sharedPreferences, apiClient);
  }

  // Future<Response> getCategoryStoreList(String? categoryID, int offset, String type) async {
  //   return await apiClient.getData('${AppConstants.categoryStoreUri}$categoryID?limit=10&offset=$offset&type=$type');
  // }
   // GET
  Future<Response> getCategoryStoreList(String? categoryID, int offset, String type) async {
    return await GlobalHelper.getDataForController(
        '${AppConstants.categoryStoreUri}$categoryID?limit=10&offset=$offset&type=$type', '${AppConstants.CATEGORY_STORE_LIST}_$categoryID-$offset-$type', sharedPreferences, apiClient);
  }

  // UPDATE
  Future updateCategoryStoreList(String? categoryID, int offset, String type) async {
    await GlobalHelper.updateDataForController(
        '${AppConstants.categoryStoreUri}$categoryID?limit=10&offset=$offset&type=$type', '${AppConstants.CATEGORY_STORE_LIST}_$categoryID-$offset-$type', sharedPreferences, apiClient);
  }

  Future<Response> getSearchData(String? query, String? categoryID, bool isStore, String type) async {
    return await apiClient.getData(
      '${AppConstants.searchUri}${isStore ? 'stores' : 'items'}/search?name=$query&category_id=$categoryID&type=$type&offset=1&limit=50',
    );
  }

  Future<Response> saveUserInterests(List<int?> interests) async {
    return await apiClient.postData(AppConstants.interestUri, {"interest": interests});
  }

}