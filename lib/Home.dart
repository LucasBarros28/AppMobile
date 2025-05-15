// Home.dart
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
                return Card(
                  color: Color(0xFFCDA68C),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewPage(review: review),
                        ),
                      );
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (review.userName.isNotEmpty)
                          Text(
                            '@${review.userName}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF57362B),
                            ),
                          ),
                        SizedBox(height: 4),
                        Text(
                          review.reviewTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF57362B),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Livro: ${review.bookTitle}',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF57362B),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          review.reviewText.length > 100
                              ? '${review.reviewText.substring(0, 100)}...'
                              : review.reviewText,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF57362B),
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFF57362B)),
                  ),
                );
              },
            ),
    );
  }
}
