// ignore_for_file: library_prefixes, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:microscope/config/appId.dart';
import 'package:microscope/provider/user_provider.dart';
import 'package:microscope/utils/colors.dart';
import 'package:microscope/widgets/chat.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:microscope/resources/firestore.methods.dart';
import 'package:microscope/screens/home_screen.dart';
import 'package:http/http.dart' as http;

class BroadcastScreen extends StatefulWidget {
  final bool isBroadcaster;
  final String channelId;

  const BroadcastScreen(
      {Key? key, required this.isBroadcaster, required this.channelId})
      : super(key: key);

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  late final RtcEngine _engine;
  List<int> remoteUid = [];
  bool switchCamera = true;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  void _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    _addListeners();
    await _engine.enableVideo();
    _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (widget.isBroadcaster) {
      _engine.setClientRole(ClientRole.Broadcaster);
    } else {
      _engine.setClientRole(ClientRole.Audience);
    }
    _joinChannel();
  }

  String baseUrl = "https://microscope429.herokuapp.com";
  String? token;

  Future<void> getToken() async {
    final res = await http.get(
      Uri.parse(baseUrl +
          '/rtc/' +
          widget.channelId +
          '/publisher/userAccount/' +
          Provider.of<UserProvider>(context, listen: false).user.uid +
          '/'),
    );

    if (res.statusCode == 200) {
      setState(() {
        token = res.body;
        token = jsonDecode(token!)['rtcToken'];
      });
    } else {
      debugPrint('Failed to fetch the token');
    }
  }

  void _addListeners() {
    _engine.setEventHandler(
        RtcEngineEventHandler(joinChannelSuccess: (channel, uid, elapsed) {
      debugPrint('joinChannelSucces $channel $uid $elapsed');
    }, userJoined: (uid, elapsed) {
      debugPrint('userJoined $uid $elapsed');
      setState(() {
        remoteUid.add(uid);
      });
    }, userOffline: (uid, reason) {
      debugPrint('userOffline $uid $reason');
      setState(() {
        remoteUid.removeWhere((element) => element == uid);
      });
    }, leaveChannel: (stats) {
      debugPrint('leaveChannel $stats');
      setState(() {
        remoteUid.clear();
      });
    }, tokenPrivilegeWillExpire: (token) async {
      await getToken();
      await _engine.renewToken(token);
    }));
  }

  void _joinChannel() async {
    await getToken();
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
    await _engine.joinChannelWithUserAccount(
      token,
      widget.channelId,
      Provider.of<UserProvider>(context, listen: false).user.uid,
    );
  }

  void _switchCamera() {
    _engine.switchCamera().then((value) {
      setState(() {
        switchCamera = !switchCamera;
      });
    }).catchError((err) {
      debugPrint('switchCamera $err');
    });
  }

  void onToggleMute() async {
    setState(() {
      isMuted = !isMuted;
    });
    await _engine.muteLocalAudioStream(isMuted);
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
    if ('${Provider.of<UserProvider>(context, listen: false).user.uid}${Provider.of<UserProvider>(context, listen: false).user.username}' ==
        widget.channelId) {
      await FirestoreMethods().endLiveStream(widget.channelId);
    } else {
      await FirestoreMethods().updateViewCount(widget.channelId, false);
    }
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return WillPopScope(
      onWillPop: () async {
        await _leaveChannel();
        return Future.value(true);
      },
      child: Scaffold(
        body: _renderVideo(user),
      ),
    );
  }

  _renderVideo(user) {
    return SafeArea(
      child: AspectRatio(
        aspectRatio: 9 / 18,
        child: Stack(
          children: [
            "${user.uid}${user.username}" == widget.channelId
                ? const RtcLocalView.SurfaceView(
                    zOrderMediaOverlay: true,
                    zOrderOnTop: true,
                  )
                : remoteUid.isNotEmpty
                    ? kIsWeb
                        ? RtcRemoteView.SurfaceView(
                            uid: remoteUid[0],
                            channelId: widget.channelId,
                          )
                        : RtcRemoteView.TextureView(
                            uid: remoteUid[0],
                            channelId: widget.channelId,
                          )
                    : Container(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          if (widget.isBroadcaster == true)
                            InkWell(
                              onTap: _leaveChannel,
                              child: Container(
                                alignment: Alignment.center,
                                width: 50,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.exit_to_app_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          if (widget.isBroadcaster == true)
                            InkWell(
                              onTap: _switchCamera,
                              child: Container(
                                alignment: Alignment.center,
                                width: 50,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: buttonColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.switch_camera,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          if (widget.isBroadcaster == true)
                            InkWell(
                              onTap: onToggleMute,
                              child: Container(
                                alignment: Alignment.center,
                                width: 50,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: buttonColor,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  isMuted ? Icons.mic_off : Icons.mic,
                                  color: buttonColor,
                                ),
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Chat(
              channelId: widget.channelId,
            ),
          ],
        ),
      ),
    );
  }
}
