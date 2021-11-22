part of 'get_search_results_cubit.dart';

enum GetSearchResultsStatus {
  loading,
  success,
  initial,
  error,
}

class GetSearchResultsState {
  final List<UserModel> users;
  final GetSearchResultsStatus status;
  bool get isEmpty => users.isEmpty;
  GetSearchResultsState({
    required this.users,
    required this.status,
  });
  factory GetSearchResultsState.initial() => GetSearchResultsState(
        users: [],
        status: GetSearchResultsStatus.initial,
      );

  GetSearchResultsState copyWith({
    List<UserModel>? users,
    GetSearchResultsStatus? status,
  }) {
    return GetSearchResultsState(
      users: users ?? this.users,
      status: status ?? this.status,
    );
  }
}
