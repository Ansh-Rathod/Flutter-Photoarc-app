import 'dart:convert';

import '../api/url.dart';
import '../models/error_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

import 'package:http/http.dart' as http;
import 'genrate_user_id.dart';

class GetUserInfo {
  Future<UserModel> getUserInfo(String id) async {
    var res = await http.get(
        Uri.parse(
          BASE_URL + '/user/' + genrateId(id),
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });
    // print(res.statusCode);
    if (res.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(res.body)['results'][0]);
    } else {
      throw ErrorModel(code: "404", message: 'Something wents wrong.');
    }
  }

  Future<List<PostModel>> getUserPosts(String id) async {
    // print(id.toLowerCase());
    var res = await http.get(
        Uri.parse(
          BASE_URL + '/post/' + genrateId(id),
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

  Future<List<UserModel>> getSearchedUsers(String query) async {
    var res = await http.get(
      Uri.parse(
        BASE_URL + '/search?q=' + query,
      ),
    );
    if (res.statusCode == 200) {
      return (jsonDecode(res.body)['results'] as List)
          .map<UserModel>((user) => UserModel.fromJson(user))
          .toList();
    } else {
      throw ErrorModel(code: "404", message: 'Something wents wrong.');
    }
  }

  Future<List<UserModel>> getFollowers(String uid) async {
    var res = await http.get(
      Uri.parse(
        BASE_URL + '/user/followers/' + uid,
      ),
    );
    // print(res.statusCode);

    if (res.statusCode == 200) {
      return (jsonDecode(res.body)['results'] as List)
          .map<UserModel>((user) => UserModel.fromJson(user))
          .toList();
    } else {
      throw ErrorModel(code: "404", message: 'Something wents wrong.');
    }
  }

  Future<List<UserModel>> getFollowing(String uid) async {
    var res = await http.get(
      Uri.parse(
        BASE_URL + '/user/following/' + uid,
      ),
    );
    // print(res.statusCode);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body)['results'] as List)
          .map<UserModel>((user) => UserModel.fromJson(user))
          .toList();
    } else {
      throw ErrorModel(code: "404", message: 'Something wents wrong.');
    }
  }
}
