import 'package:flutter/material.dart';
import 'package:xculturetestapi/widgets/no_account_text.dart';
import '../../../size_config.dart';
import 'sign_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Enjoy your time with Xculture!",
                  textAlign: TextAlign.center, 
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SizedBox(height: getProportionateScreenHeight(20)),
                NoAccountText(text: "Don't have an account? "),
                Text(
                  "or",
                  textAlign: TextAlign.center, 
                ),
                NoAccountText(text: "Sign in as guest ", isGuest: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
