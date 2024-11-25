import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/my_comment_tile.dart';
import 'package:flutter_application_1/Components/my_post_tile.dart';
import 'package:flutter_application_1/helper/navigate_pages.dart';
import 'package:flutter_application_1/models/post.dart';
import 'package:flutter_application_1/services/database/database_provider.dart';
import 'package:provider/provider.dart';

class PostPage extends StatefulWidget {
  final Post post;
  const PostPage({super.key, required this.post});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);
  @override
  Widget build(BuildContext context) {
    final allComment = listeningProvider.getComments(widget.post.id);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          MyPostTitle(
            post: widget.post,
            onUserTap: () => goUserPage(context, widget.post.uid),
            onPostTap: () {},
          ),
          allComment.isEmpty
              ? Center(
                  child: Text("No comments yet.."),
                )
              : ListView.builder(
                  itemCount: allComment.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final comment = allComment[index];

                    return MyCommentTile(
                      comment: comment,
                      onUserTap: () => goUserPage(context, comment.uid),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
