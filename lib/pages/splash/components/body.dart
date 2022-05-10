import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/constants.dart';
import 'package:xculturetestapi/data.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/pages/forum/forum_home.dart';
import 'package:xculturetestapi/pages/sign_in/sign_in_screen.dart';
import 'package:xculturetestapi/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// This is the best practice
import '../components/splash_content.dart';
import 'package:xculturetestapi/widgets/default_button.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to Xculture",
      "image": "assets/images/Brazuca.png"
    },

  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"],
                  text: splashData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    Spacer(flex: 3),
                    DefaultButton(
                      text: "Continue",
                      press: () async {
                        if (AuthHelper.checkAuth()) {
                          var success = await isNotBanned();
                          if (success) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForumPage(),
                              )
                            );
                          }
                        }
                        else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                            )
                          );
                        }
                        
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Future<bool> isNotBanned() async {
    final userToken = await AuthHelper.getToken();
    final response = await http.get(
      Uri.parse("https://xculture-server.herokuapp.com/user"),
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
      print(1);
      return false;
    }
  }

  Future<bool> unbanByExpired() async {
    final userToken = await AuthHelper.getToken();
    final response = await http.put(
      Uri.parse("https://xculture-server.herokuapp.com/user/unban"),
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
