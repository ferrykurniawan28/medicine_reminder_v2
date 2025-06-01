import 'dart:convert';
import 'package:dio/dio.dart';
import 'api_response.dart';

class NetworkService {
  final Dio _dio;

  NetworkService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              headers: {
                'Content-Type': 'application/json',
              },
            ));

  Future<ApiResponse<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    T Function(dynamic)? fromData,
  }) async {
    try {
      final response = await _dio.get(url, options: Options(headers: headers));
      final jsonBody =
          response.data is String ? json.decode(response.data) : response.data;
      return ApiResponse<T>.fromJson(
        jsonBody,
        fromData: fromData,
      ).copyWith(statusCode: response.statusCode);
    } catch (e) {
      return ApiResponse<T>(error: e.toString());
    }
  }

  Future<ApiResponse<T>> post<T>(
    String url, {
    Map<String, String>? headers,
    Object? body,
    T Function(dynamic)? fromData,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: body != null ? json.encode(body) : null,
        options: Options(headers: headers),
      );
      final jsonBody =
          response.data is String ? json.decode(response.data) : response.data;
      return ApiResponse<T>.fromJson(
        jsonBody,
        fromData: fromData,
      ).copyWith(statusCode: response.statusCode);
    } catch (e) {
      return ApiResponse<T>(error: e.toString());
    }
  }

  // Add put, delete, etc. as needed
}

extension ApiResponseCopyWith<T> on ApiResponse<T> {
  ApiResponse<T> copyWith({int? statusCode}) {
    return ApiResponse<T>(
      data: data,
      error: error,
      statusCode: statusCode ?? this.statusCode,
      message: message,
      token: token,
    );
  }
}
