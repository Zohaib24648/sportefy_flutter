class ApiResponseDTO<T> {
  final T data;
  final bool success;
  final String message;

  const ApiResponseDTO({
    required this.data,
    required this.success,
    required this.message,
  });

  factory ApiResponseDTO.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromData,
  ) {
    return ApiResponseDTO<T>(
      data: fromData(json['data']),
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
