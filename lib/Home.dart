import 'package:flutter/material.dart';
import 'package:lecternus/Review.dart';
import 'package:lecternus/ReviewModel.dart';
import 'package:lecternus/ReviewSource.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ReviewModel> _reviews = [];

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

  void _likeReview(int reviewId) {
    print('Curtir review: $reviewId');
    // Implementar lógica de curtir aqui
  }

  void _showComments(int reviewId) {
    print('Mostrar comentários para a review: $reviewId');
    // Implementar lógica de comentários aqui
  }

  void _shareReview(ReviewModel review) {
    print('Compartilhar review: ${review.reviewText}');
    // Implementar lógica de compartilhamento aqui
  }

  void _followUser(int profileId) {
    print('Seguir usuário: $profileId');
    // Implementar lógica de seguir aqui
  }

  Widget _buildReviewCard(ReviewModel review) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewPage(review: review),
          ),
        );
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
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(review.imagePath),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Livro: ${review.bookTitle}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        review.reviewText,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
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
                        Icons.favorite_border,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () => _likeReview(review.id),
                    ),
                    Text('0'), // Likes fixo por enquanto
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(
                        Icons.mode_comment_outlined,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () => _showComments(review.id),
                    ),
                    Text('0'), // Comments fixo por enquanto
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(
                        Icons.share_outlined,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () => _shareReview(review),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _followUser(review.profileId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF57362B),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "+ Seguir Perfil",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
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
              child: Text(
                'Nenhuma review disponível',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final review = _reviews[index];
                return _buildReviewCard(review);
              },
            ),
    );
  }
}
