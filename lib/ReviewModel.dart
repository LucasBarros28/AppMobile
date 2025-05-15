class ReviewModel {
  final int id;
  final int profileId;
  final String userName;
  final String bookTitle;
  final String bookAuthor;
  final String reviewTitle;
  final String reviewText;
  final String imagePath;

  ReviewModel({
    required this.id,
    required this.profileId,
    required this.userName,
    required this.bookTitle,
    required this.bookAuthor,
    required this.reviewTitle,
    required this.reviewText,
    required this.imagePath,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id_review'],
      profileId: map['id_profile'],
      userName: map['tag'],
      bookTitle: map['title_book'],
      bookAuthor: map['author_book'],
      reviewTitle: map['title_review'],
      reviewText: map['content'],
      imagePath: map['image_path'],
    );
  }
}
