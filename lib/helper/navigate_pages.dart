import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/pages/profile_page.dart';

import '../models/post.dart';
import '../pages/post_page.dart';

void goUserPage(BuildContext contex, String uid) {
  Navigator.push(
      contex,
      MaterialPageRoute(
          builder: (contex) => ProfilePage(
                uid: uid,
              )));
}

void goPostPage(BuildContext context, Post post) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => PostPage(
              post: post,
            )),
  );
}
