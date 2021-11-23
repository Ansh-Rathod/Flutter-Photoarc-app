import 'package:flutter/material.dart';

import '../../animation.dart';
import '../../models/user_model.dart';
import '../profile/profile.dart';
import '../../widgets/user_profile.dart';

class ShowUserList extends StatelessWidget {
  final UserModel currentUser;
  final List<UserModel> users;
  const ShowUserList({
    Key? key,
    required this.currentUser,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        height: .5,
        color: Colors.grey.shade800,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              createRoute(
                ProfileScreen(
                  currentUser: currentUser,
                  id: users[index].id,
                ),
              ),
            );
          },
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: UserProfile(
            url: users[index].avatarUrl,
            size: 50,
          ),
          title: Text(
            users[index].name,
            style: Theme.of(context).textTheme.headline1!.copyWith(
                  fontSize: 20,
                ),
          ),
          subtitle: Text(users[index].username,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Colors.grey.shade400,
                  )),
        );
      },
    );
  }
}
