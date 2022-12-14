import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart' as dio;

import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config/config.dart';
import '../entity/user.dart';
import '../pages/dashboard/dashboard_controller.dart';
import '../util/enums.dart';
import 'auth_service.dart';
import 'package:http_parser/http_parser.dart';



abstract class BaseApiService extends GetxService {
  final Configuration configuration = Get.find();

  String _baseUrl = '';

  Uri _getParsedUri(String url) {
    _baseUrl = configuration.getApiUrl();
    return Uri.parse(_baseUrl + url);
  }

  @protected
  Future<http.Response> get(String url) async {
    await _refreshTokenIfNeeded();
    var user = User();
    Map<String, String> finalHeaders = <String, String>{};
    finalHeaders['Authorization'] =
        '${user.token.target!.tokenType} ${User().token.target!.token}';
    finalHeaders['content-type'] = "application/json; charset=UTF-8";
    return http.get(_getParsedUri(url), headers: finalHeaders).onError(
        (error, stackTrace) => Future.value(http.Response("Error", 500)));
  }

  @protected
  Future<http.Response> patch(String url, Object body) async {
    await _refreshTokenIfNeeded();
    var user = User();
    Map<String, String> finalHeaders = <String, String>{};
    finalHeaders['Authorization'] =
    '${user.token.target!.tokenType} ${User().token.target!.token}';
    finalHeaders['Content-Type'] = "application/json";
    return http
        .patch(_getParsedUri(url),body: json.encode(body), headers: finalHeaders)
        .onError(
            (error, stackTrace) => Future.value(http.Response("Error", 500)));
  }

  @protected
  Future<http.Response> getWithHeaders(
      String url, Map<String, String> headers) async {
    await _refreshTokenIfNeeded();
    return http
        .get(_getParsedUri(url), headers: getCompleteHeaders(headers))
        .timeout(Duration(seconds: configuration.getRequestTimeout()))
        .onError(
            (error, stackTrace) => Future.value(http.Response("Error", 500)));
  }

  @protected
  Future<http.Response> post(String url, Object body) async {
    await _refreshTokenIfNeeded();
    return http
        .post(_getParsedUri(url),
            headers: getCompleteHeaders(), body: json.encode(body))
        .onError(
            (error, stackTrace) => Future.value(http.Response("Error", 500)));
  }

  @protected
  Future<http.StreamedResponse> patchWithFile(String url, File file) async {
    await _refreshTokenIfNeeded();
    var user = User();
    var request = http.MultipartRequest(
        "PATCH", _getParsedUri(url));
    request.files.add(await http.MultipartFile.fromPath('file', file.path,
        contentType: MediaType('image', 'jpg')));
    request.headers['Authorization'] =
    '${user.token.target!.tokenType} ${User().token.target!.token}';

    return request.send();
  }

  @protected
  Future<http.Response> postWithHeaders(
      String url, Map<String, String> headers, Object body) async {
    await _refreshTokenIfNeeded();
    return http
        .post(_getParsedUri(url),
            headers: getCompleteHeaders(headers), body: json.encode(body))
        .timeout(Duration(seconds: configuration.getRequestTimeout()))
        .onError(
            (error, stackTrace) => Future.value(http.Response("Error", 500)));
  }

