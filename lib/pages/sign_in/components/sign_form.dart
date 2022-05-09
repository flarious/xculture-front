import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:xculturetestapi/data.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/helper/keyboard.dart';
import 'package:xculturetestapi/pages/forum/forum_home.dart';
import 'package:xculturetestapi/pages/profile/profile_screen.dart';
import 'package:xculturetestapi/pages/splash/splash_screen.dart';
import 'package:xculturetestapi/widgets/custom_surfix_icon.dart';
import 'package:xculturetestapi/widgets/default_button.dart';
import 'package:xculturetestapi/widgets/form_error.dart';
// import 'package:shop_app/components/custom_surfix_icon.dart';
// import 'package:shop_app/components/form_error.dart';
// import 'package:shop_app/helper/keyboard.dart';
// import 'package:shop_app/screens/home/home_screen.dart';

// import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:http/http.dart' as http;

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
  
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Login",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                KeyboardUtil.hideKeyboard(context);
                var success = await AuthHelper.signIn(email!, password!);
                if (success) {
                  var success2 = await isNotBanned();
                  if (success2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForumPage(),
                      )
                    );
                  }
                  else {
                    AuthHelper.signOut();
                  }
                }
                
                  // Navigator.pushNamed(context, ProfileScreen.routeName);//Go to forum page
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
  
  Future<bool> isNotBanned() async {
    final userToken = await AuthHelper.getToken();
    final response = await http.get(
      Uri.parse("http://10.0.2.2:3000/user"),
      headers: <String, String> {
        'Authorization': 'bearer $userToken'
      }
    );

    if (response.statusCode == 200) {
      final user = User.formJson(jsonDecode(response.body));
      if(user.userType != "banned") {
        return true;
      }
      else {
        final banExpired = DateTime.parse(user.lastBanned!).toLocal().add(Duration(hours: user.bannedAmount!));
        final formattedBanExpired = DateFormat('MMMM dd, yyyy – HH:mm a').format(banExpired);
        if (!banExpired.isAfter(DateTime.now())) {
          var success = await unbanByExpired();
          if (success) {
            return true;
          }
          else {
            return false;
          }
        }
        else {
          Fluttertoast.showToast(msg: "You are banned. The ban will be lifted in $formattedBanExpired");
          return false;
        }
      }
    }
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return false;
    }
  }

  Future<bool> unbanByExpired() async {
    final userToken = await AuthHelper.getToken();
    final response = await http.put(
      Uri.parse("http://10.0.2.2:3000/user/unban"),
      headers: <String, String> {
        'Authorization': 'bearer $userToken'
      }
    );

    if (response.statusCode == 200) {
      return true;
    } 
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return false;
    }
  }
}
