//import 'dart:developer';
import 'dart:io';

import 'package:buzz_chat/api/apis.dart';
import 'package:buzz_chat/helper/dialogs.dart';
import 'package:buzz_chat/main.dart';
import 'package:buzz_chat/models/chat_user.dart';
import 'package:buzz_chat/screens/auth/login_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: Text("Profile Screen"),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                // Show confirmation dialog for logout
                bool shouldLogout = await _showConfirmationDialog(
                  context,
                  'Are you sure you want to log out?',
                );
                if (shouldLogout) {
                  Dialogs.showProgressBar(context);

                  await APIs.updateActiveStatus(false);

                  await APIs.auth.signOut().then((value) async {
                    await GoogleSignIn().signOut().then((value) {
                      Navigator.pop(context); // Hide progress dialog
                      Navigator.pop(context); // Go back from profile screen

                      APIs.auth = FirebaseAuth.instance;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LoginScreen(),
                        ),
                      );
                    });
                  });
                }
              },

              icon: Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ),
              label: Text(
                'Logout',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),

          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: mq.width,
                      height: mq.height * .03,
                    ),

                    //user profile picture
                    Stack(
                      children: [
                        _image != null
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: Image.file(
                                  File(_image!),
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.cover,
                                ),
                              )

                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: CachedNetworkImage(
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.user.image,
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                    child: Icon(CupertinoIcons.person),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    
                    SizedBox(
                      height: mq.height * .03,
                    ),

                    Text(
                      widget.user.email,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),

                    SizedBox(
                      height: mq.height * .05,
                    ),

                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (val) => APIs.me.name = val ?? '',
                      validator: (val) =>
                          val != null && val.isNotEmpty ? null : 'Required Field',
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: const Color.fromARGB(255, 18, 139, 238),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Username',
                        label: Text('Name'),
                      ),
                    ),

                    SizedBox(
                      height: mq.height * .02,
                    ),
                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => APIs.me.about = val ?? '',
                      validator: (val) =>
                          val != null && val.isNotEmpty ? null : 'Required Field',
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.info_outline_rounded,
                          color: const Color.fromARGB(255, 18, 139, 238),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Birth Place',
                        label: Text('About'),
                      ),
                    ),

                    SizedBox(
                      height: mq.height * .05,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        minimumSize: Size(mq.width * .5, mq.height * .06),
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool shouldUpdate = await _showConfirmationDialog(
                            context,
                            'Are you sure you want to update your profile?',
                          );
                          if (shouldUpdate) {
                            _formKey.currentState!.save();
                            APIs.updateUserInfo().then((value) {
                              Dialogs.showSnapbar(
                                  context, 'Profile Updated Successfully');
                            });
                          }
                        }
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 28,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Update',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  // Helper function to show confirmation dialog
  Future<bool> _showConfirmationDialog(
      BuildContext context, String message) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // No button
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Yes button
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}

  //for showing bottom sheet for picking a profile pictures for user

  // void _showBottomSheet() {
  //   showModalBottomSheet(
  //       context: context,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(20),
  //           topRight: Radius.circular(20),
  //         ),
  //       ),
  //       builder: (_) {
  //         return ListView(
  //           shrinkWrap: true,
  //           padding:
  //               EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
  //           children: [
  //             Text(
  //               'Pick Profile Picture',
  //               textAlign: TextAlign.center,
  //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
  //             ),

  //             //for adding some space
  //             SizedBox(height: mq.height * .02,),

  //             //buttons
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 //pick from gallery buttom
  //                 ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.white,
  //                     shape: CircleBorder(),
  //                     fixedSize: Size(mq.width * .3, mq.height * .15)
  //                   ),
  //                   onPressed: () async {
  //                     final ImagePicker picker = ImagePicker();
  //                     //pick an image
  //                     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //                     if(image != null){
  //                       log('Image Path: ${image.path} --MimeType: ${image.mimeType}');

  //                       setState(() {
  //                         _image = image.path;
  //                       });
  //                       //for hiding bottom sheet
  //                     Navigator.pop(context);
  //                     }
                      
  //                   },
  //                   child: Image.asset('images/add_image.png'),
  //                 ),
  //                 //take pictures from camera button
  //                 ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.white,
  //                     shape: CircleBorder(),
  //                     fixedSize: Size(mq.width * .3, mq.height * .15)
  //                   ),
  //                   onPressed: () async {
  //                     final ImagePicker picker = ImagePicker();
  //                     //pick an image
  //                     final XFile? image = await picker.pickImage(source: ImageSource.camera);
  //                     if(image != null){
  //                       log('Image Path: ${image.path}');

  //                       setState(() {
  //                         _image = image.path;
  //                       });
  //                       //for hiding bottom sheet
  //                     Navigator.pop(context);
  //                     }
  //                   },
  //                   child: Image.asset('images/camera.png'),
  //                 ),
  //               ],
  //             )
  //           ],
  //         );
  //       });
  // }

