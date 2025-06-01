import 'package:medicine_reminder/core/constant/url.dart';
import 'package:medicine_reminder/core/network/api_response.dart';
import 'package:medicine_reminder/core/network/network_service.dart';
import 'package:medicine_reminder/features/user/domain/entities/user.dart';

class AuthRemoteDataSource {
  final NetworkService networkService;
  AuthRemoteDataSource({NetworkService? networkService})
      : networkService = networkService ?? NetworkService();

  Future<ApiResponse<User>> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await networkService.post<User>(
      loginUrl,
      body: {
        'email': email,
        'password': password,
      },
      fromData: (data) => User.fromJson(data['user']),
    );
    // statusCode is set by NetworkService using Dio's response.statusCode
    return response;
  }

  Future<ApiResponse<User>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await networkService.post<User>(
      registerUrl,
      body: {
        'username': name,
        'email': email,
        'password': password,
      },
      fromData: (data) => User.fromJson(data['user']),
    );
    // statusCode is set by NetworkService using Dio's response.statusCode
    return response;
  }
}
