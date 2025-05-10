import 'dart:ui';
import 'package:lecternus/Review.dart';
import 'package:lecternus/Profile.dart';
import 'package:lecternus/criarReview.dart';
import 'package:flutter/material.dart';
import 'package:lecternus/Config.dart';
import 'package:lecternus/Sobre.dart';
import 'package:lecternus/bottom_nav_bar.dart';
import 'package:lecternus/Review.dart';
import 'package:lecternus/ReviewModel.dart';
import 'package:lecternus/ReviewSoucer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  List<ReviewModel> _reviews = [];
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadInitialReviews();
  }

  Future<void> _loadInitialReviews() async {
    setState(() => _isLoading = true);
    final reviews = await ReviewSource.getAllReviews();
    setState(() {
      _reviews = reviews;
      _isLoading = false;
    });
  }

  Future<void> _loadMoreReviews() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      final newReviews = await ReviewSource.loadMoreReviews(_reviews.length);

      setState(() {
        _isLoading = false;
        if (newReviews.isEmpty) {
          _hasMore = false; // Esta linha é crucial para parar o carregamento
        } else {
          _reviews.addAll(newReviews);
          // Adicione esta verificação adicional
          if (newReviews.length < 5) {
            // Supondo que 5 é o número esperado por página
            _hasMore = false;
          }
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasMore = false; // Desativa o carregamento em caso de erro
      });
      print("Erro ao carregar mais reviews: $e");
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreReviews();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF57362B),
      body: RefreshIndicator(
        onRefresh: _loadInitialReviews,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: Text(
                "Lecternus",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: const Color(0xFF57362B),
              actions: [
                IconButton(
                  icon: Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Config()),
                    );
                  },
                ),
              ],
              pinned: true,
            ),
            if (_isLoading && _reviews.isEmpty)
              SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == _reviews.length && _hasMore) {
                      //return _buildLoader(); // Mostra loader apenas se houver mais itens
                    }
                    if (index >= _reviews.length) {
                      return SizedBox
                          .shrink(); // Retorna widget vazio se não houver mais itens
                    }
                    return _buildReviewCard(_reviews[index]);
                  },
                  childCount:
                      _reviews.length + (_hasMore ? 1 : 0), // Ajusta a contagem
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(ReviewModel review) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Review(reviewText: review.reviewText),
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
                  backgroundImage: AssetImage(review.userImage),
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
                    Text('${review.likes}'),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(
                        Icons.mode_comment_outlined,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () => _showComments(review.id),
                    ),
                    Text('${review.comments}'),
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
                  onPressed: () => _followUser(review.userId),
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

  /*Widget _buildLoader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }*/

  void _likeReview(String reviewId) {
    setState(() {
      final index = _reviews.indexWhere((r) => r.id == reviewId);
      if (index != -1) {
        _reviews[index] =
            _reviews[index].copyWith(likes: _reviews[index].likes + 1);
      }
    });
  }

  void _showComments(String reviewId) {
    // Implementar navegação para tela de comentários
    print("Mostrar comentários da review $reviewId");
  }

  void _shareReview(ReviewModel review) {
    // Implementar compartilhamento
    print("Compartilhar review: ${review.id}");
  }

  void _followUser(String userId) {
    // Implementar lógica de seguir usuário
    print("Seguir usuário $userId");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// Adicione esta extensão ao seu ReviewModel ou no mesmo arquivo do modelo
extension ReviewModelExtension on ReviewModel {
  ReviewModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userImage,
    String? bookTitle,
    String? reviewText,
    DateTime? date,
    int? likes,
    int? comments,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      bookTitle: bookTitle ?? this.bookTitle,
      reviewText: reviewText ?? this.reviewText,
      date: date ?? this.date,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
    );
  }
}
