import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/controller/localization_controller.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/api/api_client.dart';
import 'package:sixam_mart/data/model/response/address_model.dart';
import 'package:sixam_mart/helper/global_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';

class StoreRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  StoreRepo({required this.sharedPreferences, required this.apiClient});

  // Future<Response> getStoreList(int offset, String filterBy) async {
  //   return await apiClient.getData('${AppConstants.storeUri}/$filterBy?offset=$offset&limit=12');
  // }
  // GET
  Future<Response> getStoreList(int offset, String filterBy, String moduleID,
      String lat, String long) async {
    return await GlobalHelper.getDataForController(
        '${AppConstants.storeUri}/$filterBy?offset=$offset&limit=12&lat=$lat&long=$long',
        '${AppConstants.STORE_LIST}_${filterBy}_${offset}_$moduleID',
        sharedPreferences,
        apiClient,
        isModuleIdRquired: true);
  }

  // UPDATE
  Future updateStoreList(int offset, String filterBy, String moduleID,
      String lat, String long) async {
    await GlobalHelper.updateDataForController(
        '${AppConstants.storeUri}/$filterBy?offset=$offset&limit=12&lat=$lat&long=$long',
        '${AppConstants.STORE_LIST}_${filterBy}_${offset}_$moduleID',
        sharedPreferences,
        apiClient,
        isModuleIdRquired: true);
  }

  // Future<Response> getPopularStoreList(String type) async {
  //   return await apiClient.getData('${AppConstants.popularStoreUri}?type=$type');
  // }
  // GET
  Future<Response> getPopularStoreList(
      String type, String moduleID, String lat, String long) async {
    return await GlobalHelper.getDataForController(
        '${AppConstants.popularStoreUri}?type=$type&lat=$lat&long=$long',
        '${AppConstants.POPULAR_STORE_LIST}_$type-$moduleID',
        sharedPreferences,
        apiClient,
        isModuleIdRquired: true);
  }

  // UPDATE
  Future updatePopularStoreList(String type, String moduleID) async {
    await GlobalHelper.updateDataForController(
        '${AppConstants.popularStoreUri}?type=$type',
        '${AppConstants.POPULAR_STORE_LIST}_$type-$moduleID',
        sharedPreferences,
        apiClient,
        isModuleIdRquired: true);
  }

  // Future<Response> getLatestStoreList(String type) async {
  //   return await apiClient.getData('${AppConstants.latestStoreUri}?type=$type');
  // }

  // GET
  Future<Response> getLatestStoreList(
      String type, String moduleID, String lat, String long) async {
    return await GlobalHelper.getDataForController(
        '${AppConstants.latestStoreUri}?type=$type&lat=$lat&long=$long',
        '${AppConstants.LATEST_STORE_LIST}_$type-$moduleID',
        sharedPreferences,
        apiClient,
        isModuleIdRquired: true);
  }

  // UPDATE
  Future updateLatestStoreList(String type, String moduleID) async {
    await GlobalHelper.updateDataForController(
        '${AppConstants.latestStoreUri}?type=$type',
        '${AppConstants.LATEST_STORE_LIST}_$type-$moduleID',
        sharedPreferences,
        apiClient,
        isModuleIdRquired: true);
  }

  // Future<Response> getFeaturedStoreList() async {
  //   return await apiClient.getData('${AppConstants.storeUri}/all?featured=1&offset=1&limit=50');
  // }
  // GET
  Future<Response> getFeaturedStoreList(String lat, String long) async {
    return await GlobalHelper.getDataForController(
        '${AppConstants.storeUri}/all?featured=1&offset=1&limit=50&lat=$lat&long=$long',
        AppConstants.FEATURED_STORE_LIST,
        sharedPreferences,
        apiClient);
  }

  // UPDATE
  Future updateFeaturedStoreList() async {
    await GlobalHelper.updateDataForController(
        '${AppConstants.storeUri}/all?featured=1&offset=1&limit=50',
        AppConstants.FEATURED_STORE_LIST,
        sharedPreferences,
        apiClient);
  }

  // Future<Response> getStoreDetails(String storeID, bool fromCart, String slug) async {
  //   Map<String, String>? header ;
  //   if(fromCart){
  //     AddressModel? addressModel = Get.find<LocationController>().getUserAddress();
  //     header = apiClient.updateHeader(
  //       sharedPreferences.getString(AppConstants.token), addressModel?.zoneIds, addressModel?.areaIds,
  //       Get.find<LocalizationController>().locale.languageCode,
  //       Get.find<SplashController>().module == null ? Get.find<SplashController>().cacheModule!.id : Get.find<SplashController>().module!.id,
  //       addressModel?.latitude, addressModel?.longitude, setHeader: false,
  //     );
  //   }
  //   if(slug.isNotEmpty){
  //     header = apiClient.updateHeader(
  //       sharedPreferences.getString(AppConstants.token), [], [],
  //       Get.find<LocalizationController>().locale.languageCode,
  //       0, '', '', setHeader: false,
  //     );
  //   }
  //   return await apiClient.getData('${AppConstants.storeDetailsUri}${slug.isNotEmpty ? slug : storeID}', headers: header);
  // }
  // GET
  Future<Response> getStoreDetails(
      String storeID, bool fromCart, String slug) async {
    Map<String, String>? header;
    if (fromCart) {
      AddressModel? addressModel =
          Get.find<LocationController>().getUserAddress();
      header = apiClient.updateHeader(
        sharedPreferences.getString(AppConstants.token),
        addressModel?.zoneIds,
        addressModel?.areaIds,
        Get.find<LocalizationController>().locale.languageCode,
        Get.find<SplashController>().module == null
            ? Get.find<SplashController>().cacheModule!.id
            : Get.find<SplashController>().module!.id,
        addressModel?.latitude,
        addressModel?.longitude,
        setHeader: false,
      );
    }
    if (slug.isNotEmpty) {
      header = apiClient.updateHeader(
        sharedPreferences.getString(AppConstants.token),
        [],
        [],
        Get.find<LocalizationController>().locale.languageCode,
        0,
        '',
        '',
        setHeader: false,
      );
    }
    return await GlobalHelper.getDataForController(
        '${AppConstants.storeDetailsUri}${slug.isNotEmpty ? slug : storeID}',
        '${AppConstants.STORE_DETAILS}_$storeID',
        sharedPreferences,
        apiClient);
  }

  // UPDATE
  Future updateStoreDetails(String storeID, bool fromCart, String slug) async {
    Map<String, String>? header;
    if (fromCart) {
      AddressModel? addressModel =
          Get.find<LocationController>().getUserAddress();
      header = apiClient.updateHeader(
        sharedPreferences.getString(AppConstants.token),
        addressModel?.zoneIds,
        addressModel?.areaIds,
        Get.find<LocalizationController>().locale.languageCode,
        Get.find<SplashController>().module == null
            ? Get.find<SplashController>().cacheModule!.id
            : Get.find<SplashController>().module!.id,
        addressModel?.latitude,
        addressModel?.longitude,
        setHeader: false,
      );
    }
    if (slug.isNotEmpty) {
      header = apiClient.updateHeader(
        sharedPreferences.getString(AppConstants.token),
        [],
        [],
        Get.find<LocalizationController>().locale.languageCode,
        0,
        '',
        '',
        setHeader: false,
      );
    }
    await GlobalHelper.updateDataForController(
        '${AppConstants.storeDetailsUri}${slug.isNotEmpty ? slug : storeID}',
        '${AppConstants.STORE_DETAILS}_$storeID',
        sharedPreferences,
        apiClient);
  }

  // Future<Response> getStoreItemList(int? storeID, int offset, int? categoryID, String type) async {
  //   return await apiClient.getData(
  //     '${AppConstants.storeItemUri}?store_id=$storeID&category_id=$categoryID&offset=$offset&limit=13&type=$type',
  //   );
  // }
  // GET
  Future<Response> getStoreItemList(
      int? storeID, int offset, int? categoryID, String type) async {
    return await GlobalHelper.getDataForController(
        '${AppConstants.storeItemUri}?store_id=$storeID&category_id=$categoryID&offset=$offset&limit=10&type=$type',
        '${AppConstants.STORE_ITEM_LIST}_$storeID-$offset-$categoryID-$type',
        sharedPreferences,
        apiClient);
  }

  // UPDATE
  Future updateStoreItemList(
      int? storeID, int offset, int? categoryID, String type) async {
    await GlobalHelper.updateDataForController(
        '${AppConstants.storeItemUri}?store_id=$storeID&category_id=$categoryID&offset=$offset&limit=10&type=$type',
        '${AppConstants.STORE_ITEM_LIST}_$storeID-$offset-$categoryID-$type',
        sharedPreferences,
        apiClient);
  }

  Future<Response> getStoreSearchItemList(String searchText, String? storeID,
      int offset, String type, int? categoryID) async {
    return await apiClient.getData(
      '${AppConstants.searchUri}items/search?store_id=$storeID&name=$searchText&offset=$offset&limit=10&type=$type&category_id=${categoryID ?? ''}',
    );
  }

  Future<Response> getStoreReviewList(String? storeID) async {
    return await apiClient
        .getData('${AppConstants.storeReviewUri}?store_id=$storeID');
  }

  // Future<Response> getStoreRecommendedItemList(int? storeId) async {
  //   return await apiClient.getData('${AppConstants.storeRecommendedItemUri}?store_id=$storeId&offset=1&limit=50');
  // }
  Future<Response> getStoreRecommendedItemList(int? storeId) async {
    return await GlobalHelper.getDataForController(
        '${AppConstants.storeRecommendedItemUri}?store_id=$storeId&offset=1&limit=50',
        '${AppConstants.STORE_RECOMMENDED_ITEMURI}_$storeId',
        sharedPreferences,
        apiClient);
  }

  Future updateStoreRecommendedItemList(int? storeId) async {
    await GlobalHelper.updateDataForController(
        '${AppConstants.storeRecommendedItemUri}?store_id=$storeId&offset=1&limit=50',
        '${AppConstants.STORE_RECOMMENDED_ITEMURI}_$storeId',
        sharedPreferences,
        apiClient);
  }

  Future<Response> getCartStoreSuggestedItemList2(
      int? storeId, int? categoryId) async {
    AddressModel? addressModel =
        Get.find<LocationController>().getUserAddress();
    Map<String, String> header = apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token),
      addressModel?.zoneIds,
      addressModel?.areaIds,
      Get.find<LocalizationController>().locale.languageCode,
      Get.find<SplashController>().module == null
          ? Get.find<SplashController>().cacheModule!.id
          : Get.find<SplashController>().module!.id,
      addressModel?.latitude,
      addressModel?.longitude,
      setHeader: false,
    );
    return await apiClient.getData(
        '${AppConstants.cartStoreSuggestedItemsUri2}?recommended=1&store_id=$storeId&category_id=$categoryId&offset=1&limit=50',
        headers: header);
  }

  Future<Response> getCartStoreSuggestedItemList(int? storeId) async {
    AddressModel? addressModel =
        Get.find<LocationController>().getUserAddress();
    Map<String, String> header = apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token),
      addressModel?.zoneIds,
      addressModel?.areaIds,
      Get.find<LocalizationController>().locale.languageCode,
      Get.find<SplashController>().module == null
          ? Get.find<SplashController>().cacheModule!.id
          : Get.find<SplashController>().module!.id,
      addressModel?.latitude,
      addressModel?.longitude,
      setHeader: false,
    );
    return await apiClient.getData(
        '${AppConstants.cartStoreSuggestedItemsUri}?recommended=1&store_id=$storeId&offset=1&limit=50',
        headers: header);
  }
}
