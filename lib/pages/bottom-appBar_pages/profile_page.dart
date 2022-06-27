import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseService? _firebaseService;
  double? _deviceheight, _deviceWidth;
  @override
  void initState() {
    super.initState();
    FirebaseService _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _deviceWidth! * 0.05,
      width: _deviceWidth! * 0.02,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _profileImage(),
        ],
      ),
    );
  }

  Widget _profileImage() {
    return Container(
      padding: EdgeInsets.only(left: 40),
      height: _deviceheight! * 0.15,
      width: _deviceheight! * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(_firebaseService?.currentUser!['image']),
        ),
      ),
    );
  }
}
