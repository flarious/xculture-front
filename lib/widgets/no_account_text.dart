import 'package:flutter/material.dart';
import 'package:xculturetestapi/pages/forum/forum_home.dart';
import 'package:xculturetestapi/pages/sign_up/sign_up_screen.dart';

import '../constants.dart';
import '../size_config.dart';

class NoAccountText extends StatelessWidget {
  final String text;
  bool? isGuest; 

  NoAccountText({
    required this.text,
    this.isGuest = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),

        isGuest == false ? GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpScreen(),
            )
          ),
          // Navigator.pushNamed(context, SignUpScreen.routeName),
          child: Text(
            "Sign Up",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
                color: kPrimaryColor),
          ),
        ): GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const ForumPage()
            ));
          },
          // Navigator.pushNamed(context, SignUpScreen.routeName),
          child: Text(
            "Here",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
                color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
