part of 'get_trending_posts_bloc.dart';

abstract class GetTrendingPostsState extends Equatable {
  const GetTrendingPostsState();

  @override
  List<Object> get props => [];
}

class GetTrendingPostsInitial extends GetTrendingPostsState {}

class GetTrendingPostsLoading extends GetTrendingPostsState {}

class GetTrendingPostsLoaded extends GetTrendingPostsState {
  final List<PostModel> posts;

  const GetTrendingPostsLoaded({
    required this.posts,
  });
}

class GetTrendingPostsError extends GetTrendingPostsState {}
