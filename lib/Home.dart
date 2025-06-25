import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lecternus/Review.dart';
import 'package:lecternus/ReviewModel.dart';
import 'package:lecternus/ReviewSource.dart';
import 'package:lecternus/CommentModel.dart';
import 'package:lecternus/CommentSource.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ReviewModel> _reviews = [];
  Set<int> likedReviewIds = {}; // Controle local de curtidas

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    try {
      final data = await ReviewSource.getAllReviews();
      setState(() {
        _reviews = data;
      });
    } catch (e) {
      print('Erro ao carregar reviews: $e');
      setState(() {
        _reviews = [];
      });
    }
  }

  Widget buildReviewImage(Uint8List? imageBlob) {
    if (imageBlob != null && imageBlob.isNotEmpty) {
      return Image.memory(
        imageBlob,
        width: 80,
        height: 100,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        'assets/images/imagem.jpg',
        width: 80,
        height: 100,
        fit: BoxFit.cover,
      );
    }
  }

  void _likeReview(int reviewId) async {
    final index = _reviews.indexWhere((r) => r.id == reviewId);
    if (index == -1) return;

    final currentReview = _reviews[index];
    final newLikes = currentReview.likes + 1;

    await ReviewSource.updateLikes(reviewId, newLikes);

    setState(() {
      _reviews[index] = currentReview.copyWith(likes: newLikes);
      likedReviewIds.add(reviewId);
    });
  }

  void _showComments(int reviewId) async {
    final comments = await CommentSource.getCommentsByReview(reviewId);
    final TextEditingController _commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Comentários',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              if (comments.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Nenhum comentário ainda.'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                      leading: const Icon(Icons.comment),
                      title: Text(comment.content),
                    );
                  },
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          labelText: 'Digite um comentário',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        final text = _commentController.text.trim();
                        if (text.isNotEmpty) {
                          await CommentSource.insertComment(
                            CommentModel(
                              id: null,
                              reviewId: reviewId,
                              profileId: 0, // Substituir com ID real depois
                              content: text,
                              likes: 0,
                            ),
                          );
                          Navigator.of(context).pop();
                          _showComments(reviewId); // recarrega modal
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _shareReview(ReviewModel review) {
    final message = '''
📚 *${review.bookTitle}* por ${review.bookAuthor}

📝 Resenha:
${review.reviewText}

Compartilhado via Lecternus 📖
''';
    Share.share(message);
  }

  Future<void> _followUser(int profileIdToFollow) async {
    print('Seguir perfil: $profileIdToFollow');
    final prefs = await SharedPreferences.getInstance();
    final int? currentUserId = prefs.getInt('id_user');
    if (currentUserId == null) {
      print('Usuário não logado.');
      return;
    }
    // Lógica de follow futura
  }

  Widget _buildReviewCard(ReviewModel review) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewPage(review: review),
          ),
        ).then((refresh) {
          if (refresh == true) {
            _loadReviews(); // atualiza após alterações na review
          }
        });
      },
      child: Container(
        width: 350,
        decoration: BoxDecoration(
          color: const Color(0xFFCDA68C),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: buildReviewImage(review.imageBlob),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.userName,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text("Livro: ${review.bookTitle}",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text(review.reviewText,
                          style:
                              TextStyle(fontSize: 16, color: Colors.black),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        likedReviewIds.contains(review.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: likedReviewIds.contains(review.id)
                          ? null
                          : () => _likeReview(review.id),
                    ),
                    Text('${review.likes}',
                        style: TextStyle(color: Colors.black)),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.mode_comment_outlined,
                          color: Colors.black, size: 30),
                      onPressed: () => _showComments(review.id),
                    ),
                    FutureBuilder<int>(
                      future:
                          CommentSource.countByReviewId(review.id),
                      builder: (context, snapshot) {
                        return Text('${snapshot.data ?? 0}',
                            style: TextStyle(color: Colors.black));
                      },
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.share_outlined,
                          color: Colors.black, size: 30),
                      onPressed: () => _shareReview(review),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _followUser(review.profileId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF57362B),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("+ Seguir Perfil",
                      style:
                          TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF57362B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF57362B),
        title: Text('Início', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: _reviews.isEmpty
          ? Center(
              child: Text('Nenhuma review disponível',
                  style: TextStyle(color: Colors.white70)))
          : ListView.builder(
              itemCount: _reviews.length,
              itemBuilder: (context, index) =>
                  _buildReviewCard(_reviews[index]),
            ),
    );
  }
}
