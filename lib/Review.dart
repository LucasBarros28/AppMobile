
import 'package:flutter/material.dart';
import 'package:lecternus/ReviewModel.dart';
import 'package:lecternus/Config.dart';
import 'package:lecternus/CommentModel.dart';
import 'package:lecternus/CommentSource.dart';
import 'package:lecternus/ReviewSource.dart';

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
  List<CommentModel> comments = [];
  String? replyingToId;
  String? replyingToUser;
  Set<int> expandedCommentIds = {};

  @override
  void initState() {
    super.initState();
    likeCount = widget.review.likes;
    _loadComments();
  }

  Future<void> _loadComments() async {
    final loaded = await CommentSource.getCommentsByReview(widget.review.id);
    setState(() {
      comments = loaded;
    });
  }

  void _handleLike() async {
    if (!liked) {
      setState(() {
        liked = true;
        likeCount++;
      });
      await ReviewSource.updateLikes(widget.review.id, likeCount);
    }
  }

  void _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      await CommentSource.insertComment(CommentModel(
        reviewId: widget.review.id,
        profileId: widget.review.profileId,
        content: text,
        parentId: replyingToId != null ? int.tryParse(replyingToId!) : null,
        likes: 0,
      ));
      _commentController.clear();
      replyingToId = null;
      replyingToUser = null;
      _loadComments();
    }
  }

  void _replyToComment(int commentId, String userName) {
    setState(() {
      replyingToId = commentId.toString();
      replyingToUser = userName;
    });
  }

  void _cancelReply() {
    setState(() {
      replyingToId = null;
      replyingToUser = null;
    });
  }

  List<CommentModel> _getReplies(int parentId) {
    return comments.where((c) => c.parentId == parentId).toList();
  }

  Widget _buildComment(CommentModel comment, {int depth = 0}) {
    final hasReplies = _getReplies(comment.id!).isNotEmpty;
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
                Text('@usuário', style: TextStyle(color: Colors.white70)),
                SizedBox(height: 4),
                Text(comment.content, style: TextStyle(color: Colors.white)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _replyToComment(comment.id!, 'usuário'),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text('Responder',
                          style:
                              TextStyle(fontSize: 12, color: Colors.black)),
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
                              expandedCommentIds.remove(comment.id!);
                            } else {
                              expandedCommentIds.add(comment.id!);
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
            ..._getReplies(comment.id!)
                .map((c) => _buildComment(c, depth: depth + 1)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final review = widget.review;
    final topLevelComments = comments.where((c) => c.parentId == null).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF57362B),
        title: Text('Lecternus',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
          )
        ],
      ),
      backgroundColor: const Color(0xFF57362B),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
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
                  child: review.imageBlob != null && review.imageBlob!.isNotEmpty
                      ? Image.memory(review.imageBlob!, fit: BoxFit.cover)
                      : Image.asset('assets/images/imagem.jpg',
                          fit: BoxFit.cover),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Livro: ${review.bookTitle}',
                          style:
                              TextStyle(fontSize: 18, color: Colors.white)),
                      SizedBox(height: 8),
                      Text('Autor: ${review.bookAuthor}',
                          style:
                              TextStyle(fontSize: 16, color: Colors.white70)),
                      SizedBox(height: 8),
                      Text('@${review.userName}',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white54,
                              fontStyle: FontStyle.italic)),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            onPressed: liked ? null : _handleLike,
                            icon: Icon(
                              liked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: liked ? Colors.red : Colors.white,
                            ),
                          ),
                          Text('$likeCount curtidas',
                              style: TextStyle(color: Colors.white70))
                        ],
                      ),
                      SizedBox(height: 12),
                      Text('Comentários (${comments.length})',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(review.reviewTitle,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(review.reviewText,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.left),
            ),
            SizedBox(height: 20),
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
                          Text('Respondendo a @$replyingToUser',
                              style: TextStyle(color: Colors.brown)),
                          IconButton(
                            icon: Icon(Icons.close,
                                size: 22, color: Colors.red),
                            onPressed: _cancelReply,
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
