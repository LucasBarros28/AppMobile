import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lecternus/Config.dart';
import 'package:lecternus/database_helper.dart';
import 'package:lecternus/Review.dart';
import 'package:lecternus/ReviewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  String _name = '...';
  String _tag = '@...';
  String _bio = '...';
  int _reviews = 0;
  int _followers = 0;
  int _following = 0;
  int? _idProfile;

  File? _profileImage;

  List<Map<String, dynamic>> _userReviews = [];
  List<Map<String, dynamic>> _userComments = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserProfile();
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });

      // Exemplo: salvar caminho no banco
      /*
      final db = await DatabaseHelper().db;
      await db.update(
        'Profile',
        {'profile_image': pickedFile.path},
        where: 'id_profile = ?',
        whereArgs: [_idProfile],
      );
      */
    }
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final int? idUser = prefs.getInt('id_user');

    if (idUser == null) return;

    final db = await DatabaseHelper().db;
    final userResult =
        await db.query('User', where: 'id_user = ?', whereArgs: [idUser]);
    final profileResult =
        await db.query('Profile', where: 'id_user = ?', whereArgs: [idUser]);

    if (userResult.isNotEmpty && profileResult.isNotEmpty) {
      final profile = profileResult.first;
      setState(() {
        _name = userResult.first['name'] as String;
        _tag = '@${profile['tag']}';
        _bio = profile['bio'] as String;
        _reviews = profile['count_reviews'] as int;
        _followers = profile['count_followers'] as int;
        _following = profile['count_following'] as int;
        _idProfile = profile['id_profile'] as int;
      });
      _loadUserReviews();
      _loadUserComments();
    }
  }

  Future<void> _loadUserReviews() async {
    if (_idProfile == null) return;
    final db = await DatabaseHelper().db;
    final result = await db
        .query('Review', where: 'id_profile = ?', whereArgs: [_idProfile]);

    setState(() {
      _userReviews = result;
      _reviews = result.length;
    });

    await db.update(
      'Profile',
      {'count_reviews': result.length},
      where: 'id_profile = ?',
      whereArgs: [_idProfile],
    );
  }

  Future<void> _loadUserComments() async {
    if (_idProfile == null) return;
    final db = await DatabaseHelper().db;
    final result = await db.rawQuery('''
      SELECT c.content, r.title_review, r.id_review, r.title_book,
             r.content as review_text, r.image_path, r.id_profile
      FROM Comment c 
      JOIN Review r ON c.id_review = r.id_review 
      WHERE c.id_profile = ?
    ''', [_idProfile]);
    setState(() => _userComments = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF57362B),
      appBar: AppBar(
        backgroundColor: Color(0xFF57362B),
        automaticallyImplyLeading: false,
        title: Text("Lecternus", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Config()));
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFFCDA68C),
          tabs: [
            Tab(text: 'Reviews'),
            Tab(text: 'Comentários'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildReviewList(),
                _buildCommentList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: _pickProfileImage,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFCDA68C),
              backgroundImage:
                  _profileImage != null ? FileImage(_profileImage!) : null,
              child: _profileImage == null
                  ? Icon(Icons.person, size: 40, color: Color(0xFF57362B))
                  : null,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_name,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text(_tag,
                    style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.white70)),
                SizedBox(height: 12),
                Row(
                  children: [
                    _buildStat("Reviews", _reviews),
                    SizedBox(width: 16),
                    _buildStat("Leitores", _followers),
                    SizedBox(width: 16),
                    _buildStat("Seguindo", _following),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStat(String label, int count) {
    return Column(
      children: [
        Text("$count",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white)),
        Text(label, style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildReviewList() {
    if (_userReviews.isEmpty) {
      return Center(
          child: Text("Nenhuma review encontrada",
              style: TextStyle(color: Colors.white)));
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
              final model = ReviewModel(
                id: review['id_review'],
                profileId: review['id_profile'],
                userName: _tag.replaceFirst('@', ''),
                reviewTitle: review['title_review'],
                bookTitle: review['title_book'],
                reviewText: review['content'],
                bookAuthor: review['author_book'] ?? '',
                imageBlob: review['image_blob'] ?? '',
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReviewPage(review: model)),
              );
            },
            title: Text(review['title_review'],
                style: TextStyle(color: Color(0xFF57362B))),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Livro: ${review['title_book']}",
                    style: TextStyle(color: Color(0xFF57362B))),
                SizedBox(height: 4),
                Text(
                  review['content'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Color(0xFF57362B)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCommentList() {
    if (_userComments.isEmpty) {
      return Center(
          child: Text("Nenhum comentário publicado",
              style: TextStyle(color: Colors.white)));
    }

    return ListView.builder(
      itemCount: _userComments.length,
      itemBuilder: (context, index) {
        final comment = _userComments[index];
        return Card(
          color: Color(0xFFCDA68C),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            onTap: () {
              final model = ReviewModel(
                id: comment['id_review'],
                profileId: comment['id_profile'],
                userName: _tag.replaceFirst('@', ''),
                reviewTitle: comment['title_review'],
                bookTitle: comment['title_book'],
                reviewText: comment['review_text'],
                bookAuthor: comment['author_book'] ?? '',
                imageBlob: comment['image_blob'] ?? '',
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReviewPage(review: model)),
              );
            },
            title: Text(comment['title_review'],
                style: TextStyle(color: Color(0xFF57362B))),
            subtitle: Text(comment['content'],
                style: TextStyle(color: Color(0xFF57362B))),
          ),
        );
      },
    );
  }
}
