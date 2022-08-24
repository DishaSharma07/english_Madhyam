class NotificationModel {
  bool? result;
  String? message;
  List<Notifications>? notification;

  NotificationModel({this.result, this.message, this.notification});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['notification'] != null) {
      notification = <Notifications>[];
      json['notification'].forEach((v) {
        notification!.add(new Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.notification != null) {
      data['notification'] = this.notification!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  int? id;
  String? title;
  String? image;
  String? text;
  String? created_at;
  int? userID;
  int?read;

  Notifications({this.id, this.title, this.image, this.text,this.created_at, this.userID,this.read});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    created_at = json['created_at'];
    image = json['image'];
    text = json['text'];
    userID = json['userID'];
    read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['created_at'] = this.created_at;
    data['image'] = this.image;
    data['read'] = this.read;
    data['text'] = this.text;
    data['userID'] = this.userID;
    return data;
  }
}