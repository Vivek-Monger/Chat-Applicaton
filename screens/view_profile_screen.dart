import 'package:buzz_chat/main.dart';
import 'package:buzz_chat/models/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// View profile screen to display the user's profile
class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.user.name),

        ),
        
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: Center(
            // Center the Column horizontally
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center contents vertically
                children: [
                  SizedBox(height: mq.height * .03),

                  // User profile picture
                  Stack(
                    children: [
                      // Image from server
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .1),
                        child: CachedNetworkImage(
                          width: mq.height * .2,
                          height: mq.height * .2,
                          fit: BoxFit.cover,
                          imageUrl: widget.user.image,
                          errorWidget: (context, url, error) => CircleAvatar(
                            child: Icon(CupertinoIcons.person),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: mq.height * .03),

                  Text(
                    widget.user.email,
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),

                  SizedBox(height: mq.height * .03),

                  //usre about
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'About: ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      Text(
                        widget.user.about,
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ],
                  ),

                  SizedBox(
                      height: mq.height * .5), // Add some spacing if needed
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
