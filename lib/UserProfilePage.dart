import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lecternus/ReviewModel.dart';
import 'package:lecternus/Review.dart';
import 'package:lecternus/database_helper.dart';

class UserProfilePage extends StatefulWidget {
  final int profileId;
  final String tag;

  const UserProfilePage({required this.profileId, required this.tag, Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  List<ReviewModel> _userReviews = [];

  @override
  void initState() {
    super.initState();
    _loadUserReviews();
  }

  Future<void> _loadUserReviews() async {
    final db = await DatabaseHelper().db;
    final reviews = await db.query(
      'Review',
      where: 'id_profile = ?',
      whereArgs: [widget.profileId],
    );

    setState(() {
      _userReviews = reviews.map((r) => ReviewModel(
        id: r['id_review'] as int,
        profileId: r['id_profile'] as int,
        userName: widget.tag,
        reviewTitle: r['title_review'] as String,
        bookTitle: r['title_book'] as String,
        reviewText: r['content'] as String,
        bookAuthor: r['author_book'] as String,
        imageBlob: r['image_blob'] as Uint8List?,
        likes: (r['likes'] ?? 0) as int,
      )).toList();
    });
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('@${widget.tag}', style: const TextStyle(fontSize: 20, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildReviewList() {
    if (_userReviews.isEmpty) {
      return const Center(
        child: Text('Nenhuma review encontrada', style: TextStyle(color: Colors.white)),
      );
    }

    return ListView.builder(
      itemCount: _userReviews.length,
      itemBuilder: (context, index) {
        final review = _userReviews[index];

        return Card(
          color: const Color(0xFFCDA68C),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewPage(review: review),
                ),
              );
            },
            title: Text(review.reviewTitle, style: const TextStyle(color: Color(0xFF57362B))),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Livro: ${review.bookTitle}", style: const TextStyle(color: Color(0xFF57362B))),
                const SizedBox(height: 4),
                Text(
                  review.reviewText,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF57362B)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF57362B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF57362B),
        title: Text('@${widget.tag}', style: const TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          _buildHeader(),
          const Divider(color: Colors.white24),
          Expanded(child: _buildReviewList()),
        ],
      ),
    );
  }
}
