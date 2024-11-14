import 'package:buzz_chat/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallScreen extends StatefulWidget {
  final ChatUser user;
  final bool isVideoCall; // true for video, false for voice

  const CallScreen({super.key, required this.user, required this.isVideoCall});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 587618279,
      appSign: '534a48b9120235fe0de010f93752aea93854ef9abef0ed2570cc298140bbdbde',
      userID: widget.user.id,
      userName: widget.user.name,
      callID: 'demo_call', // You may want to pass a unique callID in a real app
      config: widget.isVideoCall
          ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
    );
  }
}
