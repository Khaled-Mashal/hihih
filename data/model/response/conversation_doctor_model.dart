class ConversationsDoctorModel {
   List<ConversationDoctor?>? conversations;
  ConversationsDoctorModel.fromJson(Map<String, dynamic> json) {
  
  if (json['data'] != null) {
      conversations = <ConversationDoctor?>[];
      json['data'].forEach((v) {
        conversations!.add(ConversationDoctor.fromJson(v));
      });
    }
  }
}

class ConversationDoctor {
  int? id;
  String? name;
  String? description;
  String? logo;
  int? status;
  String? key;
  String? keyId;
  String? createdAt;
  String? updatedAt;

  ConversationDoctor(
      {this.id,
      this.name,
      this.description,
      this.logo,
      this.status,
      this.key,
      this.keyId,
      this.createdAt,
      this.updatedAt});

  ConversationDoctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    logo = json['logo'];
    status = json['status'];
    key = json['key'];
    keyId = json['key_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['logo'] = this.logo;
    data['status'] = this.status;
    data['key'] = this.key;
    data['key_id'] = this.keyId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
