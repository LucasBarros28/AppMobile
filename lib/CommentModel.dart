class CommentModel {
  final int? id; 
  final int reviewId;
  final int profileId;
  final int? parentId;
  final String content;
  final int likes;

  CommentModel({
    this.id, 
    required this.reviewId,
    required this.profileId,
    this.parentId,
    required this.content,
    required this.likes,
  });

  CommentModel copyWith({
    int? id,
    int? reviewId,
    int? profileId,
    int? parentId,
    String? content,
    int? likes,
  }) {
    return CommentModel(
      id: id ?? this.id,
      reviewId: reviewId ?? this.reviewId,
      profileId: profileId ?? this.profileId,
      parentId: parentId ?? this.parentId,
      content: content ?? this.content,
      likes: likes ?? this.likes,
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'id_review': reviewId,
      'id_profile': profileId,
      'parent_comment_id': parentId,
      'content': content,
      'likes': likes,
    };

    if (id != null) {
      map['id_comment'] = id;
    }

    return map;
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id_comment'],
      reviewId: map['id_review'],
      profileId: map['id_profile'],
      parentId: map['parent_comment_id'] != null ? map['parent_comment_id'] as int : null,
      content: map['content'],
      likes: map['likes'] ?? 0,
    );
  }
}
