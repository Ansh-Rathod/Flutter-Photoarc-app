part of 'current_user_cubit.dart';

enum CurrentUserStatus {
  initial,
  loading,
  loaded,
  error,
}

class CurrentUserState {
  final UserModel user;
  final CurrentUserStatus status;
  const CurrentUserState({
    required this.user,
    required this.status,
  });

  factory CurrentUserState.initial() => CurrentUserState(
        user: UserModel(
          id: '',
          username: '',
          name: '',
          bio: '',
          avatarUrl: '',
          url: '',
          followersCount: 0,
          followingCount: 0,
          postsCount: 0,
          createdAt: '',
        ),
        status: CurrentUserStatus.initial,
      );

  CurrentUserState copyWith({
    UserModel? user,
    CurrentUserStatus? status,
  }) {
    return CurrentUserState(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }
}
