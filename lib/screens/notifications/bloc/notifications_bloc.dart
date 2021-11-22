import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../models/notifications.dart';
import '../../../repo/get_notifications.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final repo = GetNotifications();
  NotificationsBloc() : super(NotificationsInitial()) {
    on<NotificationsEvent>((event, emit) async {
      if (event is LoadNotifications) {
        try {
          emit(NotificationsLoading());
          final notifications = await repo.getNotifications(event.userId);
          emit(NotificationsLoaded(notifications: notifications));
        } catch (e) {
          // print(e.toString());
          emit(NotificationsError());
        }
      } else if (event is DeleteNotifications) {
        await repo.deleteNotifications(event.userId, event.notificationId);
        // print(del);
      }
    });
  }
}
