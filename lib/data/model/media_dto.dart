class MediaDTO {
  final String id;
  final String mediaLink;
  final String mediaType;
  final String entityId;
  final String entityType;

  const MediaDTO({
    required this.id,
    required this.mediaLink,
    required this.mediaType,
    required this.entityId,
    required this.entityType,
  });

  factory MediaDTO.fromJson(Map<String, dynamic> json) {
    return MediaDTO(
      id: json['id'] as String,
      mediaLink: json['media_link'] as String,
      mediaType: json['media_type'] as String,
      entityId: json['entity_id'] as String,
      entityType: json['entity_type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'media_link': mediaLink,
      'media_type': mediaType,
      'entity_id': entityId,
      'entity_type': entityType,
    };
  }
}
