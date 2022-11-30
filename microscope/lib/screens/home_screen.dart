import 'package:flutter/material.dart';
import 'package:microscope/provider/user_provider.dart';
import 'package:microscope/screens/feed_screen.dart';
import 'package:microscope/screens/go_live_screen.dart';
import 'package:microscope/utils/colors.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  List<Widget> pages = [
    const FeedScreen(),
    const GoLiveScreen(),
    const Center(
      child: Text("Browse"),
    ),
  ];

  onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Color.fromARGB(255, 64, 0, 112),
        backgroundColor: buttonColor,
        unselectedFontSize: 12,
        onTap: onPageChange,
        currentIndex: _page,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Following',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_rounded),
            label: 'Go Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.copy),
            label: 'Browse',
          ),
        ],
      ),
      body: pages[_page],
    );
  }
}
