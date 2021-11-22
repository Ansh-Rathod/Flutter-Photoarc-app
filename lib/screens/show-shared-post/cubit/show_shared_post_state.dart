part of 'show_shared_post_cubit.dart';

// ignore: constant_identifier_names
enum LoadingStatus { loading, inital, loaded, failed, not_found }

class ShowSharedPostState {
  final PostModel post;
  final LoadingStatus status;
  ShowSharedPostState({
    required this.post,
    required this.status,
  });
  factory ShowSharedPostState.initial() => ShowSharedPostState(
        post: PostModel(
          avatarUrl: '',
          caption: '',
          width: 500,
          height: 500,
          createdAt: '',
          likes: [],
          name: '',
          postId: '',
          postImageUrl: '',
          userId: '',
          username: '',
        ),
        status: LoadingStatus.inital,
      );

  ShowSharedPostState copyWith({
    PostModel? post,
    LoadingStatus? status,
  }) {
    return ShowSharedPostState(
      post: post ?? this.post,
      status: status ?? this.status,
    );
  }
}
