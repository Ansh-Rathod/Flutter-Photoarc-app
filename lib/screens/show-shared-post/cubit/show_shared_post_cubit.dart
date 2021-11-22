import 'dart:convert';

import 'package:bloc/bloc.dart';
import '../../../api/url.dart';
import '../../../models/post_model.dart';

import 'package:http/http.dart' as http;
part 'show_shared_post_state.dart';

class ShowSharedPostCubit extends Cubit<ShowSharedPostState> {
  ShowSharedPostCubit() : super(ShowSharedPostState.initial());
  void init(String uid, String postId) async {
    try {
      emit(state.copyWith(status: LoadingStatus.loading));
      var res = await http.get(
          Uri.parse(BASE_URL + '/post/one_post/' + uid + '?post_id=' + postId));
      if (res.statusCode == 200) {
        emit(state.copyWith(
          post: PostModel.fromJson(
            jsonDecode(res.body)['results'][0],
          ),
          status: LoadingStatus.loaded,
        ));
      } else if (jsonDecode(res.body)['results'].isEmpty) {
        emit(state.copyWith(status: LoadingStatus.not_found));
      }
    } catch (e) {
      emit(state.copyWith(status: LoadingStatus.failed));
    }
  }
}
