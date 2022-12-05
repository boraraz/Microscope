import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:microscope/resources/firestore.methods.dart';
import 'package:microscope/screens/broadcast_screen.dart';
import 'package:microscope/utils/colors.dart';
import 'package:microscope/utils/utils.dart';
import 'package:microscope/widgets/custom_button.dart';
import 'package:microscope/widgets/custom_textfield.dart';

class GoLiveScreen extends StatefulWidget {
  const GoLiveScreen({Key? key}) : super(key: key);

  @override
  State<GoLiveScreen> createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends State<GoLiveScreen> {
  final TextEditingController _titleController = TextEditingController();
  Uint8List? image;
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  goLiveStream() async {
    String channelId = await FirestoreMethods().startLiveStream(
      context,
      _titleController.text,
      image,
    );

    if (channelId.isNotEmpty) {
      showSnackBar(context, 'Livestream has started successfully');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BroadcastScreen(
            isBroadcaster: true,
            channelId: channelId,
            ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      Uint8List? pickedImage = await pickImage();
                      if (pickedImage != null) {
                        setState(() {
                          image = pickedImage;
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 22.0),
                      child: image != null
                          ? SizedBox(
                              height: 300,
                              child: Image.memory(image!),
                            )
                          : DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              dashPattern: const [10, 4],
                              strokeCap: StrokeCap.round,
                              color: thumbnailBackground.withOpacity(1),
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: thumbnailBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.folder_open,
                                      color: folderIcon,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 15),
                                    Text("Select a thumbnail",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: folderIcon,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: CustomTextField(
                          controller: _titleController,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CustomButton(
                  text: 'Go Live!',
                  onTap: goLiveStream,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
