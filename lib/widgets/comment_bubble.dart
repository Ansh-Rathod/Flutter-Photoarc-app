import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media/animation.dart';
import 'package:social_media/models/user_model.dart';
import 'package:social_media/screens/profile/profile.dart';
import 'package:social_media/widgets/readmore.dart';

import '../api/extension.dart';
import '../models/comment_model.dart';
import 'user_profile.dart';

class CommentBubbble extends StatelessWidget {
  final CommentModel comment;
  final UserModel currentUser;
  const CommentBubbble({
    Key? key,
    required this.comment,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            createRoute(ProfileScreen(
              currentUser: currentUser,
              id: comment.commenterUserId,
            )));
      },
      leading: UserProfile(
        size: 50,
        url: comment.avatarUrl,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        comment.name,
        style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 20),
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReadMoreText(
            comment.comment,
            trimLines: 2,
            style: Theme.of(context).textTheme.bodyText1,
            colorClickableText: Theme.of(context).primaryColor,
            trimMode: TrimMode.line,
            trimCollapsedText: 'Show more',
            trimExpandedText: 'Show less',
            moreStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            StringExtension.displayTimeAgoFromTimestamp(
              comment.commentCreatedAt,
            ),
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
    // Container(
    //   padding: const EdgeInsets.all(16),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Row(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Flexible(
    //             child: Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 12.0),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     crossAxisAlignment: CrossAxisAlignment.end,
    //                     children: [
    //                       Padding(
    //                         padding:
    //                             const EdgeInsets.symmetric(horizontal: 16.0),
    //                         child: Text(
    //                           "- ",
    //                           style: const TextStyle(
    //                             fontSize: 12,
    //                             color: Colors.white,
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   const SizedBox(height: 6),
    //                   Text(
    //                     comment.comment,
    //                     style: Theme.of(context).textTheme.bodyText1,
    //                   ),
    //                   const SizedBox(height: 6),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //       const SizedBox(height: 6),
    //     ],
    //   ),
    // );
  }
}
