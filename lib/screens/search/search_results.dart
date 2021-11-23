import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../animation.dart';
import '../../models/user_model.dart';
import '../profile/profile.dart';
import 'cubit/get_search_results_cubit.dart';
import '../../widgets/loading/search_page_loading.dart';
import '../../widgets/user_profile.dart';

class SearchResults extends StatelessWidget {
  final UserModel currentUser;
  const SearchResults({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          backgroundColor: Colors.black,
          border: Border(
            bottom: BorderSide(
              width: .4,
              color: Colors.grey.shade800,
            ),
          ),
          middle: const Text(
            "Search Results",
            style: TextStyle(
                fontFamily: 'EuclidTriangle',
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20),
          ),
        ),
        body: BlocBuilder<GetSearchResultsCubit, GetSearchResultsState>(
          builder: (context, state) {
            if (state.status == GetSearchResultsStatus.loading) {
              return const LoadingList();
            }
            if (state.status == GetSearchResultsStatus.error) {
              return Center(
                child: Text(
                  "Something went wrong",
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 24,
                      ),
                ),
              );
            }

            if (state.status == GetSearchResultsStatus.success) {
              if (state.isEmpty) {
                return const Center(
                    child: Text(
                  "No results found",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ));
              }
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  height: .5,
                  color: Colors.grey.shade800,
                ),
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        createRoute(
                          ProfileScreen(
                            currentUser: currentUser,
                            id: state.users[index].id,
                          ),
                        ),
                      );
                    },
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: UserProfile(
                      url: state.users[index].avatarUrl,
                      size: 50,
                    ),
                    title: Text(
                      state.users[index].name,
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                            fontSize: 20,
                          ),
                    ),
                    subtitle: Text(state.users[index].username,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.grey.shade400,
                            )),
                  );
                },
              );
            }
            return Container();
          },
        ));
  }
}
