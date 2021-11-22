import 'dart:convert';

import '../api/url.dart';
import '../models/error_model.dart';
import '../models/post_model.dart';

import 'package:http/http.dart' as http;

class GetTrending {
  Future<List<PostModel>> getTrendingPosts() async {
    var res = await http.get(
        Uri.parse(
          BASE_URL + '/search/get_posts',
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
