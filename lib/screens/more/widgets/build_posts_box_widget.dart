import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../const/colors.dart';
import '../../../models/forum_post_model.dart';
import 'add_new_post_popup.dart';

Widget buildPostCard(
    context, ForumPost post, VoidCallback up, VoidCallback down) {
  DateTime dateTime = post.createTime.toDate();

  String formattedTime = DateFormat.jm().format(dateTime);
  String formattedDate = DateFormat.yMd().format(dateTime);

  return Card(
    margin: const EdgeInsets.all(10.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              post.image.isEmpty
                  ? const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                      radius: 20.0,
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(post.image),
                      radius: 20.0,
                    ),
              const SizedBox(width: 10.0),
              Row(
                children: [
                  Text(
                    post.name,
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text('Posted at $formattedTime on $formattedDate'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(post.message),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: up,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redType,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 2),
                  IconButton(
                    onPressed: down,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redType,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  showNewPostDialog(context, parentPostId: post);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.redType,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Reply',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
