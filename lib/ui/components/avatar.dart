import 'package:flutter/material.dart';
import 'package:pickupjob/models/models.dart';
import 'package:pickupjob/ui/components/components.dart';

class Avatar extends StatelessWidget {
  Avatar(
    this.user,
  );
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    if (user.photoUrl == '') {
      return LogoGraphicHeader();
    }
    return Hero(
      tag: 'User Avatar Image',
      child: CircleAvatar(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.black,
          radius: 40.0,
          child: ClipOval(
            child: Image.network(
              user.photoUrl,
              fit: BoxFit.cover,
              width: 80.0,
              height: 80.0,
            ),
          )),
    );
  }
}
