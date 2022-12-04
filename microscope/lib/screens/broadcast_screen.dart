import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

class BroadcastScreen extends StatefulWidget {
  const BroadcastScreen({Key? key}) : super(key: key);

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  late final RtcEngine _engine;
  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  void _initEngine() async {
    // _engine = await RtcEngine.createWithContext(
    //   RtcEngineContext(
    //       appId: ,
    //       ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
