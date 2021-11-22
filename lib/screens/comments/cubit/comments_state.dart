part of 'comments_cubit.dart';

enum Status { loading, success, error, initial }

class CommentsState {
  final List<CommentModel> comments;
  final Status status;

  CommentsState({required this.comments, required this.status});
  factory CommentsState.initial() =>
      CommentsState(comments: [], status: Status.initial);

  CommentsState copyWith({
    List<CommentModel>? comments,
    Status? status,
  }) {
    return CommentsState(
      comments: comments ?? this.comments,
      status: status ?? this.status,
    );
  }
}
