import 'package:flutter/material.dart';
import 'package:lecternus/ReviewModel.dart';
import 'package:lecternus/Config.dart';
import 'package:uuid/uuid.dart';

class Comment {
  final String id;
  final String text;
  final String userName;
  final String? parentId;

  Comment({
    required this.id,
    required this.text,
    required this.userName,
    this.parentId,
  });
}

class ReviewPage extends StatefulWidget {
  final ReviewModel review;

  const ReviewPage({super.key, required this.review});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  bool liked = false;
  int likeCount = 0;
  final TextEditingController _commentController = TextEditingController();
  List<Comment> comments = [];
  String? replyingToId;
  String? replyingToUser;
  Set<String> expandedCommentIds = {};

  void _handleLike() {
    if (!liked) {
      setState(() {
        liked = true;
        likeCount++;
      });
    }
    // Esqueleto para integração futura com backend (Azure)==============================================
    /*
  final String reviewId = widget.review.id;
  final String apiUrl = 'https://seu-backend.azurewebsites.net/api/likes';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'reviewId': reviewId,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        liked = true;
        likeCount++;
      });
    } else if (response.statusCode == 409) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Você já curtiu esta review.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao curtir. Tente novamente.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro de rede: $e')),
    );
  }
  */
  }

  void _sendComment() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        comments.add(Comment(
          id: Uuid().v4(),
          text: text,
          userName: 'Você',
          parentId: replyingToId,
        ));
        _commentController.clear();
        replyingToId = null;
        replyingToUser = null;
      });

      // Esqueleto para integração futura com backend (Azure) =====================
      /*
    final String apiUrl = 'https://seu-backend.azurewebsites.net/api/comments';
    final String commentId = Uuid().v4(); // ID único para o comentário
    final String userId = 'user123'; // Substitua com ID do usuário autenticado
    final String reviewId = widget.review.id; // ID da review sendo comentada

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': commentId,
          'text': text,
          'userId': userId,
          'userName': 'Você',
          'reviewId': reviewId,
          'parentId': replyingToId,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        // Comentário salvo com sucesso no backend
      } else {
        // Trate erros aqui
        print('Erro ao salvar comentário: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro de rede: $e');
    }
    */
    }
  }

  void _replyToComment(String commentId, String userName) {
    setState(() {
      replyingToId = commentId;
      replyingToUser = userName;
    });
  }

  void _cancelReply() {
    setState(() {
      replyingToId = null;
      replyingToUser = null;
    });
  }

  List<Comment> _getReplies(String parentId) {
    return comments.where((c) => c.parentId == parentId).toList();
  }

  Widget _buildComment(Comment comment, {int depth = 0}) {
    final hasReplies = _getReplies(comment.id).isNotEmpty;
    final isExpanded = expandedCommentIds.contains(comment.id);

    return Padding(
      padding: EdgeInsets.only(left: depth * 20.0, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('@${comment.userName}',
                    style: TextStyle(color: Colors.white70)),
                SizedBox(height: 4),
                Text(comment.text, style: TextStyle(color: Colors.white)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () =>
                          _replyToComment(comment.id, comment.userName),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Responder',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (hasReplies)
                      IconButton(
                        icon: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.white70,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isExpanded) {
                              expandedCommentIds.remove(comment.id);
                            } else {
                              expandedCommentIds.add(comment.id);
                            }
                          });
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (isExpanded)
            ..._getReplies(comment.id).map(
              (c) => _buildComment(c, depth: depth + 1),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final review = widget.review;
    final topLevelComments = comments.where((c) => c.parentId == null).toList();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF57362B),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Lecternus",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
      ),
      backgroundColor: const Color(0xFF57362B),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Parte superior com imagem e info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: review.imageBlob != null && review.imageBlob!.isNotEmpty
      ? Image.memory(
          review.imageBlob!,
          width: 80,
          height: 100,
          fit: BoxFit.cover,
        )
      : Image.asset(
          'assets/images/imagem.jpg',
          width: 80,
          height: 100,
          fit: BoxFit.cover,
        ),
),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Livro: ${review.bookTitle}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Autor: ${review.bookAuthor}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '@${review.userName}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white54,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            onPressed: liked ? null : _handleLike,
                            icon: Icon(
                              liked ? Icons.favorite : Icons.favorite_border,
                              color: liked ? Colors.red : Colors.white,
                            ),
                          ),
                          Text(
                            '$likeCount curtidas',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Comentários (${comments.length})',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Título da review
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                review.reviewTitle,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),

            // Texto da review
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                review.reviewText,
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 20),

            // Lista de comentários
            if (comments.isNotEmpty)
              Expanded(
                child: ListView(
                  children: topLevelComments
                      .map((comment) => _buildComment(comment))
                      .toList(),
                ),
              )
            else
              Expanded(child: Container()),

            // Campo de comentário ou resposta
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (replyingToUser != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 4),
                      child: Row(
                        children: [
                          Text(
                            'Respondendo a @$replyingToUser',
                            style: TextStyle(color: Colors.brown),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: IconButton(
                              icon: Icon(Icons.close,
                                  size: 22, color: Colors.red),
                              onPressed: _cancelReply,
                              constraints: BoxConstraints(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: replyingToUser != null
                                ? 'Escreva uma resposta...'
                                : 'Escreva um comentário...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.brown[800]),
                        onPressed: _sendComment,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
