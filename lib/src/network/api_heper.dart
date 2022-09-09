import 'dart:convert';
import 'dart:io';
import 'package:english_madhyam/src/auth/login/login_page.dart';

import 'package:english_madhyam/src/network/NetworkException.dart';
import 'package:english_madhyam/src/utils/setup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class ApiBaseHelper {
  _authFailure() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', "");
Get.offUntil(MaterialPageRoute(builder: (ctx)=>LoginPage()), (route) => true) ; }

  Future<dynamic> get(String url) async {
    if (kDebugMode) {
    }
    var responseJson;
    try {
      final response = await http.get(Uri.parse(aPPmAINuRL + url));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw NetworkException("No Internet Conneted");
    }
    return responseJson;
  }

  Future<dynamic> getThirdParty(String url) async {
    if (kDebugMode) {
    }
    var responseJson;
    try {
      final response = await http.get(Uri.parse(url));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw NetworkException("No Internet Conneted");
    }
    return responseJson;
  }

  Future<dynamic> post(String url, Map reqBody) async {
    if (kDebugMode) {

    }
    var responseJson;

    try {
      final response = await http.post(Uri.parse(aPPmAINuRL + url),
          body: jsonEncode(reqBody),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      responseJson = _returnResponse(response);
    } on SocketException {
      throw NetworkException("No Internet Conneted");
    }
    return responseJson;
  }
  Future<dynamic> secondaryPost(String url, Map reqBody) async {
    if (kDebugMode) {

    }
    var responseJson;

    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode(reqBody),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      responseJson = _returnResponse(response);
    } on SocketException {
      throw NetworkException("No Internet Conneted");
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    if (kDebugMode) {

    }
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        return responseJson;
      case 400:
        var responseJson = json.decode(response.body);
        return responseJson;
      case 401:
        _authFailure();
        return null;
      default:
        return null;
    }
  }
}
