import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../models/user_model.dart';
import 'post/post_widget.dart';

class PostsWidget extends StatefulWidget {
  final List<PostModel> posts;
  final int inialIndex;
  final UserModel currentUser;
  const PostsWidget({
    Key? key,
    required this.posts,
    required this.inialIndex,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<PostsWidget> createState() => _PostsWidgetState();
}

class _PostsWidgetState extends State<PostsWidget> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.black,
        border: Border(
          bottom: BorderSide(
            width: 0.4,
            color: Colors.grey.shade900,
          ),
        ),
        middle: const Text(
          'Posts',
          style: TextStyle(
            fontFamily: 'EuclidTriangle',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ScrollablePositionedList.builder(
        physics: const BouncingScrollPhysics(),
        initialScrollIndex: widget.inialIndex,
        itemCount: widget.posts.length,
        itemBuilder: (context, index) => Column(
          children: [
            PostWidget(
              post: widget.posts[index],
              currentUser: widget.currentUser,
            ),
            index != widget.posts.length - 1
                ? Divider(
                    height: .4,
                    color: Colors.grey.shade900,
                  )
                : Container()
          ],
        ),
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
      ),
    );
  }
}
