// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/widgets/error_snackbar_widget.dart';
import 'package:uuid/uuid.dart';

import '../../../const/colors.dart';
import '../../../models/forum_post_model.dart';
import '../../../provider/user_provider.dart';

bool containsPhoneNumber(String text) {
  // Remove all non-digit characters
  String digitsOnly = text.replaceAll(RegExp(r'\D'), '');

  // Check if the remaining string is exactly 10 digits
  return digitsOnly.length == 10;
}

bool isLink(String text) {
  return text.startsWith("http://") || text.startsWith("https://");
}

void showNewPostDialog(BuildContext context, {ForumPost? parentPostId}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String newPostText = '';

      return AlertDialog(
        title: Text(parentPostId != null ? 'New Reply' : 'New Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              onChanged: (value) {
                newPostText = value;
              },
              decoration: InputDecoration(
                labelText: parentPostId != null
                    ? 'Enter your reply...'
                    : 'Enter your post...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (newPostText.isEmpty) {
                  Navigator.of(context).pop();
                  showCoolErrorSnackbar(context, "The text is empty");
                } else if (containsPhoneNumber(newPostText) ||
                    isLink(newPostText)) {
                  Navigator.of(context).pop();
                  showCoolErrorSnackbar(
                      context, 'The text cannot be a number or a link.');
                } else {
                  await addNewPost(context, newPostText, parentPostId);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.redType,
              ),
              child: Text(
                parentPostId != null ? 'Reply' : 'Submit',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> addNewPost(context, String text, ForumPost? parentPostId) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  const Uuid uuid = Uuid();
  String postId = uuid.v4();
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  Map<String, dynamic> postData = {
    'name': userProvider.user.name,
    'image': userProvider.user.image,
    'message': text,
    'postId': postId,
    'createTime': Timestamp.now(),
  };

  if (parentPostId != null) {
    if (parentPostId.isReply) {
      parentPostId.message =
          parentPostId.repliedByMessage ?? parentPostId.message;
    }
    Map<String, dynamic> oldPost = parentPostId.toJson();

    oldPost.addAll({
      'createTime': Timestamp.now(),
      'isReply': true,
      'replyPostId': parentPostId.postId,
      'repliedByName': userProvider.user.name,
      'repliedByImage': userProvider.user.image,
      'repliedByMessage': text,
      'repliedByCreateTime': Timestamp.now(),
    });

    await postsCollection.doc(postId).set(oldPost);
  } else {
    await postsCollection.doc(postId).set(postData);
  }
}
