part of 'getposts_bloc.dart';

abstract class GetProfileEvent extends Equatable {
  const GetProfileEvent();

  @override
  List<Object> get props => [];
}

class GetUsesrPostsEvent extends GetProfileEvent {
  final String uid;
  const GetUsesrPostsEvent({
    required this.uid,
  });
}

class UnFollowEvent extends GetProfileEvent {
  final String uid;
  const UnFollowEvent({
    required this.uid,
  });
}

class FollowEvent extends GetProfileEvent {
  final String uid;
  const FollowEvent({
    required this.uid,
  });
}
