import 'dart:convert';

import 'package:http/http.dart' as http;
import '../api/url.dart';
import '../models/error_model.dart';
import '../models/notifications.dart';
import 'genrate_user_id.dart';

class GetNotifications {
  Future<List<NotificationModel>> getNotifications(String id) async {
    // print(id.toLowerCase());
    var res = await http.get(
        Uri.parse(
          BASE_URL + '/notifications/' + genrateId(id),
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });
    // print(res.statusCode);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body)['results'] as List)
          .map<NotificationModel>((post) => NotificationModel.fromJson(post))
          .toList();
    } else {
      throw ErrorModel(code: "404", message: 'Something wents wrong.');
    }
  }

  Future<bool> deleteNotifications(String userId, String notificationId) async {
    var res = await http.delete(
        Uri.parse(
          BASE_URL +
              '/notifications/${genrateId(userId)}?notification_id=$notificationId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });
    // print(res.statusCode);
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
