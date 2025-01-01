enum NotificationType {
  message,
  order,
  general,
}

class NotificationBody {
  NotificationType? notificationType;
  int? orderId;
  int? adminId;
  int? deliverymanId;
  int? restaurantId;
  String? type;
  int? conversationId;
  int? index;
  String? image;
  String? name;
  String? receiverType;
  String? senderType;
  String? sectionId;
  String? sectionName;
  String? sectionImage;
  String? isClinic;

  NotificationBody({
    this.notificationType,
    this.orderId,
    this.adminId,
    this.deliverymanId,
    this.restaurantId,
    this.type,
    this.conversationId,
    this.index,
    this.image,
    this.name,
    this.receiverType,
    this.senderType,
    this.sectionId,
    this.sectionName,
    this.sectionImage,
    this.isClinic,
  });

  NotificationBody.fromJson(Map<String, dynamic> json) {
    notificationType = convertToEnum(json['order_notification']);
    orderId = json['order_id'];
    adminId = json['admin_id'];
    deliverymanId = json['deliveryman_id'];
    restaurantId = json['restaurant_id'];
    type = json['type'];
    conversationId = json['conversation_id'];
    index = json['index'];
    image = json['image'];
    name = json['name'];
    receiverType = json['receiver_type'];
    senderType = json['sender_type'] ?? '';
    sectionId = json['section_id'];
    sectionName = json['section_name'];
    sectionImage = json['section_img'];
    isClinic = json['is_clinic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_notification'] = notificationType.toString();
    data['order_id'] = orderId;
    data['admin_id'] = adminId;
    data['deliveryman_id'] = deliverymanId;
    data['restaurant_id'] = restaurantId;
    data['type'] = type;
    data['conversation_id'] = conversationId;
    data['index'] = index;
    data['image'] = image;
    data['name'] = name;
    data['receiver_type'] = receiverType;
    data['sender_type'] = senderType;
    data['section_id'] = sectionId;
    data['section_name'] = sectionName;
    data['section_img'] = sectionImage;
    data['is_clinic'] = isClinic;
    return data;
  }

  NotificationType convertToEnum(String? enumString) {
    if (enumString == NotificationType.general.toString()) {
      return NotificationType.general;
    } else if (enumString == NotificationType.order.toString()) {
      return NotificationType.order;
    } else if (enumString == NotificationType.message.toString()) {
      return NotificationType.message;
    }
    return NotificationType.general;
  }
}
