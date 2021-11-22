import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/url.dart';
import '../models/comment_model.dart';
import 'genrate_user_id.dart';
import 'package:uuid/uuid.dart';

class CommentsRepo {
  Future<void> addComment({
    required String userId,
    required String postId,
    required String commenterUserId,
    required String comment,
  }) async {
    var info = {
      "user_id": userId,
      "post_id": postId,
      "commenter_user_id": commenterUserId,
      "comment": comment,
      "comment_created_at": DateTime.now().toString(),
      "comment_id": const Uuid().v1(),
    };
    await http.post(
      Uri.parse(BASE_URL + '/post/comments/create-comment'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(info),
    );
    // var body = jsonDecode(res.body);
    // print(body);
  }

  Future<List<CommentModel>> getComments(String userId, String postId) async {
    var res = await http.post(Uri.parse(BASE_URL + '/post/comments/all'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "user_id": userId,
          "post_id": postId,
        }));
    var body = jsonDecode(res.body);
    return (body['results'] as List)
        .map((comment) => CommentModel.fromJson(comment))
        .toList();
  }

  Future<bool> deleteComments(String userId, String commentId) async {
    var res = await http.delete(
      Uri.parse(BASE_URL +
          '/post/comments/${genrateId(userId)}?comment_id=$commentId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    // var body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
