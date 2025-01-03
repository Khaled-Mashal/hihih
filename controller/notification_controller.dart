import 'package:sixam_mart/data/api/api_checker.dart';
import 'package:sixam_mart/data/model/response/notification_model.dart';
import 'package:sixam_mart/data/repository/notification_repo.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationRepo notificationRepo;
  NotificationController({required this.notificationRepo});

  List<NotificationModel>? _notificationList;
  bool _hasNotification = false;
  List<NotificationModel>? get notificationList => _notificationList;
  bool get hasNotification => _hasNotification;

  Future<int> getNotificationList(bool reload, {bool selfReload = false}) async {
    if(_notificationList == null || reload) {
      Response response = await notificationRepo.getNotificationList();
      if (response.statusCode == 200) {
        _notificationList = [];
        response.body.forEach((notification) => _notificationList!.add(NotificationModel.fromJson(notification)));
        _notificationList!.sort((a, b) {
          return DateConverter.isoStringToLocalDate(a.updatedAt!).compareTo(DateConverter.isoStringToLocalDate(b.updatedAt!));
        });
        Iterable iterable = _notificationList!.reversed;
        _notificationList = iterable.toList() as List<NotificationModel>?;
        _hasNotification = _notificationList!.length != getSeenNotificationCount();
      } else {
        ApiChecker.checkApi(response);
      }
      update();
      if (!selfReload) {
        await notificationRepo.updateNotificationList();
        await getNotificationList(reload, selfReload: true);
      }
    }
    return _notificationList!.length;
  }

  void saveSeenNotificationCount(int count) {
    notificationRepo.saveSeenNotificationCount(count);
  }

  int? getSeenNotificationCount() {
    return notificationRepo.getSeenNotificationCount();
  }

  void clearNotification() {
    _notificationList = null;
  }

}
