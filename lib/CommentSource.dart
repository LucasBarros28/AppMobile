import 'package:lecternus/database_helper.dart';
import 'CommentModel.dart';
import 'package:sqflite/sqflite.dart';


class CommentSource {
  static Future<List<CommentModel>> getCommentsByReview(int reviewId) async {
    final db = await DatabaseHelper().db;
    final result = await db.query(
      'Comment',
      where: 'id_review = ?',
      whereArgs: [reviewId],
      orderBy: 'id_comment ASC',
    );

    return result.map((row) => CommentModel.fromMap(row)).toList();
  }

  static Future<void> insertComment(CommentModel comment) async {
    final db = await DatabaseHelper().db;

    // Obter o maior id_comment atual
    final result = await db.rawQuery('SELECT MAX(id_comment) + 1 as next_id FROM Comment');
    final nextId = result.first['next_id'] ?? 1;

    final commentWithId = comment.copyWith(id: nextId as int);
    await db.insert('Comment', commentWithId.toMap());
  }

  static Future<int> countByReviewId(int reviewId) async {
    final db = await DatabaseHelper().db;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM Comment WHERE id_review = ?',
      [reviewId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

}
