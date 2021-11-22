import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import '../api/url.dart';
// import 'package:social_media/logger.dart';
import 'package:social_media/repo/genrate_user_id.dart';

class CreateUserRepo {
  Future<int> createUser({
    required String name,
    required String id,
    required String website,
    required String bio,
  }) async {
    var info = {
      "id": genrateId(id),
      "username": name.replaceAll(' ', '') + Random().nextInt(400).toString(),
      "name": name,
      "bio": bio,
      "url": website,
      "avatar_url": "",
      "created_at": DateTime.now().toString(),
    };

    // logger.d(info);

    var res = await http.post(
      Uri.parse(BASE_URL + "/user/create-user"),
      headers: {
        'content-type': 'application/json',
      },
      body: jsonEncode(info),
    );
    // print(jsonDecode(res.body));
    return res.statusCode;
  }

  Future<int> updateUser({
    required String name,
    required String id,
    required String website,
    required String bio,
  }) async {
    var info = {
      "id": genrateId(id),
      "username": name.replaceAll(' ', '') + Random().nextInt(400).toString(),
      "name": name,
      "bio": bio,
      "url": website,
    };

    // logger.d(info);

    var res = await http.put(
      Uri.parse(BASE_URL + "/user/${genrateId(id)}"),
      headers: {
        'content-type': 'application/json',
      },
      body: jsonEncode(info),
    );
    // print(jsonDecode(res.body));
    return res.statusCode;
  }

  Future<int> uploadImage(File file, String id) async {
    var data = await http.MultipartFile.fromPath('picture', file.path);

    var res = http.MultipartRequest(
        'PUT',
        Uri.parse(
          BASE_URL + '/user/upload-profile/' + genrateId(id),
        ))
      ..files.add(data);
    var response = await res.send();
    await response.stream.bytesToString();
    // print(jsonDecode(respStr));
    return response.statusCode;
  }
}
