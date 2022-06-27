import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:finstagram/pages/bottom-appBar_pages/feed_page.dart';
import 'package:finstagram/pages/bottom-appBar_pages/profile_page.dart';
import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseService? _firebaseService;
  int _currentPage = 0;
  List<Widget> pages = [FeedPage(), ProfilePage()];
  double? _deviceHeight;
  double? _devicewidth;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Finstagram", style: kappbartext),
        actions: [
          IconButton(
            onPressed: () {
              _postImage();
            },
            icon: const Icon(
              Icons.add_a_photo,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(),
      body: pages[_currentPage],
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (_index) {
          setState(() {
            _currentPage = _index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: "Feed",
            icon: Icon(Icons.feed),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(
              Icons.account_box,
            ),
          )
        ]);
  }

  void _postImage() async {
    FilePickerResult? _result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    File _image = File(_result!.files.first.path!);
    await _firebaseService!.postImage(_image);
  }
}
