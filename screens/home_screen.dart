import 'dart:developer';

import 'package:buzz_chat/api/apis.dart';
import 'package:buzz_chat/helper/dialogs.dart';
import 'package:buzz_chat/main.dart';
import 'package:buzz_chat/models/chat_user.dart';
import 'package:buzz_chat/screens/profile_screen.dart';
import 'package:buzz_chat/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //for storing all users
  List<ChatUser> _list = [];

  //for searching search items
  final List<ChatUser> _searchList = [];

  //for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    //for setting user status to active
    APIs.updateActiveStatus(true);

    //for updating active status according to lifecycle events
    //resume --- active or online
    //pause --- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message){
      log('Message: $message');

      if(APIs.auth.currentUser != null){
        if(message.toString().contains('pause')) APIs.updateActiveStatus(false);
        if(message.toString().contains('resume')) APIs.updateActiveStatus(true);
      }
      
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard when tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: (){
          if(_isSearching){
            setState(() {
              _isSearching = !_isSearching;
             
            });
            return Future.value(false);
            
          }else{
            return Future.value(true);
          }
          
        },
        // if search is on &b back button is pressed then close search
        //or else simple close screen on back button click
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(CupertinoIcons.home),
            title: _isSearching
                ? TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name, ...',
                    ),
                    autofocus: true,
                    style: TextStyle(fontSize: 17, letterSpacing: 0.5),
                    //when search text changes then update search list
                    onChanged: (val) {
                      // search logic
                      _searchList.clear();
        
                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase())) {
                              _searchList.add(i);
        
                              setState(() {
                              _searchList;
                            });
                            }
                      }
                    },
                  )

                : Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Buzz',
                                style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.w700), // Red color for "Buzz"
                              ),
                              TextSpan(
                                text: ' Chat',
                                style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w700), // Blue color for "Chat"
                              ),
                            ],
                          ),
                        ),

            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(_isSearching
                    ? CupertinoIcons.clear_circled_solid
                    : Icons.search),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      //to show which user is logged in
                      builder: (_) => ProfileScreen(user: APIs.me),
                    ),
                  );
                },
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),

          floatingActionButton: Padding(
            
            padding: const EdgeInsets.only(bottom: 10),
            
            child: FloatingActionButton(
              backgroundColor: Colors.lightBlue,
              
              onPressed: (){
                _addChatUserDialog();
              },
              child: Icon(Icons.add_comment_rounded, color: Colors.black87,),
              
            ),
          ),

          body: StreamBuilder(
            stream: APIs.getMyUserId(), 

            //get id of only known users
            builder: (context, snapshot){
            switch (snapshot.connectionState) {
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  // return const Center(
                  //   child: CircularProgressIndicator(),
                  // );
        
                //if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:

              return StreamBuilder(
            stream: APIs.getAllUsers(snapshot.data?.docs
                          .map(
                            (e) => e.id
                          )
                          .toList() ??
                      []),
             //get only those users, whos ids are provided         
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
        
                //if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  _list = data
                          ?.map(
                            (e) => ChatUser.fromJson(
                              e.data(),
                            ),
                          )
                          .toList() ??
                      [];
        
                  if (_list.isNotEmpty) {
                    return ListView.builder(
                        itemCount: _isSearching ? _searchList.length : _list.length,
                        padding: EdgeInsets.only(top: mq.height * .01),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCard(user: _isSearching ? _searchList[index] : _list[index]);
                          //return Text('Name: ${list[index]}');
                        });
                  } else {
                    return Center(
                      child: Text(
                        'No Connections Found',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }
              }
            },
          );
            }
            
          }),
        ),
      ),
    );
  }

   //dialog for adding new user
  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(

          contentPadding: EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Add User'),
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                  hintText: 'Email Id',
                  prefixIcon: Icon(Icons.email, color: Colors.blue,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              
              //actions
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),

                //Add Button
                MaterialButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    if(email.isNotEmpty)
                    {
                      await APIs.addChatUser(email).then((value) {
                        if(!value){
                          Dialogs.showSnapbar(context, 'User Does Not Exists');
                        }
                      });
                      }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
              ],
            ));
  }
}
