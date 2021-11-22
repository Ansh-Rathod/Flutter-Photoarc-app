import 'dart:convert';

import 'package:http/http.dart' as http;
import '../api/url.dart';
import '../models/error_model.dart';

import '../models/post_model.dart';
import 'genrate_user_id.dart';

class GetFeedPosts {
  Future<List<PostModel>> getUserPosts(String id) async {
    // print(id.toLowerCase());
    var res = await http.get(
        Uri.parse(
          BASE_URL + '/feed/?user_id=' + genrateId(id),
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });
    // print(res.statusCode);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body)['results'] as List)
          .map<PostModel>((post) => PostModel.fromJson(post))
          .toList();
    } else {
      throw ErrorModel(code: "404", message: 'Something wents wrong.');
    }
  }
}
