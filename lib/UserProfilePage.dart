// UserProfilePage.dart
import 'package:flutter/material.dart';
import 'package:lecternus/database_helper.dart';
import 'package:lecternus/ReviewModel.dart';
import 'package:lecternus/Review.dart';
import 'package:lecternus/SignIn.dart';

class UserProfilePage extends StatefulWidget {
  final int idProfile;
  final String tag;

  const UserProfilePage({required this.idProfile, required this.tag});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String _name = '';
  String _bio = '';
  List<ReviewModel> _userReviews = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final db = await DatabaseHelper().db;

    final result = await db.rawQuery('''
      SELECT u.name, p.bio
      FROM Profile p
      JOIN User u ON u.id_user = p.id_user
      WHERE p.id_profile = ?
    ''', [widget.idProfile]);

    if (result.isNotEmpty) {
      final dados = result.first;
      setState(() {
        _name = dados['name'] as String;
        _bio = dados['bio'] as String;
      });
    }

    final reviews = await db.rawQuery('''
      SELECT r.*
      FROM Review r
      WHERE r.id_profile = ?
    ''', [widget.idProfile]);

    setState(() {
      _userReviews = reviews.map((r) => ReviewModel(
        id: r['id_review'] as int,
        profileId: r['id_profile'] as int,
        userName: widget.tag,
        reviewTitle: r['title_review'] as String,
        bookTitle: r['title_book'] as String,
        reviewText: r['content'] as String,
        bookAuthor: r['author_book'] as String,
        imagePath: r['image_path'] as String,
      )).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF57362B),
      appBar: AppBar(
        backgroundColor: Color(0xFF57362B),
        title: Text("@${widget.tag}", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Divider(color: Colors.white24),
          Expanded(child: _buildReviewList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFFCDA68C),
            child: Icon(Icons.person, size: 40, color: Color(0xFF57362B)),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                Text("@${widget.tag}",
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.white70)),
                SizedBox(height: 12),
                Text(_bio, style: TextStyle(color: Colors.white)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildReviewList() {
    if (_userReviews.isEmpty) {
      return Center(child: Text("Nenhuma review encontrada", style: TextStyle(color: Colors.white)));
    }

    return ListView.builder(
      itemCount: _userReviews.length,
      itemBuilder: (context, index) {
        final review = _userReviews[index];
        return Card(
          color: Color(0xFFCDA68C),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReviewPage(review: review)),
              );
            },
            contentPadding: EdgeInsets.all(12),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('@${review.userName}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF57362B))),
                SizedBox(height: 4),
                Text(review.reviewTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF57362B))),
                SizedBox(height: 2),
                Text('Livro: ${review.bookTitle}', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Color(0xFF57362B))),
                SizedBox(height: 8),
                Text(
                  review.reviewText.length > 100
                      ? '${review.reviewText.substring(0, 100)}...'
                      : review.reviewText,
                  style: TextStyle(fontSize: 13, color: Color(0xFF57362B)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
