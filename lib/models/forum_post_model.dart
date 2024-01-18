import 'package:cloud_firestore/cloud_firestore.dart';

class ForumPost {
  String name;
  String image;
  String message;
  Timestamp createTime;
  String postId;
  bool isReply;
  String? repliedByName;
  String? repliedByImage;
  String? repliedByMessage;
  Timestamp? repliedByCreateTime;
  String? replyPostId;

  ForumPost({
    required this.name,
    required this.image,
    required this.message,
    required this.createTime,
    required this.postId,
    this.isReply = false,
    this.repliedByName,
    this.repliedByImage,
    this.repliedByMessage,
    this.repliedByCreateTime,
    this.replyPostId,
  });

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    return ForumPost(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      message: json['message'] ?? '',
      createTime: json['createTime'] ?? '',
      postId: json['postId'] ?? '',
      isReply: json['isReply'] ?? false,
      repliedByName: json['repliedByName'],
      repliedByImage: json['repliedByImage'],
      repliedByMessage: json['repliedByMessage'],
      repliedByCreateTime: json['repliedByCreateTime'],
      replyPostId: json['replyPostId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'message': message,
      'createTime': createTime,
      'postId': postId,
      'isReply': isReply,
      'repliedByName': repliedByName,
      'repliedByImage': repliedByImage,
      'repliedByMessage': repliedByMessage,
      'repliedByCreateTime': repliedByCreateTime,
      'replyPostId': replyPostId,
    };
  }
}
