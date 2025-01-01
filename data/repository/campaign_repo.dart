import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/data/api/api_client.dart';
import 'package:sixam_mart/helper/global_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class CampaignRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  CampaignRepo({required this.apiClient,required this.sharedPreferences});

  // Future<Response> getBasicCampaignList() async {
  //   return await apiClient.getData(AppConstants.basicCampaignUri);
  // }
    Future<Response> getBasicCampaignList() async {
    return await GlobalHelper.getDataForController(AppConstants.basicCampaignUri, AppConstants.BASIC_CAMPAIGN_LIST, sharedPreferences, apiClient);
  }

  Future updateBasicCampaignList() async {
    await GlobalHelper.updateDataForController(AppConstants.basicCampaignUri, AppConstants.BASIC_CAMPAIGN_LIST, sharedPreferences, apiClient);
  }

  // Future<Response> getCampaignDetails(String campaignID) async {
  //   return await apiClient.getData('${AppConstants.basicCampaignDetailsUri}$campaignID');
  // }
  
  Future<Response> getCampaignDetails(String campaignID) async {
    return await GlobalHelper.getDataForController('${AppConstants.basicCampaignDetailsUri}$campaignID', '${AppConstants.CAMPAIGN_DETAILS}_$campaignID', sharedPreferences, apiClient);
  }

  Future updateCampaignDetails(String campaignID) async {
    await GlobalHelper.updateDataForController('${AppConstants.basicCampaignDetailsUri}$campaignID', '${AppConstants.CAMPAIGN_DETAILS}_$campaignID', sharedPreferences, apiClient);
  }

  // Future<Response> getItemCampaignList() async {
  //   return await apiClient.getData(AppConstants.itemCampaignUri);
  // }
   Future<Response> getItemCampaignList(String moduleID) async {
    return await GlobalHelper.getDataForController(AppConstants.itemCampaignUri, '${AppConstants.ITEM_CAMPAIGN_LIST}_$moduleID', sharedPreferences, apiClient,isModuleIdRquired: true);
  }

  Future updateItemCampaignList(String moduleID) async {
    await GlobalHelper.updateDataForController(AppConstants.itemCampaignUri, '${AppConstants.ITEM_CAMPAIGN_LIST}_$moduleID', sharedPreferences, apiClient,isModuleIdRquired: true);
  }

}