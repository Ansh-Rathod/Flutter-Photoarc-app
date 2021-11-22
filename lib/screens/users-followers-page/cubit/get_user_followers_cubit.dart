import 'package:bloc/bloc.dart';
import '../../../models/user_model.dart';
import '../../../repo/user_repo.dart';

part 'get_user_followers_state.dart';

class GetUserFollowersCubit extends Cubit<GetUserFollowersState> {
  GetUserFollowersCubit() : super(GetUserFollowersState.initial());
  final repo = GetUserInfo();
  Future<void> init(String uid) async {
    try {
      emit(state.copyWith(status: LoadingStauts.loading));
      final followers = await repo.getFollowers(uid);
      final followering = await repo.getFollowing(uid);
      emit(state.copyWith(
        status: LoadingStauts.loaded,
        followers: followers,
        followings: followering,
      ));
    } catch (e) {
      emit(state.copyWith(status: LoadingStauts.error));
    }
  }
}
