// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';
import 'package:social_media/models/user_model.dart';
import 'package:social_media/repo/get_shareable_link.dart';
import 'package:social_media/screens/edit-profile/update_user.dart';
import 'package:social_media/screens/edit-profile/upload_profile.dart';
import 'package:social_media/screens/profile/widgets/cubit/event_button_cubit.dart';
import 'package:social_media/screens/users-followers-page/user_followers.dart';
import 'package:social_media/widgets/readmore.dart';
import 'package:social_media/widgets/user_profile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../animation.dart';

class RowInfo extends StatelessWidget {
  const RowInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventButtonCubit, EventButtonState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Tile(
                        count: state.postsCount.toString(),
                        name: "  Posts  ",
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: 1,
                          height: 20,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            createRoute(
                              ShowUserFollowers(
                                currentUser: state.currentUser,
                                uid: state.currentProfile.id,
                                index: 0,
                              ),
                            ),
                          );
                        },
                        child: Tile(
                          count: state.followersCount.toString(),
                          name: "Followers",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: 1,
                          height: 20,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            createRoute(
                              ShowUserFollowers(
                                currentUser: state.currentUser,
                                index: 1,
                                uid: state.currentProfile.id,
                              ),
                            ),
                          );
                        },
                        child: Tile(
                          count: state.followingCount.toString(),
                          name: "Following",
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                    onTap: state.isCurrentUser
                        ? () {
                            Navigator.push(
                              context,
                              createRoute(
                                UpdateProfile(
                                  user: state.currentUser,
                                ),
                              ),
                            );
                          }
                        : null,
                    child: UserProfile(
                        size: 70, url: state.currentProfile.avatarUrl)),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            if (state.currentProfile.username != '')
              Text(
                '@' + state.currentProfile.username,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            const SizedBox(
              height: 4,
            ),
            if (state.currentProfile.bio != '')
              ReadMoreText(
                state.currentProfile.bio,
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
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                button(state.isCurrentUser, state.isFollowing, context,
                    state.currentUser),
                const SizedBox(width: 10),
                if (state.currentProfile.url != "")
                  OutlinedButton(
                    onPressed: () {
                      launch(state.currentProfile.url);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 13.0),
                      child: Icon(
                        CupertinoIcons.link,
                        color: Colors.white,
                      ),
                    ),
                  ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () async {
                    final url = await getUrl(
                      description: state.currentProfile.bio,
                      image: state.currentProfile.avatarUrl,
                      title: state.currentProfile.name,
                      url:
                          'https://anshrathod.vercel.app/socialapp?userId=${state.currentProfileId}&type=up',
                    );
                    Share.share('Check out this profile on Photoarc app $url',
                        subject:
                            'Made in flutter with 💙');
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 13.0),
                    child: Icon(
                      CupertinoIcons.share,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget button(bool isCurrentUser, bool? isFollowing, BuildContext context,
      UserModel currentUser) {
    if (isCurrentUser) {
      return Expanded(
        child: OutlinedButton(
          onPressed: () {
            Navigator.push(
                context, createRoute(UpdateUser(currentUser: currentUser)));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "EDIT PROFILE",
              style: Theme.of(context).textTheme.button!.copyWith(
                  color: Theme.of(context).primaryColor, fontSize: 14),
            ),
          ),
        ),
      );
    } else if (isFollowing != null && isFollowing) {
      return Expanded(
        child: OutlinedButton(
          onPressed: () {
            BlocProvider.of<EventButtonCubit>(context).unfollow();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "UNFOLLOW",
              style: Theme.of(context).textTheme.button!.copyWith(
                  color: Theme.of(context).primaryColor, fontSize: 14),
            ),
          ),
        ),
      );
    } else if (isFollowing != null && !isFollowing) {
      return Expanded(
        child: RaisedButton(
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
          onPressed: () {
            BlocProvider.of<EventButtonCubit>(context).follow();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "FOLLOW",
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      );
    } else {
      return Expanded(
        child: RaisedButton(
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
          disabledColor: Colors.grey.shade800,
          onPressed: null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "Loading..".toUpperCase(),
              style: Theme.of(context).textTheme.headline1!.copyWith(
                    fontSize: 15,
                  ),
            ),
          ),
        ),
      );
    }
  }
}

class Tile extends StatelessWidget {
  final String count;
  final String name;
  const Tile({
    Key? key,
    required this.count,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count,
          style: const TextStyle(
            fontFamily: 'EuclidTriangle',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.white.withOpacity(.6),
          ),
        ),
      ],
    );
  }
}
