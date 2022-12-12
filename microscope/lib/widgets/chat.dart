import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:microscope/provider/user_provider.dart';
import 'package:microscope/resources/firestore.methods.dart';
import 'package:microscope/widgets/custom_textfield.dart';
import 'package:microscope/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  final String channelId;
  const Chat({
    Key? key,
    required this.channelId,
  }) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _chatController = TextEditingController();

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: size.height / 2.0,
          ),
          Expanded(
            child: StreamBuilder<dynamic>(
              stream: FirebaseFirestore.instance
                  .collection('livestream')
                  .doc(widget.channelId)
                  .collection('comments')
                  .orderBy(
                    'createdAt',
                    descending: true,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingIndicator();
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) => Container(
                    color: const Color.fromRGBO(130, 130, 130, 0.7),
                    child: ListTile(
                      title: Text(
                        snapshot.data.docs[index]['username'],
                        style: TextStyle(
                          color: snapshot.data.docs[index]['uid'] ==
                                  userProvider.user.uid
                              ? Colors.red
                              : Colors.blue,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data.docs[index]['message'],
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          CustomTextField(
            controller: _chatController,
            onTap: (val) {
              FirestoreMethods().chat(
                _chatController.text,
                widget.channelId,
                context,
              );
              setState(() {
                _chatController.text = "";
              });
            },
          )
        ],
      ),
    );
  }
}
