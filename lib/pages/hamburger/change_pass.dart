import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xculturetestapi/model/password.dart';
import 'package:xculturetestapi/utils/password_info.dart';
import 'package:xculturetestapi/widgets/chagepassfield_widget.dart';
import 'package:xculturetestapi/widgets/profile_widget.dart';
import 'package:xculturetestapi/widgets/textfield_widget.dart';
//import 'package:xculturetestapi/widgets/uploadprofile_widget.dart';
import 'package:xculturetestapi/widgets/uploadprofilepic_widget.dart';

class ChangePasswordPage extends StatefulWidget{
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage>{
  UserPassword userpassword = UserPasswordInfo.passwordTest;
  @override
  Widget build(BuildContext context) {
    
    return GetMaterialApp(
        theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: "Poppins",
      ),
        home: 
          Scaffold(
              appBar: AppBar(
              title: Text('Change Password'),
              centerTitle: true,
              backgroundColor: Colors.red,
            ),
            body: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 32),
              physics: BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 40),
                ChangePassTextFiledWidget(
                  label: 'Current Password', 
                  text: userpassword.Password, 
                  onChanged: (password){}
                ),
                const SizedBox(height: 20),
                ChangePassTextFiledWidget(
                  label: 'New Password', 
                  text: userpassword.NewPassword, 
                 // maxLines:5,
                  onChanged: (newpassword){},
                ),
                const SizedBox(height: 20),
                ChangePassTextFiledWidget(
                  label: 'Confirm New Password', 
                  text: userpassword.ConfirmNewPassword, 
                 // maxLines:5,
                  onChanged: (confirmnewpassword){},
                ),
                const SizedBox(height:20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(350, 50),
                      ),
                      onPressed: () async {}, 
                        child: const Text("Save Changes")
                      ),        
              ],
            ),
          ),
  );
}
}
