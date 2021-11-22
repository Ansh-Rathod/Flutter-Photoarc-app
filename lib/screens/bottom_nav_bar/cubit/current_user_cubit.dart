import 'package:bloc/bloc.dart';
// import 'package:social_media/logger.dart';
import 'package:social_media/models/user_model.dart';
import 'package:social_media/repo/user_repo.dart';

part 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  CurrentUserCubit() : super(CurrentUserState.initial());

  void setCurrentUser(String uid) async {
    final repo = GetUserInfo();

    try {
      emit(state.copyWith(status: CurrentUserStatus.loading));
      final user = await repo.getUserInfo(uid);
      // logger.d(user.toJson());
      emit(state.copyWith(status: CurrentUserStatus.loaded, user: user));
    } catch (e) {
      emit(state.copyWith(status: CurrentUserStatus.error));
    }
  }
}
