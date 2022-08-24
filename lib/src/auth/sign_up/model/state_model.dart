import 'package:flutter/material.dart';

class StateModel {
  String? result;
  String? message;
  List<StateList>? list;

  StateModel({this.result, this.message, this.list});

  StateModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['list'] != null) {
      list = <StateList>[];
      json['list'].forEach((v) {
        list!.add(new StateList.fromJson(v));
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

class StateList {
  int? id;
  String? name;
  String? createdAt;
  Null? updatedAt;

  StateList({this.id, this.name, this.createdAt, this.updatedAt});

  StateList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    //updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
