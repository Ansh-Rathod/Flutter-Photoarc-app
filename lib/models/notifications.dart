import 'post_model.dart';

class NotificationModel {
  NotificationModel({
    required this.notificationId,
    required this.comment,
    required this.postId,
    required this.type,
    required this.followerId,
    required this.timeAt,
    required this.username,
    required this.name,
    required this.avatarUrl,
  });
  late final String notificationId;
  late final String comment;
  late final String postId;
  late final String type;
  late final String followerId;
  late final String timeAt;
  late final String username;
  late final PostModel model;
  late final String name;
  late final String avatarUrl;

  NotificationModel.fromJson(json) {
    notificationId = json['notification_id'];
    comment = json['comment'] ?? '';
    postId = json['post_id'] ?? '';
    type = json['_type'] ?? '';
    followerId = json['follower_id'];
    timeAt = json['time_at'] ?? '';
    username = json['username'] ?? '';
    name = json['name'] ?? '';
    model = PostModel.fromJson(json);
    avatarUrl = json['avatar_url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    var _data = <String, dynamic>{};
    _data['notification_id'] = notificationId;
    _data['comment'] = comment;
    _data['post_id'] = postId;
    _data = model.toJson();
    _data['_type'] = type;
    _data['follower_id'] = followerId;
    _data['time_at'] = timeAt;
    _data['username'] = username;
    _data['name'] = name;
    _data['avatar_url'] = avatarUrl;
    return _data;
  }
}
