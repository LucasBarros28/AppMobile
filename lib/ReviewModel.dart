// models/review_model.dart
class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String userImage;
  final String bookTitle;
  final String reviewText;
  final DateTime date;
  final int likes;
  final int comments;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.bookTitle,
    required this.reviewText,
    required this.date,
    this.likes = 0,
    this.comments = 0,
  });

  // Método para criar a partir de um Map (útil para Firebase, por exemplo)
  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'],
      userId: map['userId'],
      userName: map['userName'],
      userImage: map['userImage'],
      bookTitle: map['bookTitle'],
      reviewText: map['reviewText'],
      date: DateTime.parse(map['date']),
      likes: map['likes'] ?? 0,
      comments: map['comments'] ?? 0,
    );
  }

  // Método para converter para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'bookTitle': bookTitle,
      'reviewText': reviewText,
      'date': date.toIso8601String(),
      'likes': likes,
      'comments': comments,
    };
  }
}
