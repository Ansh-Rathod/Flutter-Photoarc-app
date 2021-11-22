part of 'event_button_cubit.dart';

enum EventStatus {
  loading,
  loaded,
  error,
}

class EventButtonState {
  final EventStatus status;
  final bool? isFollowing;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final UserModel currentUser;
  final String currentProfileId;
  final bool isCurrentUser;
  final UserModel currentProfile;
  const EventButtonState(
    this.status,
    this.isFollowing,
    this.followersCount,
    this.followingCount,
    this.postsCount,
    this.currentUser,
    this.currentProfileId,
    this.isCurrentUser,
    this.currentProfile,
  );

  factory EventButtonState.initial() {
    return EventButtonState(
      EventStatus.loaded,
      null,
      0,
      0,
      0,
      UserModel(
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
      '',
      false,
      UserModel(
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
    );
  }

  EventButtonState copyWith({
    EventStatus? status,
    bool? isFollowing,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    UserModel? currentUser,
    String? currentProfileId,
    bool? isCurrentUser,
    UserModel? currentProfile,
  }) {
    return EventButtonState(
      status ?? this.status,
      isFollowing ?? this.isFollowing,
      followersCount ?? this.followersCount,
      followingCount ?? this.followingCount,
      postsCount ?? this.postsCount,
      currentUser ?? this.currentUser,
      currentProfileId ?? this.currentProfileId,
      isCurrentUser ?? this.isCurrentUser,
      currentProfile ?? this.currentProfile,
    );
  }
}
