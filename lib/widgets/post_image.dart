import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostImage extends StatelessWidget {
  final File? path;
  const PostImage({
    Key? key,
    this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return path == null
        ? Container(
            color: const Color.fromARGB(255, 19, 30, 51),
            height: 300,
            child: const Center(
              child: Icon(
                Icons.add_photo_alternate_outlined,
                color: Colors.white,
                size: 50,
              ),
            ),
          )
        : Image.file(
            path!,
            fit: BoxFit.cover,
          );
  }
}
