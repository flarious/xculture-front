import 'package:flutter/material.dart';
import 'package:xculturetestapi/model/user.dart';
import 'package:xculturetestapi/widgets/hamburger_widget.dart';
import 'package:xculturetestapi/widgets/number_widget.dart';
import 'package:xculturetestapi/widgets/cardList_widget.dart';
import 'package:xculturetestapi/widgets/normalprofile_widget.dart';
import 'package:xculturetestapi/utils/user_info.dart';
//import 'package:xculturetestapi/widgets/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageStage createState() => _ProfilePageStage();
  }

class _ProfilePageStage extends State<ProfilePage>{
  @override
    Widget build(BuildContext context){
      final user = UserInfo.userTest;

      return Scaffold(
         endDrawer: NavigationDrawerWidget(),
        appBar: AppBar(
          
        title: Text('Profile'),
        
        centerTitle: true,
        backgroundColor: Colors.red, 
        ),
        body : ListView(
          physics: BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 20),
            NormalProfileWidget(
              imagePath : user.imagePath,
              // onclicked: () {
              //   Navigator.of(context).push(
              //     MaterialPageRoute(builder: (context)=> EditProfilePage()),
                //);
              //},
            ),
            const SizedBox(height: 20),
            buildName(user),
            //maybe tags here?? max 3 tags/at least 1 tags
            NumbersWidget(),
            const SizedBox(height: 25),
            buildAboutme(user),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListView.builder(
                  itemBuilder:(context, index)=>CardListWidget(),
                  shrinkWrap : true,
                  itemCount: 4,
                )
              ],
            ),
          ),
          ],
      ),
    );
  }
  
  Widget buildName(User user) => Column(
    children: [
        Text(
          user.username,
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),
        )
    ],
  );

  Widget buildAboutme(User user) => Container(
  padding: EdgeInsets.symmetric(horizontal: 30),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
        Text('About me',
            style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
        ),
      const SizedBox(height: 10),
          Text(
            user.about,
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,height: 1.3),
        ),
      const SizedBox(height: 25),
      // Container(
      //   height: 150,
      //   //color: Colors.red,
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(30),
      //     color: Colors.grey.shade300,
      //   ),
      // )
        ],
      )
    );
// GestureDetector buildListOfActivities(BuildContext context, String title) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(builder:(context)=> EditProfilePage()), 
//         );
//       },
//     );
//   }
}
