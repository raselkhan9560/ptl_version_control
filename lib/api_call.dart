import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

enum Method { POST, GET, DELETE, PATCH }

class VersionController {
  ///----------- initialize dio
  Dio _dio = Dio();

  //this is for header
  static header() => {
        'Content-Type': 'application/json',
      };
// '/api/mobile-app/auth/public/version'
// https://api.medboxbd.com
  void initInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      print('REQUEST[${options.method}] => PATH: ${options.path} '
          '=> Request Values: ${options.queryParameters}, => HEADERS: ${options.headers}');
      return handler.next(options);
    }, onResponse: (response, handler) {
      print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
      return handler.next(response);
    }, onError: (err, handler) {
      print('ERROR[${err.response?.statusCode}]');
      return handler.next(err);
    }));
  }

  VersionController({
    required String baseUrl,
  }) {
    _dio.options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 90000,
        receiveTimeout: 90000,
        headers: header());
    initInterceptors();
  }

  Future<Map<String, dynamic>> request(
      String url, Method method, Map<String, dynamic>? params) async {
    Response response;

    try {
      if (method == Method.POST) {
        response = await _dio.post(url, data: params);
      } else if (method == Method.DELETE) {
        response = await _dio.delete(url);
      } else if (method == Method.PATCH) {
        response = await _dio.patch(url);
      } else {
        response = await _dio.get(
          url,
          queryParameters: params,
        );
      }
      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized");
      } else if (response.statusCode == 500) {
        throw Exception("Server Error");
      } else {
        throw Exception("Something Went Wrong");
      }
    } on SocketException catch (e) {
      throw Exception("No Internet Connection -> $e");
    } on FormatException {
      throw Exception("Bad Response Format!");
    } on DioError catch (e) {
      throw Exception(e);
    } catch (e) {
      print("error $e");
      throw Exception("Something Went Wrong");
    }
  }
}
