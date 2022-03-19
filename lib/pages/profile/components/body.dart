import 'package:flutter/material.dart';
import 'package:xculturetestapi/helper/auth.dart';

import '../user_profile.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 10),
          ProfileMenu(
            text: "My Profile",
            icon: "assets/icons/User Icon.svg",
            press: () => {
              /*
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfilePage(),
                )
              )
              */
            },
          ),
          ProfileMenu(
            text: "My Forum",
            icon: "assets/icons/Bill Icon.svg",
            press: () => {},
          ),
          ProfileMenu(
            text: "Event",
            icon: "assets/icons/Location point.svg",
            press: () => {},
          ),
          ProfileMenu(
            text: "Community",
            icon: "assets/icons/Conversation.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () async {
              await AuthHelper.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
