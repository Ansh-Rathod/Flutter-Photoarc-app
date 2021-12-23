import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';
import '../../widgets/comment_bubble.dart';
import '../../widgets/loading/search_page_loading.dart';
import 'cubit/comments_cubit.dart';

class CommentScreen extends StatefulWidget {
  final String userId;
  final UserModel currentUser;
  final String postId;
  const CommentScreen({
    Key? key,
    required this.userId,
    required this.currentUser,
    required this.postId,
  }) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController con = TextEditingController();
    return Scaffold(
      appBar: CupertinoNavigationBar(
        border: Border(
          bottom: BorderSide(
            width: .4,
            color: Colors.grey.shade800,
          ),
        ),
        backgroundColor: Colors.black,
        middle: const Text(
          "Comments",
          style: TextStyle(
            fontFamily: 'EuclidTriangle',
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) =>
            CommentsCubit()..init(userid: widget.userId, postId: widget.postId),
        child: BlocBuilder<CommentsCubit, CommentsState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: state.status == Status.loading
                      ? const LoadingList()
                      : state.comments.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.bubble_left_bubble_right,
                                      color: Theme.of(context).primaryColor,
                                      size: 90),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Be first in Comments".toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(fontSize: 24),
                                  )
                                ],
                              ),
                            )
                          : ListView.separated(
                              itemCount: state.comments.length,
                              separatorBuilder: (context, index) => Divider(
                                color: Colors.grey.shade700,
                              ),
                              itemBuilder: (context, index) {
                                final comment = state.comments[index];
                                return widget.userId == widget.currentUser.id ||
                                        comment.commenterUserId ==
                                            widget.currentUser.id
                                    ? Dismissible(
                                        direction: DismissDirection.endToStart,
                                        key: Key(comment.commentId),
                                        background: Container(
                                          alignment: Alignment.centerRight,
                                          color: Colors.redAccent,
                                          child: const Padding(
                                            padding: EdgeInsets.all(26.0),
                                            child: Icon(
                                              CupertinoIcons.delete,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        onDismissed: (j) async {
                                          BlocProvider.of<CommentsCubit>(
                                                  context)
                                              .deleteComment(widget.userId,
                                                  comment.commentId, index);
                                        },
                                        child: CommentBubbble(
                                          comment: comment,
                                          currentUser: widget.currentUser,
                                        ),
                                      )
                                    : CommentBubbble(
                                        currentUser: widget.currentUser,
                                        comment: comment,
                                      );
                              },
                            ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border(
                      top: BorderSide(
                        width: .5,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      maxLines: null,
                      controller: con,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: "Add comment",
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            BlocProvider.of<CommentsCubit>(context).addComment(
                              userId: widget.userId,
                              postId: widget.postId,
                              comment: con.text,
                              currentUser: widget.currentUser,
                            );

                            con.clear();
                          },
                          child: const Icon(Icons.send),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
