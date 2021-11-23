import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
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
          notifications.sort((a, b) => b['time_at'].compareTo(a['time_at']));
          var box = Hive.box('notifications');

          for (var i = 0; i < notifications.length; i++) {
            box.put(notifications[i]['notification_id'], notifications[i]);
          }
          print(box.length);
          emit(NotificationsLoaded(
            old: box,
          ));
        } catch (e) {
          // print(e.toString());
          emit(NotificationsError());
        }
      } else if (event is DeleteNotifications) {
        var box = Hive.box('notifications');
        box.delete(event.notificationId);

        // print(del);
      } else if (event is DeleteAllNotifications) {
        var res = await repo.deleteNotifications(event.userId);
        print(res);
      }
    });
  }
}
