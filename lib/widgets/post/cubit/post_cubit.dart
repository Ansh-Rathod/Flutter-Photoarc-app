import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/post_model.dart';
import '../../../repo/genrate_user_id.dart';
import '../../../repo/update_likes.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostState.initial());
  final repo = UpdateLikes();
  var uid = genrateId(FirebaseAuth.instance.currentUser!.uid);
  void init(PostModel post) {
    // print(uid);
    // print(post.postId);
    if (post.likes.contains(uid)) {
      emit(state.copyWith(isLiked: true));
    }
    emit(state.copyWith(likes: post.likes.length, post: post));
  }

  void like() async {
    emit(state.copyWith(isLiked: !state.isLiked));
    var post = state.post;
    if (state.isLiked) {
      state.post.likes.add(uid);
      emit(state.copyWith(likes: post.likes.length));
      await repo.addLike(post.userId, post.postId, uid);
    } else {
      state.post.likes.remove(uid);
      emit(state.copyWith(likes: post.likes.length));

      await repo.removelike(post.userId, post.postId, uid);
    }
  }

  void deletePost(String uId, String postId) async {
    emit(state.copyWith(isDeleted: true));
    await repo.deletePost(uId, postId);

    // print(res);
  }
}
