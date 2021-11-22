import 'package:bloc/bloc.dart';
import '../../../models/user_model.dart';
import '../../../repo/user_repo.dart';

part 'get_search_results_state.dart';

class GetSearchResultsCubit extends Cubit<GetSearchResultsState> {
  final repo = GetUserInfo();
  GetSearchResultsCubit() : super(GetSearchResultsState.initial());

  void getSearchResults(String searchText, String userId) async {
    emit(state.copyWith(status: GetSearchResultsStatus.loading));
    try {
      final users = await repo.getSearchedUsers(searchText);
      users.removeWhere((element) => element.id == userId);

      emit(
          state.copyWith(status: GetSearchResultsStatus.success, users: users));
    } catch (e) {
      emit(state.copyWith(status: GetSearchResultsStatus.error));
    }
  }
}
