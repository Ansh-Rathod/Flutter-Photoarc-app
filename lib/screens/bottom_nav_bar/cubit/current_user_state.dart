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
  final bool isNote;
  const CurrentUserState({
    required this.user,
    required this.status,
    required this.isNote,
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
        isNote: false,
      );

  CurrentUserState copyWith({
    UserModel? user,
    CurrentUserStatus? status,
    bool? isNote,
  }) {
    return CurrentUserState(
      user: user ?? this.user,
      status: status ?? this.status,
      isNote: isNote ?? this.isNote,
    );
  }
}
