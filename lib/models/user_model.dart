class UserModel {
  final String id;
  final String username;
  final String name;
  final String bio;
  final String avatarUrl;
  final String url;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final String createdAt;
  UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.bio,
    required this.avatarUrl,
    required this.url,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      username: json['username'],
      name: json['name'],
      bio: json['bio'],
      avatarUrl: json['avatar_url'],
      url: json['url'],
      followersCount: json['followers_count'],
      followingCount: json['following_count'],
      postsCount: json['posts_count'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['username'] = username;
    _data['name'] = name;
    _data['bio'] = bio;
    _data['avatar_url'] = avatarUrl;
    _data['url'] = url;
    _data['followers_count'] = followersCount;
    _data['following_count'] = followingCount;
    _data['posts_count'] = postsCount;
    _data['created_at'] = createdAt;
    return _data;
  }
}
