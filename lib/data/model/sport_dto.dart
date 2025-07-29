import 'package:equatable/equatable.dart';

class SportDTO extends Equatable {
  final String id;
  final String name;
  final bool timeBound;
  final String sportType;

  const SportDTO({
    required this.id,
    required this.name,
    required this.timeBound,
    required this.sportType,
  });

  factory SportDTO.fromJson(Map<String, dynamic> json) {
    return SportDTO(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      timeBound: json['timeBound'] as bool? ?? false,
      sportType: json['sportType'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'timeBound': timeBound,
      'sportType': sportType,
    };
  }

  @override
  List<Object?> get props => [id, name, timeBound, sportType];
}
