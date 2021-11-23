part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationsEvent {
  final String userId;

  const LoadNotifications({required this.userId});

  @override
  List<Object> get props => [userId];
}

class DeleteNotifications extends NotificationsEvent {
  final String userId;
  final String notificationId;
  const DeleteNotifications({
    required this.userId,
    required this.notificationId,
  });
}

class DeleteAllNotifications extends NotificationsEvent {
  final String userId;
  const DeleteAllNotifications({required this.userId});
}
