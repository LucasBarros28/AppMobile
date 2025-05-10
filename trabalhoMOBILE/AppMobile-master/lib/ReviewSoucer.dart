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

class ReviewSource {
  // No futuro, isso pode ser substituído por chamadas a uma API ou Firebase
  static final List<ReviewModel> _reviews = [
    ReviewModel(
      id: '1',
      userId: 'user1',
      userName: 'Alex Marques',
      userImage: 'assets/images/profile.webp',
      bookTitle: 'Mar Azul',
      reviewText: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
      date: DateTime.now(),
      likes: 10,
      comments: 3,
    ),
    // Adicione mais reviews de exemplo aqui
  ];

  // Método para obter todas as reviews
  static Future<List<ReviewModel>> getAllReviews() async {
    // Simulando uma chamada assíncrona
    await Future.delayed(Duration(milliseconds: 500));
    return _reviews;
  }

  // Método para adicionar uma nova review
  static Future<void> addReview(ReviewModel review) async {
    await Future.delayed(Duration(milliseconds: 300));
    _reviews.insert(0, review); // Adiciona no início da lista
  }

  // Método para buscar mais reviews (paginção)
  static Future<List<ReviewModel>> loadMoreReviews(int currentCount) async {
    await Future.delayed(Duration(seconds: 1));
    // Simulando carregamento de mais itens
    final newReviews = List.generate(
        5,
        (index) => ReviewModel(
              id: '${currentCount + index + 1}',
              userId: 'user${currentCount + index + 1}',
              userName: 'Usuário ${currentCount + index + 1}',
              userImage: 'assets/images/profile.webp',
              bookTitle: 'Livro ${currentCount + index + 1}',
              reviewText: 'Review de exemplo ${currentCount + index + 1}...',
              date: DateTime.now(),
              likes: 0,
              comments: 0,
            ));
    return newReviews;
  }
}
