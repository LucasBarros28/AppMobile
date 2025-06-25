import 'dart:typed_data';

class ReviewModel {
  final int id;
  final int profileId;
  final String userName;
  final String bookTitle;
  final String bookAuthor;
  final String reviewTitle;
  final String reviewText;
  final Uint8List? imageBlob;
  final int likes;

  ReviewModel({
    required this.id,
    required this.profileId,
    required this.userName,
    required this.bookTitle,
    required this.bookAuthor,
    required this.reviewTitle,
    required this.reviewText,
    required this.imageBlob,
    required this.likes,
  });

    ReviewModel copyWith({
    int? id,
    int? profileId,
    String? userName,
    String? bookTitle,
    String? bookAuthor,
    String? reviewTitle,
    String? reviewText,
    Uint8List? imageBlob,
    int? likes,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      userName: userName ?? this.userName,
      bookTitle: bookTitle ?? this.bookTitle,
      bookAuthor: bookAuthor ?? this.bookAuthor,
      reviewTitle: reviewTitle ?? this.reviewTitle,
      reviewText: reviewText ?? this.reviewText,
      imageBlob: imageBlob ?? this.imageBlob,
      likes: likes ?? this.likes,
    );
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id_review'],
      profileId: map['id_profile'],
      userName: map['tag'],
      bookTitle: map['title_book'],
      bookAuthor: map['author_book'],
      reviewTitle: map['title_review'],
      reviewText: map['content'],
      imageBlob: map['image_blob'],
      likes: map['likes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_review': id,
      'id_profile': profileId,
      'title_book': bookTitle,
      'author_book': bookAuthor,
      'title_review': reviewTitle,
      'author_review': userName,
      'content': reviewText,
      'image_blob': imageBlob,
      'likes': likes,
    };
  }
}
