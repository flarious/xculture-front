import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/model/password.dart';
import 'package:xculturetestapi/pages/hamburger/setting.dart';
import 'package:xculturetestapi/utils/password_info.dart';
import 'package:xculturetestapi/widgets/chagepassfield_widget.dart';
import 'package:xculturetestapi/widgets/profile_widget.dart';
import 'package:xculturetestapi/widgets/textfield_widget.dart';
//import 'package:xculturetestapi/widgets/uploadprofile_widget.dart';
import 'package:xculturetestapi/widgets/uploadprofilepic_widget.dart';

class ChangePasswordPage extends StatefulWidget{
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage>{
  // UserPassword userpassword = UserPasswordInfo.passwordTest;

  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _newConfirmPass = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    /*
    return Scaffold(
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
  );
  */
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text(
      //     "Post Forum",
      //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
      //   ),
      // ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: SingleChildScrollView(
          child: Stack(
            children: [

              //Report text
              Container(
                margin: const EdgeInsets.only(right: 0, left: 0),
                height: 180,
                color: Color.fromRGBO(220, 71, 47, 1),
                child: const Center(
                  child: Text("Change Password", 
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),

              //Back Icon
              Container(
                margin: const EdgeInsets.only(top: 40, left: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 30,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),   
              ),

              //White box(content)
              Container(
                margin: const EdgeInsets.only(top: 150, left: 0, right: 0, bottom: 0),
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Form(
                    key: _formKey, 
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _newPass,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "New password",
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter new password";
                              }
                              else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _newConfirmPass,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Confirm password",
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please comfirm your new password";
                              }
                              else if (value != _newPass.text) {
                                return "Please make sure the passwords match";
                              }
                              else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(height:20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(100, 50),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Change Password"),
                                      content: Text("Do you want to change your account's password?"),
                                      actions: [
                                        FlatButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          }, 
                                          child: Text("No")
                                        ),
                                        FlatButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!.validate()) {
                                              var success =  await AuthHelper.changePass(_newPass.text);
                                              if(success) {
                                                Fluttertoast.showToast(msg: "Your password has been changed.");
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              }
                                              else {
                                                Navigator.pop(context);
                                              }
                                            }
                                            else {
                                              Navigator.pop(context);
                                            }
                                          }, 
                                          child: Text("Yes", style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                      elevation: 24.0,
                                    ),
                                  );
                                }, 
                                child: const Text("Save Changes")
                              ),      
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              )
            ]
          )
        )
      )
    );
  }
}
