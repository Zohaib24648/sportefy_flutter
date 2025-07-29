import 'package:equatable/equatable.dart';
import 'sport_dto.dart';

class SportApiDTO extends Equatable {
  final List<SportDTO> data;
  final bool success;
  final String message;

  const SportApiDTO({
    required this.data,
    required this.success,
    required this.message,
  });

  factory SportApiDTO.fromJson(Map<String, dynamic> json) {
    return SportApiDTO(
      data: (json['data'] as List)
          .map((item) => SportDTO.fromJson(item as Map<String, dynamic>))
          .toList(),
      success: json['success'] as bool,
      message: json['message'] as String,
    );
  }

  @override
  List<Object?> get props => [data, success, message];
}
