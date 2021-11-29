import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:social_media/logger.dart';
import '../api/url.dart';
import '../models/user_model.dart';
import 'genrate_user_id.dart';

// import '../logger.dart';

class UpdateLikes {
  Future<void> addLike(String uid, String postid, String likerid) async {
    var res = await http.put(Uri.parse(BASE_URL + '/post/like'),
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode({
          "user_id": uid,
          "liker_id": likerid,
          "time_at": DateTime.now().toString(),
          "post_id": postid,
        }));
    logger.d(jsonDecode(res.body));
  }

  Future<void> removelike(String uid, String postid, String likerid) async {
    var res = await http.put(Uri.parse(BASE_URL + '/post/unlike'),
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode({
          "user_id": uid,
          "liker_id": likerid,
          "post_id": postid,
        }));
    logger.d(jsonDecode(res.body));
  }

  Future<List<UserModel>> getLikes(String uid, String postid) async {
    var res = await http.post(Uri.parse(BASE_URL + '/post/likes'),
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode({
          "user_id": uid,
          "post_id": postid,
        }));
    // logger.d(jsonDecode(res.body));

    return (jsonDecode(res.body)['results'] as List)
        .map((e) => UserModel.fromJson(e))
        .toList();
  }

  Future<bool> deletePost(String uId, String postId) async {
    var res = await http.delete(
      Uri.parse(BASE_URL + '/post/${genrateId(uId)}?post_id=$postId'),
      headers: {
        'content-type': 'application/json',
      },
    );
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
