part of 'get_user_followers_cubit.dart';

enum LoadingStauts { loading, error, inital, loaded }

class GetUserFollowersState {
  final List<UserModel> followers;
  final List<UserModel> followings;
  final LoadingStauts status;
  GetUserFollowersState({
    required this.followers,
    required this.followings,
    required this.status,
  });
  factory GetUserFollowersState.initial() {
    return GetUserFollowersState(
      status: LoadingStauts.inital,
      followers: [],
      followings: [],
    );
  }
  GetUserFollowersState copyWith({
    List<UserModel>? followers,
    List<UserModel>? followings,
    LoadingStauts? status,
  }) {
    return GetUserFollowersState(
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      status: status ?? this.status,
    );
  }
}
