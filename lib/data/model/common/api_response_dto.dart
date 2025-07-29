class ApiResponse<T> {
  final T data;
  final bool success;
  final String message;

  const ApiResponse({
    required this.data,
    required this.success,
    required this.message,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromData,
  ) {
    return ApiResponse<T>(
      data: fromData(json['data']),
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
