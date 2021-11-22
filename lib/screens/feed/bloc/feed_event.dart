part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class LoadFeed extends FeedEvent {
  final String userId;

  const LoadFeed({required this.userId});

  @override
  List<Object> get props => [userId];
}
