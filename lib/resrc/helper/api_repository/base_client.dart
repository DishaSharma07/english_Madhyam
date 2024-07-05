import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../../../src/auth/login/login_page.dart';
import 'exceptions.dart';

var options = BaseOptions(
  connectTimeout: 50000,
  receiveTimeout: 50000,
);

class RestClient {
  late Dio dio;

  Future<RestClient> init() async {
    dio = Dio(options);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    initInterceptors();
    return this;
  }


  void initInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('REQUEST[${options.method}] => PATH: ${options.path} '
            '=> Request Values: ${options.queryParameters}, => HEADERS: ${options.headers}');
      }
      return handler.next(options);
    }, onResponse: (response, handler) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
      }
      return handler.next(response);
    }, onError: (err, handler) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('ERROR[${err.response?.statusCode}]');
      }
      return handler.next(err);
    }));
  }

  //get data
  getData({String? url, Map<String, dynamic>? headers}) async {
    if (url == null) {
      return;
    }
    try {
      dio.options.headers.addAll(headers ?? {});
      var response = await dio.get(url);
      return _processResponse(response);
    }

    catch (e) {
      print(e);
      rethrow;
    }
  }

  //post data
  postData(
      {String? url, dynamic payload, Map<String, dynamic>? headers}) async {
     print("payload-:$payload");
    if (url == null) {
      return;
    }
    try {
      if (headers != null) {
        dio.options.headers.addAll(headers);
      }
      var response = await dio.post(
        url,
        data: payload ?? {},
        options: Options(
            validateStatus: (_) => true,
            headers: headers
        )
      );
      return _processResponse(response);

    }

    catch (e) {
      print(e);
      rethrow;
    }
  }

  //put data
  putData(
      {String? url,
      Map<String, dynamic>? payload,
      Map<String, dynamic>? headers}) async {
    if (url == null) {
      return;
    }
    try {
      if (headers != null) {
        dio.options.headers.addAll(headers);
      }
      var response = await dio.put(
        url,
        data: payload,
      );
      return _processResponse(response);
    }

    catch (e) {
      print(e);
      rethrow;
    }
  }

  //post data
  deleteData(
      {String? url, dynamic payload, Map<String, dynamic>? headers}) async {
    if (url == null) {
      return;
    }
    try {
      if (headers != null) {
        dio.options.headers.addAll(headers);
      }
      var response = await dio.delete(
        url,
        data: payload ?? {},
      );

      return _processResponse(response);
    }

    catch (e) {
      print(e);
      rethrow;
    }
  }



  //post data
  downloadData(
      {dynamic filePath, dynamic savePath, Map<String, dynamic>? headers}) async {
    if (filePath == null) {
      return;
    }
    try {
      if (headers != null) {
        dio.options.headers.addAll(headers);
      }
      final response = await dio.download(
        filePath,
        savePath,
      );

      return _processResponse(response);
    }
    // on DioError catch (dioError) {
    //   throw _dioException(dioError);
    // }
    catch (e) {
      print(e);
      rethrow;
    }
  }

  _processResponse(response) {
    if (response == null) {
      return ClientException(message: "Something went wrong");
    }
    switch (response.statusCode) {
      case 200:
        var decodedJson = response.data;
        return decodedJson;
      case 400:
        var message = jsonDecode(response.toString())["message"];
        throw ClientException(message: message, response: response.data);
      case 401:
        var message = jsonDecode(response.toString())["message"];
        Get.offNamedUntil(LoginPage.routeName, (route) => false);
        throw ClientException(message: message, response: response.data);
      case 404:
        var message = jsonDecode(response.toString())["message"];
        throw ClientException(message: message, response: response.data);
      case 500:
        throw ServerException(message: "Something went wrong");
      case 504:
        throw ServerException(message: "Server went down");
      default:
        throw HttpException(
            statusCode: response.statusCode, message: "Somwthing went wrong");
    }
  }

  _dioException(DioError dioErr) {
    switch (dioErr.type) {
      case DioErrorType.response:
        throw _processResponse(dioErr.response);
      case DioErrorType.sendTimeout:
        throw HttpException(
            statusCode: dioErr.response?.statusCode,
            message: "Something went wrong");
      case DioErrorType.receiveTimeout:
        throw HttpException(
            statusCode: dioErr.response?.statusCode,
            message: "Something went wrong");
      default:
        throw HttpException(
            statusCode: dioErr.response?.statusCode,
            message: "Something went wrong");
    }
  }
}