  @protected
  Future postForPersonalLearnocity(String url, Map<String, String> body,
      {Map<String, String>? header}) async {
    var headers = {
      "authority": "items.learnosity.com",
      "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
      "accept": "*/*",
      "origin": "https://items.learnosity.com",
      "sec-fetch-site": "same-origin",
      "sec-fetch-mode": "cors",
      "sec-fetch-dest": "empty",
      "referer": "https://items.learnosity.com/v2021.3.LTS/xdomain",
      "accept-language": "en-US,en;q=0.9"
    };
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(url),
    );
    request.fields.addAll(body);
    request.headers.addAll(header ?? headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      return jsonDecode(data.toString());
    } else {
      return null;
    }
  }

  @protected
  Future<http.Response> put(String url, Object body) async {
    await _refreshTokenIfNeeded();
    return http
        .put(_getParsedUri(url),
            headers: getCompleteHeaders(), body: json.encode(body))
        .timeout(Duration(seconds: configuration.getRequestTimeout()))
        .onError(
            (error, stackTrace) => Future.value(http.Response("Error", 500)));
  }

  @protected
  Future<http.Response> putWithHeaders(
      String url, Map<String, String> headers, Object body) async {
    await _refreshTokenIfNeeded();
    return http
        .put(_getParsedUri(url),
            headers: getCompleteHeaders(headers), body: json.encode(body))
        .timeout(Duration(seconds: configuration.getRequestTimeout()))
        .onError(
            (error, stackTrace) => Future.value(http.Response("Error", 500)));
  }

  @protected
  Future<http.Response> deleteWithBody(String url, Object body) async {
    await _refreshTokenIfNeeded();
    return http
        .delete(_getParsedUri(url),
            headers: getCompleteHeaders(), body: json.encode(body))
        .timeout(Duration(seconds: configuration.getRequestTimeout()))
        .onError(
            (error, stackTrace) => Future.value(http.Response("Error", 500)));
  }

  @protected
  Future<http.Response> delete(String url) async {
    await _refreshTokenIfNeeded();
    return http
        .delete(_getParsedUri(url),
        headers: getCompleteHeaders())
        .timeout(Duration(seconds: configuration.getRequestTimeout()))
        .onError(
            (error, stackTrace) => Future.value(http.Response("Error", 500)));
  }

  @protected
  Future<http.Response> deleteWithHeaders(
      String url, Map<String, String> headers, Object body) async {
    await _refreshTokenIfNeeded();
    return http
        .delete(_getParsedUri(url),
            headers: getCompleteHeaders(headers), body: body)
        .timeout(Duration(seconds: configuration.getRequestTimeout()))
        .onError(
            (error, stackTrace) => Future.value(http.Response("Error", 500)));
  }

  Future<Uint8List> readPdf(String url,
      {int? learningActivityId, String? fileName, File? file}) async {
    dio.Response response = await dio.Dio().get(
      _getParsedUri(url).toString(),
      options: dio.Options(
        responseType: dio.ResponseType.bytes,
        headers: getCompleteHeaders(),
      ),
    );

    return response.data;
  }

  Future<File?> downloadCaption(String url, File file) async {
    dio.Dio downloader = dio.Dio();
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      downloader.download(
        url,
        file.path,
        deleteOnError: true,
      );
      return file;
    } else {
      return null;
    }
  }

  @protected
  Future<Uint8List> getExternalFile(String url) async {
    dio.Dio downloader = dio.Dio();
    dio.Response response = await downloader.get(url,
        options: dio.Options(
          responseType: dio.ResponseType.bytes,
        ));
    return Uint8List.fromList(response.data);
  }

  @protected
  Future<Uint8List> getInternalFileWithCompleteUrl(String url) async {
    dio.Dio downloader = dio.Dio();
    dio.Response response = await downloader.get(url,
        options: dio.Options(
            responseType: dio.ResponseType.bytes,
            headers: getCompleteHeaders()));
    return Uint8List.fromList(response.data);
  }

  @protected
  Future<File> downloadExternalFile(
      String url, File file, MediaFileType type, int learningActivityId) async {
    final DashboardController dashboardController = Get.find();
    dio.Dio downloader = dio.Dio();
    final index = 0;
    await downloader.download(
      url,
      file.path,
      onReceiveProgress: (rcv, total) {
        if (index != -1) {
          if (type == MediaFileType.video) {
          } else if (type == MediaFileType.audio) {}
        }
      },
      deleteOnError: true,
    );
    return file;
  }


  @protected
  Map<String, String> getCompleteHeaders([Map<String, String>? headers]) {
    Map<String, String> finalHeaders = <String, String>{};
    if (headers != null && headers.isNotEmpty) {
      finalHeaders.addAll(headers);
    }
    if (!finalHeaders.containsKey('Content-Type')) {
      finalHeaders['Content-Type'] = 'application/json';
    }
    if (!finalHeaders.containsKey('Accept')) {
      finalHeaders['Accept'] = 'application/json,text/pain,*/*';
    }
    var user = User();
    if (!finalHeaders.containsKey('Authorization') &&
        user.token.target != null) {
      finalHeaders['Authorization'] =
          '${user.token.target!.tokenType} ${User().token.target!.token}';
    }
    return finalHeaders;
  }

  Future<void> _refreshTokenIfNeeded() async {
    final user = User();
    if (user.token.target != null
        //&& user.token.target!.expireDate.isBefore(DateTime.now())
        ) {
      final AuthService authService = Get.find();
      await authService.refreshToken();
    }
  }

  String getUrlEncodedParams(String route, Map<String, String?> params) {
    return Uri(path: route, queryParameters: params).toString();
  }

  static bool isSuccessful(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  static bool isSuccessfulStreamedResponse(http.StreamedResponse response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
  }
}
