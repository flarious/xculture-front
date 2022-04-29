import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xculturetestapi/pages/hamburger/change_pass.dart';
import 'package:xculturetestapi/pages/hamburger/edit_profile_page.dart';
import 'package:xculturetestapi/pages/hamburger/profile_page.dart';
import 'package:xculturetestapi/pages/hamburger/reauth.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool valNotify1 = true;
  bool valNotify2 = true;
  bool valNotify3 = true;  
  bool valNotify4 = true;
  bool valNotify5 = true;
  onChangeFunction1(bool newValue1){
    setState(() {
      valNotify1 = newValue1;
    });
  }
  onChangeFunction2(bool newValue2){
    setState(() {
      valNotify2 = newValue2;
    });
  }
  onChangeFunction3(bool newValue3){
    setState(() {
      valNotify3 = newValue3;
    });
  }
  onChangeFunction4(bool newValue4){
    setState(() {
      valNotify4 = newValue4;
    });
  }
  onChangeFunction5(bool newValue5){
    setState(() {
      valNotify5 = newValue5;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              // Thumbnail Image
              Container(
                margin: const EdgeInsets.only(right: 0, left: 0),
                height: 180,
                color: Color.fromRGBO(220, 71, 47, 1),
                child: const Center(
                  child: Text("Settings", 
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),

              // Iconbutton back
              Container(
                margin: const EdgeInsets.only(top: 20, left: 20),
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

              // Content
              Container(
                // height: 200,
                margin: const EdgeInsets.only(top: 140, left: 0, right: 0, bottom: 0),
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Account",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(
                        height: 15,
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      buildAccountOptionRow1(context, "Edit Profile"),
                      buildAccountOptionRow2(context, "Change Password"),
                      buildNotificationOptionRow("Recommended System", valNotify5, onChangeFunction5),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.volume_up,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Notifications",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(
                        height: 15,
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      buildNotificationOptionRow("Comments/Replys", valNotify1,onChangeFunction1),
                      buildNotificationOptionRow("Community", valNotify2,onChangeFunction2),
                      buildNotificationOptionRow("Event", valNotify3,onChangeFunction3),
                      buildNotificationOptionRow("Report", valNotify4, onChangeFunction4),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                )
              )
            ]
          )
        )
      )
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Text(
              "Settings",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Account",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            buildAccountOptionRow1(context, "Edit Profile"),
            buildAccountOptionRow2(context, "Change Password"),
            buildNotificationOptionRow("Recommended System", valNotify5, onChangeFunction5),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.volume_up,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Notifications",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            buildNotificationOptionRow("Comments/Replys", valNotify1,onChangeFunction1),
            buildNotificationOptionRow("Community", valNotify2,onChangeFunction2),
            buildNotificationOptionRow("Event", valNotify3,onChangeFunction3),
            buildNotificationOptionRow("Report", valNotify4, onChangeFunction4),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  // Row buildNotificationOptionRow(String title, bool isActive) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(
  //         title,
  //         style: TextStyle(
  //             fontSize: 20,
  //             fontWeight: FontWeight.w500,
  //             color: Colors.grey[600]),
  //       ),
  //       Transform.scale(
  //           scale: 0.7,
  //           child: CupertinoSwitch(
  //             value: isActive,
  //             onChanged: (bool val) {},
  //           ))
  //     ],
  //   );
  // }
  Padding buildNotificationOptionRow(String title, bool value,Function onChangeMetod){
    return Padding(
      padding:const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style:TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600]
          )),
        Transform.scale(
          scale: 0.7,
          child: CupertinoSwitch(
            activeColor: Colors.green,
            trackColor: Colors.grey,
            value: value,
            onChanged: (bool newValue){
              onChangeMetod(newValue);
            },
          ),
        )
       ],
      ),
    );
  }

  GestureDetector buildAccountOptionRow1(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder:(context)=> EditProfilePage()), 
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
  GestureDetector buildAccountOptionRow2(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder:(context)=> const ReAuthPage()), 
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}