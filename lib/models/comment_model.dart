class CommentModel {
  CommentModel({
    required this.commenterUserId,
    required this.postId,
    required this.comment,
    required this.commentCreatedAt,
    required this.commentId,
    required this.username,
    required this.name,
    required this.avatarUrl,
  });
  late final String commenterUserId;
  late final String postId;
  late final String comment;
  late final String commentCreatedAt;
  late final String commentId;
  late final String username;
  late final String name;
  late final String avatarUrl;

  CommentModel.fromJson(Map<String, dynamic> json) {
    commenterUserId = json['commenter_user_id'];
    postId = json['post_id'];
    comment = json['comment'];
    commentCreatedAt = json['comment_created_at'];
    commentId = json['comment_id'];
    username = json['username'];
    name = json['name'];
    avatarUrl = json['avatar_url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['commenter_user_id'] = commenterUserId;
    _data['post_id'] = postId;
    _data['comment'] = comment;
    _data['comment_created_at'] = commentCreatedAt;
    _data['comment_id'] = commentId;
    _data['username'] = username;
    _data['name'] = name;
    _data['avatar_url'] = avatarUrl;
    return _data;
  }
}
