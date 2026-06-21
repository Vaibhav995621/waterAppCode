import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'dio_client.dart';

class ApiProvider {
  late final DioClient _client;

  ApiProvider({required String baseUrl}) {
    _client = DioClient(baseUrl: baseUrl);
  }

  Future<dynamic> post(
      String path,
      dynamic data, {
        bool tokenRequired = true,
        Map<String, dynamic>? headers,
      }) async {
    debugPrint("Api request: $data");
    debugPrint("Api url: ${_client.dio.options.baseUrl}$path");

    final response = await _client.dio.post(
      path,
      data: data,
      options: Options(
        headers: headers,
      ),
    );

    return response.data;
  }

  Future<dynamic> get(String path, {bool tokenRequired = true}) async {
    final response = await _client.dio.get(path);
    debugPrint("response: $response");

    return response.data;
  }

  Future<dynamic> update(
    String path,
    dynamic data, {
    bool tokenRequired = true,
  }) async {
    final response = await _client.dio.put(path, data: data);
    return response.data;
  }

  Future<dynamic> delete(
    String path, {
    dynamic data,
    bool tokenRequired = true,
  }) async {
    final response = await _client.dio.delete(path, data: data);
    return response.data;
  }


  Future<dynamic> uploadMultipart(
      String path, {
        Map<String, dynamic>? data,
        List<File>? images,
        String imageKey = "photo",
        Map<String, dynamic>? headers,
      }) async {
    FormData formData = FormData();

    /// normal fields
    if (data != null) {
      data.forEach((key, value) {
        formData.fields.add(
          MapEntry(key, value.toString()),
        );
      });
    }

    /// multiple images
    if (images != null && images.isNotEmpty) {
      for (File file in images) {
        formData.files.add(
          MapEntry(
            imageKey,
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }
    }

    debugPrint(
      "Multipart URL: ${_client.dio.options.baseUrl}$path",
    );

    final response = await _client.dio.post(
      path,
      data: formData,
      options: Options(
        headers: {
          "Content-Type": "multipart/form-data",
          ...?headers,
        },
      ),
    );

    return response.data;
  }
}
