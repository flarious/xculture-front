import 'package:flutter/material.dart';
import 'package:xculturetestapi/model/user.dart';
import 'package:xculturetestapi/utils/user_info.dart';
import 'package:xculturetestapi/widgets/profile_widget.dart';
import 'package:xculturetestapi/widgets/textfield_widget.dart';

class EditProfilePage extends StatefulWidget{
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage>{
  User user = UserInfo.userTest;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
      title: Text('Edit Profile'),
      centerTitle: true,
      backgroundColor: Colors.red,
    ),
    body: ListView(
      padding: EdgeInsets.symmetric(horizontal: 32),
      physics: BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 20),
        ProfileWidget(
          imagePath: user.imagePath, 
          isEdit : true,
          onclicked: () async{},
          ),
        const SizedBox(height: 20),
        TextFieldWidget(
          label: 'Username', 
          text: user.username, 
          onChanged: (name){}
        ),
        const SizedBox(height: 20),
        TextFieldWidget(
          label: 'About me', 
          text: user.about, 
          maxLines:7,
          onChanged: (about){}
        ),    
      ],
    ),
  );
}