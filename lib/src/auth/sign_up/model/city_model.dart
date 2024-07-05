class CityModel {
  String? result;
  String? message;
  List<CityList>? list;

  CityModel({this.result, this.message, this.list});

  CityModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['list'] != null) {
      list = <CityList>[];
      json['list'].forEach((v) {
        list!.add(new CityList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CityList {
  int? id;
  int? stateID;
  String? name;
  String? createdAt;
  Null? updatedAt;

  CityList({this.id, this.stateID, this.name, this.createdAt, this.updatedAt});

  CityList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stateID = json['stateID'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['stateID'] = this.stateID;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
