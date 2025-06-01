import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_reminder/core/network/network_service.dart';
import 'package:medicine_reminder/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:medicine_reminder/core/network/api_response.dart';
import 'package:medicine_reminder/features/user/domain/entities/user.dart';

class MockNetworkService extends Fake implements NetworkService {
  @override
  Future<ApiResponse<T>> post<T>(
    String url, {
    Map<String, String>? headers,
    Object? body,
    T Function(dynamic)? fromData,
  }) async {
    if (url.contains('login')) {
      if (body is Map &&
          body['email'] == 'test@test.com' &&
          body['password'] == '1234') {
        final user = User(userId: 1, userName: 'Test', email: 'test@test.com');
        return ApiResponse<T>(
          data: fromData != null ? fromData(user.toJson()) : user as T,
          statusCode: 200,
          token: 'mock_token',
        );
      } else {
        return ApiResponse<T>(error: 'Invalid credentials', statusCode: 401);
      }
    } else if (url.contains('register')) {
      if (body is Map && body['email'] == 'new@test.com') {
        final user =
            User(userId: 2, userName: body['name'], email: body['email']);
        return ApiResponse<T>(
          data: fromData != null ? fromData(user.toJson()) : user as T,
          statusCode: 200,
        );
      } else {
        return ApiResponse<T>(error: 'Registration failed', statusCode: 400);
      }
    }
    return ApiResponse<T>(error: 'Unknown endpoint', statusCode: 404);
  }
}

void main() {
  group('AuthRemoteDataSource', () {
    late AuthRemoteDataSource dataSource;
    setUp(() {
      dataSource = AuthRemoteDataSource(networkService: MockNetworkService());
    });

    test('loginUser returns user on success', () async {
      final response =
          await dataSource.loginUser(email: 'test@test.com', password: '1234');
      expect(response.isSuccess, true);
      expect(response.data, isA<User>());
      expect(response.data?.email, 'test@test.com');
      expect(response.token, 'mock_token');
    });

    test('loginUser returns error on failure', () async {
      final response = await dataSource.loginUser(
          email: 'wrong@test.com', password: 'wrong');
      expect(response.isSuccess, false);
      expect(response.error, isNotNull);
    });

    test('registerUser returns user on success', () async {
      final response = await dataSource.registerUser(
          name: 'New', email: 'new@test.com', password: 'pass');
      expect(response.isSuccess, true);
      expect(response.data, isA<User>());
      expect(response.data?.email, 'new@test.com');
    });

    test('registerUser returns error on failure', () async {
      final response = await dataSource.registerUser(
          name: 'Fail', email: 'fail@test.com', password: 'pass');
      expect(response.isSuccess, false);
      expect(response.error, isNotNull);
    });
  });
}
