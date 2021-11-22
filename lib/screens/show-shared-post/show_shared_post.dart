import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';
import 'cubit/show_shared_post_cubit.dart';
import '../../widgets/post/post_widget.dart';

class ShowSharedPost extends StatelessWidget {
  final String userId;
  final String postId;
  final UserModel currentUser;
  const ShowSharedPost({
    Key? key,
    required this.userId,
    required this.postId,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShowSharedPostCubit()..init(userId, postId),
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          backgroundColor: Colors.transparent,
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade700, width: .4)),
          middle: const Text(
            "Shared post",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'EuclidTriangle',
            ),
          ),
        ),
        body: BlocBuilder<ShowSharedPostCubit, ShowSharedPostState>(
          builder: (context, state) {
            if (state.status == LoadingStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.status == LoadingStatus.loaded) {
              return PostWidget(
                currentUser: currentUser,
                post: state.post,
              );
            } else if (state.status == LoadingStatus.failed) {
              return const Center(
                child: Text("Error While Loading Post",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    )),
              );
            } else if (state.status == LoadingStatus.not_found) {
              return const Center(
                child: Text("Post Not Found",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    )),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
