import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../const/colors.dart';
import '../../../models/forum_post_model.dart';
import 'add_new_post_popup.dart';

Widget buildPostReplyCard(
    context, ForumPost post, VoidCallback up, VoidCallback down) {
  DateTime dateTime = post.repliedByCreateTime!.toDate();

  String formattedTime = DateFormat.jm().format(dateTime);
  String formattedDate = DateFormat.yMd().format(dateTime);

  return Card(
    color: Colors.white,
    margin: const EdgeInsets.all(10.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
              color: Color(0xFFCF0146),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  post.repliedByImage!.isEmpty
                      ? const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/avatar.png'),
                          radius: 20.0,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(post.repliedByImage!),
                          radius: 20.0,
                        ),
                  const SizedBox(width: 10.0),
                  Text(
                    post.repliedByName ?? 'Unknown User',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                children: [
                  Text(
                    'Replied at $formattedTime',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              post.repliedByMessage ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        // Original Post Information
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            color: AppColors.opBlueType,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  post.image.isEmpty
                      ? const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/avatar.png'),
                          radius: 14.0,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(post.image),
                          radius: 14.0,
                        ),
                  const SizedBox(width: 10.0),
                  Text(
                    post.name,
                    style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(width: 10.0),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  post.message,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w200),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 1.0),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
              color: Color(0xFFCF0146),
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: up,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueType,
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
                      backgroundColor: AppColors.blueType,
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
                  backgroundColor: AppColors.blueType,
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
        ),
      ],
    ),
  );
}
