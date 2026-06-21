import 'package:dio/dio.dart';

class DioClient {
  late final Dio dio;

  DioClient({required String baseUrl, bool? tokenRequired}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
        validateStatus: (status) => true,
      ),
    );

    _addInterceptors();
  }

  void _addInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = '';//LocalStorageService.getString('access_token');

          final isTokenRequired = options.extra['tokenRequired'] ?? true;
          if (isTokenRequired && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          if (response.statusCode == 401) {
            _logout();
          }
          handler.next(response);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  void _logout() {}
}
