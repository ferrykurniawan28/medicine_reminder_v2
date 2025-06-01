class ApiResponse<T> {
  final T? data;
  final String? error;
  final int? statusCode;
  final String? message;
  final String? token;

  ApiResponse(
      {this.data, this.error, this.statusCode, this.message, this.token});

  bool get isSuccess =>
      error == null &&
      statusCode != null &&
      statusCode! >= 200 &&
      statusCode! < 300;
  bool get isError =>
      error != null ||
      statusCode == null ||
      statusCode! < 200 ||
      statusCode! >= 300;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic)? fromData,
  }) {
    return ApiResponse<T>(
      data: fromData != null && json['data'] != null
          ? fromData(json['data'])
          : json['data'],
      error: json['error'],
      statusCode: json['statusCode'],
      message: json['message'],
      token: json['token'],
    );
  }

  @override
  String toString() {
    return 'ApiResponse(data: $data, error: $error, statusCode: $statusCode, message: $message, token: $token)';
  }
}
