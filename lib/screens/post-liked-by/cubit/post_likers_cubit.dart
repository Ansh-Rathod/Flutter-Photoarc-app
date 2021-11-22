import 'package:bloc/bloc.dart';
import '../../../models/user_model.dart';
import '../../../repo/update_likes.dart';

part 'post_likers_state.dart';

class PostLikersCubit extends Cubit<PostLikersState> {
  PostLikersCubit() : super(PostLikersState.initial());
  final repo = UpdateLikes();
  void getLikers(
    String userId,
    String postId,
  ) async {
    try {
      emit(state.copyWith(status: LoadingStauts.loading));

      final users = await repo.getLikes(userId, postId);
      emit(state.copyWith(users: users, status: LoadingStauts.loaded));
    } catch (e) {
      emit(state.copyWith(status: LoadingStauts.error));
    }
  }
}
