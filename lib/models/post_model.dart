class PostModel {
  PostModel({
    required this.postId,
    required this.postImageUrl,
    required this.caption,
    required this.userId,
    required this.width,
    required this.height,
    required this.createdAt,
    required this.likes,
    required this.username,
    required this.name,
    required this.avatarUrl,
  });
  late final String postId;
  late final String postImageUrl;
  late final String caption;
  late final String userId;
  late final int width;
  late final int height;
  late final String createdAt;
  late final List<String> likes;
  late final String username;
  late final String name;
  late final String avatarUrl;

  PostModel.fromJson(json) {
    postId = json['post_id'] ?? '';
    postImageUrl = json['post_image_url'] ?? '';
    caption = json['caption'] ?? '';
    userId = json['user_id'] ?? '';
    createdAt = json['posted_at'] ?? '';
    likes = List.castFrom<dynamic, String>(json['likes'] ?? []);
    username = json['username'] ?? '';
    name = json['name'] ?? '';
    width = json['width'] ?? 00;
    height = json['height'] ?? 0;
    avatarUrl = json['avatar_url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['post_id'] = postId;
    _data['post_image_url'] = postImageUrl;
    _data['caption'] = caption;
    _data['user_id'] = userId;
    _data['posted_at'] = createdAt;
    _data['likes'] = likes;
    _data['height'] = height;
    _data['width'] = width;
    _data['username'] = username;
    _data['name'] = name;
    _data['avatar_url'] = avatarUrl;
    return _data;
  }
}
