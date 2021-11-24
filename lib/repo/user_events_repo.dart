import 'dart:convert';

import 'package:http/http.dart' as http;
import '../api/url.dart';

class UserEvents {
  Future<bool> isfollowing(String userid, String followingid) async {
    var url = Uri.parse(BASE_URL +
        "/user/events/isfollow?userId=$userid&following=$followingid");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['isFollow'];
    } else {
      return false;
    }
  }

  Future<bool> follow(String userId, String followerId) async {
    var info = jsonEncode({
      "follower_id": followerId,
      "time_at": DateTime.now().toString(),
      "user_id": userId,
    });
    var url = Uri.parse(
      BASE_URL + "/user/events/follow",
    );
    var res = await http.put(url,
        headers: {"Content-Type": "application/json"}, body: info);
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> unfollow(String userId, String followerId) async {
    var info = jsonEncode({
      "follower_id": followerId,
      "user_id": userId,
    });
    var url = Uri.parse(
      BASE_URL + "/user/events/unfollow",
    );
    var res = await http.put(url,
        headers: {"Content-Type": "application/json"}, body: info);
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
