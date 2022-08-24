import 'package:flutter/material.dart';

class SendOTP {
  String? result;
  String? message;
  String? status;

  SendOTP({this.result, this.message, this.status});

  SendOTP.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
