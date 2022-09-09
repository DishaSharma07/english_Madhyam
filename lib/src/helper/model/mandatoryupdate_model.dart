class MandatoryUpdate {
  String? result;
  String? message;
  Version? version;

  MandatoryUpdate({this.result, this.message, this.version});

  MandatoryUpdate.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    version =
    json['version'] != null ? new Version.fromJson(json['version']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.version != null) {
      data['version'] = this.version!.toJson();
    }
    return data;
  }
}

class Version {
  int? id;
  int? androidCur;
  int? androidMan;
  int? iosCur;
  int? iosMan;
  Null? createdAt;
  Null? updatedAt;

  Version(
      {this.id,
        this.androidCur,
        this.androidMan,
        this.iosCur,
        this.iosMan,
        this.createdAt,
        this.updatedAt});

  Version.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    androidCur = json['android_cur'];
    androidMan = json['android_man'];
    iosCur = json['ios_cur'];
    iosMan = json['ios_man'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['android_cur'] = this.androidCur;
    data['android_man'] = this.androidMan;
    data['ios_cur'] = this.iosCur;
    data['ios_man'] = this.iosMan;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}