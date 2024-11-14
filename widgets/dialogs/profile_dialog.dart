import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/chat_user.dart';
import '../../screens/view_profile_screen.dart';


class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
Widget build(BuildContext context) {
  return AlertDialog(
    contentPadding: EdgeInsets.zero,
    backgroundColor: Colors.white.withOpacity(.9),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    content: SizedBox(
      width: mq.width * .6,
      height: mq.height * .35,
      child: Stack(
        children: [
          // Center the circular user profile picture
          Center(
            child: ClipOval(
              child: CachedNetworkImage(
                width: mq.height * .2,
                height: mq.height * .2,
                fit: BoxFit.cover,
                imageUrl: user.image,
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: mq.height * .1,
                  child: Icon(CupertinoIcons.person, size: mq.height * .1),
                ),
              ),
            ),
          ),

          // User name positioned in the top left corner
          Positioned(
            left: mq.width * .04,
            top: mq.height * .02,
            child: Text(
              user.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Info button positioned in the top right corner
          Positioned(
            right: 8,
            top: 6,
            child: MaterialButton(
              onPressed: () {
                // Hide image dialog
                Navigator.pop(context);

                // Move to view profile screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ViewProfileScreen(user: user),
                  ),
                );
              },
              minWidth: 0,
              padding: const EdgeInsets.all(0),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.info_outline,
                color: Colors.blue,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
