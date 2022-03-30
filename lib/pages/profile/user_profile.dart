import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/helper/auth.dart';

import '../../data.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({ Key? key }) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Future<User>? userDetail;

  @override
  void initState() {
    super.initState();

    userDetail = getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: FutureBuilder<User>(
        future: userDetail,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) { 
          if(snapshot.hasData) {
            return Column(
              children: [
                Text(snapshot.data!.name)
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
          },
        ),
    );
  }

  Future<User> getUserProfile() async {
    final userToken = await AuthHelper.getToken();
    final response = await http.get(
      Uri.parse("http://10.0.2.2:3000/user"),
      headers: <String, String> {
        'Authorization': 'bearer $userToken'
      }
    );

    if(response.statusCode == 200) {
      return User.formJson(jsonDecode(response.body));
    } else {
      Fluttertoast.showToast(msg: "error");
      return User(id: "", name: "", profilePic: "", bio: "", email: "");
    }
  }
}