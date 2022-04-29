import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/model/password.dart';
import 'package:xculturetestapi/pages/hamburger/change_pass.dart';
import 'package:xculturetestapi/utils/password_info.dart';
import 'package:xculturetestapi/widgets/chagepassfield_widget.dart';
import 'package:xculturetestapi/widgets/profile_widget.dart';
import 'package:xculturetestapi/widgets/textfield_widget.dart';
//import 'package:xculturetestapi/widgets/uploadprofile_widget.dart';
import 'package:xculturetestapi/widgets/uploadprofilepic_widget.dart';

class ReAuthPage extends StatefulWidget{
  const ReAuthPage({Key? key}) : super(key: key);

  @override
  _ReAuthPageState createState() => _ReAuthPageState();
}

class _ReAuthPageState extends State<ReAuthPage>{
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Text("Re-authentication", 
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
                          //Description
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: Text("You need to sign in again before changing the password",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            controller: _email,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              }
                              else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _password,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your password";
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
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    var success =  await AuthHelper.reauth(_email.text, _password.text);
                                    if(success) {
                                      Navigator.push(
                                        context, 
                                        MaterialPageRoute(
                                          builder: (context) => const ChangePasswordPage()
                                        )
                                      );
                                    }
                                  }
                                },
                                child: const Text("Next")
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
