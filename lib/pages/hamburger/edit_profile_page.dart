import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xculturetestapi/model/user.dart';
import 'package:xculturetestapi/utils/user_info.dart';
import 'package:xculturetestapi/widgets/profile_widget.dart';
import 'package:xculturetestapi/widgets/textfield_widget.dart';
//import 'package:xculturetestapi/widgets/uploadprofile_widget.dart';
import 'package:xculturetestapi/widgets/uploadprofilepic_widget.dart';

class EditProfilePage extends StatefulWidget{
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage>{
  User user = UserInfo.userTest;

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
              title: Text('Edit Profile'),
              centerTitle: true,
              backgroundColor: Colors.red,
            ),
            body: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 32),
              physics: BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 20),
                //const UploadProfileImageWidget(),
                 UploadProfilePicWidget(
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
                  maxLines:5,
                  onChanged: (about){},
                ),
                const SizedBox(height:20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(350, 50),
                      ),
                      onPressed: () async {}, 
                        child: const Text("Edit Profile")
                      ),        
              ],
            ),
          ),
  );
}
}
