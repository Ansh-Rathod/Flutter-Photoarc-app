import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/comment_model.dart';
import '../../../models/user_model.dart';
import '../../../repo/comments.dart';
import '../../../repo/genrate_user_id.dart';

part 'comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  CommentsCubit() : super(CommentsState.initial());
  final repo = CommentsRepo();

  void init({required String userid, required String postId}) async {
    emit(state.copyWith(status: Status.loading));
    final body = await repo.getComments(userid, postId);
    emit(state.copyWith(comments: body, status: Status.success));
  }

  void addComment({
    required UserModel currentUser,
    required String userId,
    required String postId,
    required String comment,
  }) async {
    state.comments.add(CommentModel(
      postId: postId,
      comment: comment,
      name: currentUser.name,
      avatarUrl: currentUser.avatarUrl,
      commentCreatedAt: DateTime.now().toString(),
      commenterUserId: currentUser.id,
      commentId: '',
      username: currentUser.username,
    ));
    emit(state.copyWith(status: Status.success));
    await repo.addComment(
      userId: userId,
      postId: postId,
      comment: comment,
      commenterUserId: genrateId(FirebaseAuth.instance.currentUser!.uid),
    );
  }

  void deleteComment(String userId, String commentId, int index) async {
    state.comments.removeAt(index);
    emit(state.copyWith(comments: state.comments));
    await repo.deleteComments(userId, commentId);
    // print(rresult);
  }
}
