import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../models/post_model.dart';
import '../../../repo/get_search.dart';

part 'get_trending_posts_event.dart';
part 'get_trending_posts_state.dart';

class GetTrendingPostsBloc
    extends Bloc<GetTrendingPostsEvent, GetTrendingPostsState> {
  final repo = GetTrending();
  GetTrendingPostsBloc() : super(GetTrendingPostsInitial()) {
    on<GetTrendingPostsEvent>((event, emit) async {
      if (event is LoadGetTrendingPosts) {
        try {
          emit(GetTrendingPostsLoading());
          final posts = await repo.getTrendingPosts();
          posts.sort((a, b) {
            return b.createdAt.compareTo(a.createdAt);
          });
          // print(posts.length);
          emit(GetTrendingPostsLoaded(
            posts: posts,
          ));
        } catch (e) {
          emit(GetTrendingPostsError());
        }
      }
    });
  }
}
// 
// 0 to 
// 