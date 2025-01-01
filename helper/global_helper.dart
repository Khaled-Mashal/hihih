import 'dart:convert';

import 'package:get/get_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/data/api/api_client.dart';
import 'package:sixam_mart/data/model/response/api_response_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';

class GlobalHelper {
  static ApiResponseModel responseToModel(Response response) {
    ApiResponseModel _responseModel = ApiResponseModel();
    _responseModel.body = response.body;
    _responseModel.statusCode = response.statusCode.toString();
    _responseModel.statusText = response.statusText;
    return _responseModel;
  }

static  List<Store?> makeListUniqueStore(List<Store?>? currentList) {
  if (currentList == null ||currentList.isEmpty ) return [];

  Set<int> uniqueIds = {};
  List<Store?>? uniqueList = [];

  for (Store? store in currentList) {
    if(store!=null){
        if (!uniqueIds.contains(store.id)) {
          uniqueIds.add(store.id!);
          uniqueList.add(store);
        }
     }
    
  }

  return uniqueList;
}
static  List<Item?> makeListUnique(List<Item?>? currentList) {
  if (currentList == null ||currentList.isEmpty ) return [];

  Set<int> uniqueIds = {};
  List<Item?>? uniqueList = [];

  for (Item? item in currentList) {
    if(item!=null){
        if (!uniqueIds.contains(item.id)) {
          uniqueIds.add(item.id!);
          uniqueList.add(item);
        }
     }
    
  }

  return uniqueList;
}
  static Response modelToResponse(ApiResponseModel apiResponseModel) {
    Response response = Response(body: apiResponseModel.body, statusCode: int.parse(apiResponseModel.statusCode!), statusText: apiResponseModel.statusText);
    return response;
  }


  static Future<Response> getDataForController(String url, String sharedKey, SharedPreferences sharedPreferences, ApiClient apiClient, {Map<String, String>? headers,bool isModuleIdRquired=false}) async {
    Response response = Response();
    ApiResponseModel _responseModel;
    if (sharedPreferences.containsKey(sharedKey)) {
      _responseModel = ApiResponseModel.fromJson(await jsonDecode(sharedPreferences.getString(sharedKey)??''));
      response = modelToResponse(_responseModel);
        // print("Looog::${url} Cash ${response.body}");
    } else {
      response = await apiClient.getData(url, headers: headers,isModuleIdRquired: isModuleIdRquired);
    if (response.statusCode == 200) {
      _responseModel = responseToModel(response);
      sharedPreferences.setString(sharedKey, jsonEncode(_responseModel.toJson()));
      }
      // print("Looog::${url} Live ${response.body}");
    }
  
    return response;
  }

  static Future updateDataForController(String url, String sharedKey, SharedPreferences sharedPreferences, ApiClient apiClient, {Map<String, String>? headers ,bool isModuleIdRquired=false}) async {
    ApiResponseModel _responseModel = ApiResponseModel();
    Response response = await apiClient.getData(url, headers: headers,isModuleIdRquired: isModuleIdRquired);
    if (response.statusCode == 200) {
      sharedPreferences.remove(sharedKey);
      _responseModel = responseToModel(response);
      sharedPreferences.setString(sharedKey, jsonEncode(_responseModel.toJson()));
      //  print("Looog::${url} Update Live ${response.body}");
    }
  }
}
