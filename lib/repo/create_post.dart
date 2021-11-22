import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../api/url.dart';
import 'genrate_user_id.dart';
import 'package:uuid/uuid.dart';

class CreatePost {
  var uuid = const Uuid();
  Future<int> uploadPost({
    required String uid,
    required String caption,
    required String url,
    required int width,
    required int height,
  }) async {
    var info = {
      "post_id": uuid.v1(),
      "post_image_url": url,
      "caption": caption,
      "user_id": genrateId(uid),
      "created_at": DateTime.now().toString(),
      "width": width,
      "height": height
    };

    var response = await http.post(
      Uri.parse(BASE_URL + '/post/create-post'),
      headers: {
        'content-type': 'application/json',
      },
      body: jsonEncode(info),
    );
    // print(response.statusCode);
    return response.statusCode;
  }

  Future<dynamic> uploadImage(File file) async {
    var data = await http.MultipartFile.fromPath('picture', file.path);

    var res =
        http.MultipartRequest('PUT', Uri.parse(BASE_URL + '/post/upload-post'))
          ..files.add(data);
    var response = await res.send();
    final respStr = await response.stream.bytesToString();
    // print(jsonDecode(respStr)['url']);
    return jsonDecode(respStr);
  }
}
