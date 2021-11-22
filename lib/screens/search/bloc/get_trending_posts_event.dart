part of 'get_trending_posts_bloc.dart';

abstract class GetTrendingPostsEvent extends Equatable {
  const GetTrendingPostsEvent();

  @override
  List<Object> get props => [];
}

class LoadGetTrendingPosts extends GetTrendingPostsEvent {}
