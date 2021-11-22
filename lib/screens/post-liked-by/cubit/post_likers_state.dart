part of 'post_likers_cubit.dart';

enum LoadingStauts { loading, error, inital, loaded }

class PostLikersState {
  final List<UserModel> users;
  final LoadingStauts status;
  const PostLikersState({
    required this.users,
    required this.status,
  });

  factory PostLikersState.initial() {
    return const PostLikersState(users: [], status: LoadingStauts.inital);
  }

  PostLikersState copyWith({
    List<UserModel>? users,
    LoadingStauts? status,
  }) {
    return PostLikersState(
      users: users ?? this.users,
      status: status ?? this.status,
    );
  }
}
