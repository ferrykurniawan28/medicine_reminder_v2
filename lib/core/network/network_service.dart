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
      print('GET request to $url');
      print('Starting GET request to $url');
      final response = await _dio.get(
        url,
        options: Options(
          headers: headers,
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
      final jsonBody =
          response.data is String ? json.decode(response.data) : response.data;
      return ApiResponse<T>.fromJson(
        jsonBody,
        fromData: fromData,
      ).copyWith(statusCode: response.statusCode);
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        print(
            'DioError: ${dioError.response?.statusCode} - ${dioError.response?.statusMessage}');
        return ApiResponse<T>(
          error:
              'Error: ${dioError.response?.statusCode} - ${dioError.response?.statusMessage}',
          statusCode: dioError.response?.statusCode,
        );
      } else {
        print('DioError without response: ${dioError.message}');
        return ApiResponse<T>(error: dioError.message);
      }
    } catch (e) {
      return ApiResponse<T>(error: e.toString());
    }
  }

  Future<ApiResponse<T>> post<T>(
    String url, {
    // Map<String, String>? headers,
    Object? body,
    T Function(dynamic)? fromData,
  }) async {
    try {
      print('POST request to $url with body: $body');
      print('post');
      final response = await _dio.post(
        url,
        data: body != null ? json.encode(body) : null,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      print('response error: ${response.statusMessage}');
      final jsonBody =
          response.data is String ? json.decode(response.data) : response.data;
      return ApiResponse<T>.fromJson(
        jsonBody,
        fromData: fromData,
      ).copyWith(statusCode: response.statusCode);
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        print(
            'DioError: ${dioError.response?.statusCode} - ${dioError.response?.statusMessage}');
        return ApiResponse<T>(
          error:
              'Error: ${dioError.response?.statusCode} - ${dioError.response?.statusMessage}',
          statusCode: dioError.response?.statusCode,
        );
      } else {
        print('DioError without response: ${dioError.message}');
        return ApiResponse<T>(error: dioError.message);
      }
    } catch (e) {
      return ApiResponse<T>(error: e.toString());
    }
  }

  Future<ApiResponse<T>> put<T>(
    String url, {
    Map<String, String>? headers,
    Object? body,
    T Function(dynamic)? fromData,
  }) async {
    try {
      final response = await _dio.put(
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
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        print(
            'DioError: ${dioError.response?.statusCode} - ${dioError.response?.statusMessage}');
        return ApiResponse<T>(
          error:
              'Error: ${dioError.response?.statusCode} - ${dioError.response?.statusMessage}',
          statusCode: dioError.response?.statusCode,
        );
      } else {
        print('DioError without response: ${dioError.message}');
        return ApiResponse<T>(error: dioError.message);
      }
    } catch (e) {
      return ApiResponse<T>(error: e.toString());
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String url, {
    Map<String, String>? headers,
    T Function(dynamic)? fromData,
  }) async {
    try {
      print('DELETE request to $url');
      print('Starting DELETE request to $url');
      final response =
          await _dio.delete(url, options: Options(headers: headers));
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      final jsonBody =
          response.data is String ? json.decode(response.data) : response.data;
      return ApiResponse<T>.fromJson(
        jsonBody,
        fromData: fromData,
      ).copyWith(statusCode: response.statusCode);
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        print(
            'DioError: ${dioError.response?.statusCode} - ${dioError.response?.statusMessage}');
        return ApiResponse<T>(
          error:
              'Error: ${dioError.response?.statusCode} - ${dioError.response?.statusMessage}',
          statusCode: dioError.response?.statusCode,
        );
      } else {
        print('DioError without response: ${dioError.message}');
        return ApiResponse<T>(error: dioError.message);
      }
    } catch (e) {
      return ApiResponse<T>(error: e.toString());
    }
  }
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
