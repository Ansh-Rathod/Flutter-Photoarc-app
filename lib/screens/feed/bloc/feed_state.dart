part of 'feed_bloc.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<PostModel> posts;
  final List<UserModel> users;
  const FeedLoaded({
    required this.users,
    required this.posts,
  });
}

class FeedError extends FeedState {}
