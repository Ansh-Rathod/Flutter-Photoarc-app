import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';
import 'cubit/post_likers_cubit.dart';
import '../show-users-list/show_user_list.dart';
import '../../widgets/loading/search_page_loading.dart';

class PostLikedBy extends StatelessWidget {
  final UserModel currentUser;
  final String userId;
  final String postId;
  const PostLikedBy({
    Key? key,
    required this.currentUser,
    required this.userId,
    required this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostLikersCubit()..getLikers(userId, postId),
      child: Scaffold(
          appBar: CupertinoNavigationBar(
            backgroundColor: Colors.black,
            border: Border(
              bottom: BorderSide(
                width: .4,
                color: Colors.grey.shade800,
              ),
            ),
            middle: const Text(
              "Post liked by",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
          ),
          body: BlocBuilder<PostLikersCubit, PostLikersState>(
            builder: (context, state) {
              if (state.status == LoadingStauts.loading) {
                return const LoadingList();
              } else if (state.status == LoadingStauts.loaded) {
                return ShowUserList(
                    currentUser: currentUser, users: state.users);
              } else if (state.status == LoadingStauts.error) {
                return Center(
                  child: Text(
                    "Something went wrong",
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                          fontSize: 24,
                        ),
                  ),
                );
              }
              return Container();
            },
          )),
    );
  }
}
