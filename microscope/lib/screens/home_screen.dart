// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:microscope/screens/feed_screen.dart';
import 'package:microscope/screens/go_live_screen.dart';
import 'package:microscope/screens/onboarding_screen.dart';
import 'package:microscope/utils/colors.dart';

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
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, OnboardingScreen.routeName);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 13, 0, 112),
        backgroundColor: buttonColor,
        unselectedFontSize: 12,
        onTap: onPageChange,
        currentIndex: _page,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.copy_rounded),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_rounded),
            label: 'Go Live',
          ),
        ],
      ),
      body: pages[_page],
    );
  }
}
