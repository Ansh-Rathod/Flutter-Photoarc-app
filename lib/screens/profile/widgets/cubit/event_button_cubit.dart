import 'package:bloc/bloc.dart';
import '../../../../models/user_model.dart';
import '../../../../repo/genrate_user_id.dart';
import '../../../../repo/user_events_repo.dart';

part 'event_button_state.dart';

class EventButtonCubit extends Cubit<EventButtonState> {
  EventButtonCubit() : super(EventButtonState.initial());

  final repo = UserEvents();
  Future<void> init(
      {required UserModel user,
      required int followersCount,
      required int followingCount,
      required int postsCount,
      required UserModel currentProfile,
      required String currentProfileId}) async {
    emit(state.copyWith(
      followersCount: followersCount,
      followingCount: followingCount,
      isCurrentUser: user.id == genrateId(currentProfileId),
      postsCount: postsCount,
      currentProfileId: currentProfileId,
      currentProfile: currentProfile,
      currentUser: user,
    ));
    final isFollowing = await repo.isfollowing(user.id, currentProfileId);
    // print(isFollowing);
    emit(state.copyWith(
      isFollowing: isFollowing,
    ));
  }

  void follow() async {
    emit(
      state.copyWith(
        isFollowing: true,
        followersCount: state.followersCount + 1,
        status: EventStatus.loading,
      ),
    );

    var followed =
        await repo.follow(state.currentProfileId, state.currentUser.id);
    if (followed) {
      emit(state.copyWith(status: EventStatus.loaded));
    } else {
      emit(state.copyWith(status: EventStatus.error));
    }
  }

  void unfollow() async {
    emit(
      state.copyWith(
        isFollowing: false,
        followersCount: state.followersCount - 1,
        status: EventStatus.loading,
      ),
    );

    var unfollowed =
        await repo.unfollow(state.currentProfileId, state.currentUser.id);
    if (unfollowed) {
      emit(state.copyWith(status: EventStatus.loaded));
    } else {
      emit(state.copyWith(status: EventStatus.error));
    }
  }
}
