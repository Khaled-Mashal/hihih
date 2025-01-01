import 'package:sixam_mart/data/api/api_client.dart';
import 'package:sixam_mart/helper/global_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  NotificationRepo({required this.apiClient, required this.sharedPreferences});

  // Future<Response> getNotificationList() async {
  //   return await apiClient.getData(AppConstants.notificationUri);
  // }
  // GET
  Future<Response> getNotificationList() async {
    return await GlobalHelper.getDataForController(AppConstants.notificationUri, AppConstants.NOTIFICATION_LIST, sharedPreferences, apiClient);
  }

  // UPDATE
  Future updateNotificationList() async {
    await GlobalHelper.updateDataForController(AppConstants.notificationUri, AppConstants.NOTIFICATION_LIST, sharedPreferences, apiClient);
  }

  void saveSeenNotificationCount(int count) {
    sharedPreferences.setInt(AppConstants.notificationCount, count);
  }

  int? getSeenNotificationCount() {
    return sharedPreferences.getInt(AppConstants.notificationCount);
  }

}
