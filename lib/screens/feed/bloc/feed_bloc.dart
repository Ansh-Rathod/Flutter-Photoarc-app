import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../../repo/get_feed_posts.dart';
import '../../../repo/user_repo.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final repo = GetFeedPosts();
  final suggested = GetUserInfo();
  FeedBloc() : super(FeedInitial()) {
    on<FeedEvent>((event, emit) async {
      if (event is LoadFeed) {
        try {
          emit(FeedLoading());
          final posts = await repo.getUserPosts(event.userId);
          posts.sort((a, b) {
            return b.createdAt.compareTo(a.createdAt);
          });

          final suggestedUsers = await suggested.getSearchedUsers('a');
          suggestedUsers.removeWhere((element) => element.id == event.userId);
          emit(FeedLoaded(posts: posts, users: suggestedUsers));
        } catch (e) {
          emit(FeedError());
        }
      }
    });
  }
}
