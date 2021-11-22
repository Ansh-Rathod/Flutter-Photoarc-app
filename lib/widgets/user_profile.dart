import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final String? url;
  final File? path;
  final double size;
  const UserProfile({
    Key? key,
    this.url = "",
    this.path,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: kElevationToShadow[2],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Colors.grey.shade100,
          width: size,
          height: size,
          child: path == null && url == ""
              ? Icon(CupertinoIcons.person, size: size / 2)
              : path == null
                  ? CachedNetworkImage(
                      imageUrl: url!,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      path!,
                      fit: BoxFit.cover,
                    ),
        ),
      ),
    );
  }
}
