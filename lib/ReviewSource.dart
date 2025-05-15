// ReviewSource.dart
import 'package:sqflite_common/sqlite_api.dart';
import 'package:lecternus/database_helper.dart';
import 'package:lecternus/ReviewModel.dart';

class ReviewSource {
  static Future<List<ReviewModel>> getAllReviews() async {
    final db = await DatabaseHelper().db;
    final result = await db.rawQuery('''
      SELECT r.*, p.tag
      FROM Review r
      JOIN Profile p ON p.id_profile = r.id_profile
      ORDER BY r.id_review DESC
    ''');

    return result.map((map) => ReviewModel.fromMap(map)).toList();
  }
}
