import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../../repo/genrate_user_id.dart';
import '../../../repo/user_events_repo.dart';
import '../../../repo/user_repo.dart';

part 'getposts_event.dart';
part 'getposts_state.dart';

class GetProfileBloc extends Bloc<GetProfileEvent, GetProfileState> {
  final repo = GetUserInfo();
  final followRepo = UserEvents();
  GetProfileBloc() : super(GetProfileInitial()) {
    on<GetProfileEvent>((event, emit) async {
      if (event is GetUsesrPostsEvent) {
        try {
          emit(GetProfileLoading());
          genrateId(FirebaseAuth.instance.currentUser!.uid);
          final posts = await repo.getUserPosts(event.uid);
          final user = await repo.getUserInfo(event.uid);

          emit(GetProfileLoaded(user: user, posts: posts));
        } catch (e) {
          // print(e.toString());
          emit(GetProfileError());
        }
      }
    });
  }
}
