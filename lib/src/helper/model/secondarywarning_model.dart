class SecondaryWarningModel {
  String? result;
  String? message;
  Results? results;

  SecondaryWarningModel({this.result, this.message, this.results});

  SecondaryWarningModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    results =
    json['results'] != null ? new Results.fromJson(json['results']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.results != null) {
      data['results'] = this.results!.toJson();
    }
    return data;
  }
}

class Results {
  String? id;
  String? packageId;
  String? text;
  String? isActive;
  String? status;
  String? createdAt;
  String? updatedAt;

  Results(
      {this.id,
        this.packageId,
        this.text,
        this.isActive,
        this.status,
        this.createdAt,
        this.updatedAt});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageId = json['package_id'];
    text = json['text'];
    isActive = json['is_active'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['package_id'] = this.packageId;
    data['text'] = this.text;
    data['is_active'] = this.isActive;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}