import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/screens/more/widgets/build_post_reply_card_widget.dart';
import 'package:rm_official_app/widgets/bottom_contact_widget.dart';
import 'package:uuid/uuid.dart';

import '../../models/forum_post_model.dart';
import '../../widgets/app_bar_widget.dart';
import '../navigation/drawer_nav_bar.dart';
import 'widgets/add_new_post_popup.dart';
import 'widgets/build_posts_box_widget.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({Key? key, required this.isRoute}) : super(key: key);

  @override
  State<ForumScreen> createState() => _ForumScreenState();
  final bool isRoute;
}

class _ForumScreenState extends State<ForumScreen> {
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  final ScrollController _scrollController = ScrollController();

  final Uuid uuid = const Uuid();

  void up() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void down() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      drawer: widget.isRoute ? null : const NavBar(),
      appBar: const AppBarWidget(
        title: 'FORUMS',
      ),
      body: StreamBuilder(
        stream: postsCollection
            .orderBy('createTime', descending: true)
            .limit(50)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<ForumPost> forumPosts = snapshot.data!.docs
              .map((document) =>
                  ForumPost.fromJson(document.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            itemCount: forumPosts.length + 1, // Add 1 for the additional text
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index < forumPosts.length) {
                ForumPost post = forumPosts[index];
                return post.isReply
                    ? buildPostReplyCard(context, post, down, up)
                    : buildPostCard(context, post, down, up);
              } else {
                return const Column(
                  children: [
                    BottomContact(),
                    SizedBox(
                      height: 30,
                    )
                  ],
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNewPostDialog(context);
        },
        backgroundColor: AppColors.redType,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
