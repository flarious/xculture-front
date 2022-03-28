import 'package:flutter/material.dart';
import 'package:xculturetestapi/model/user.dart';
import 'package:xculturetestapi/pages/hamburger/your_community_page.dart';
import 'package:xculturetestapi/pages/hamburger/your_event_page.dart';
import 'package:xculturetestapi/pages/hamburger/your_forum_page.dart';
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
            const SizedBox(height: 10),
            buildName(user),
            //maybe tags here?? max 3 tags/at least 1 tags
            NumbersWidget(),
            const SizedBox(height: 10),
            buildAboutme(user),
          SingleChildScrollView(
            child: Column(
               children: <Widget>[
                buildCardItem(text: 'Forum', icon: Icons.book,onClicked: ()=> selectedItem(context, 0)),
                buildCardItem(text: 'Community', icon: Icons.comment,onClicked: ()=> selectedItem(context, 1)),
                buildCardItem(text: 'Event', icon: Icons.location_city,onClicked: ()=> selectedItem(context, 2))  // ListView.builder(
                //   itemBuilder:(context, index)=>CardListWidget(),
                //   shrinkWrap : true,
                //  itemCount: 6,
                // )
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
            style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,height: 1.3),
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
}
Widget buildCardItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.red;
    final hoverColor = Colors.red;
   
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 2.5),
      child: 
        Card(
          margin: EdgeInsets.all(1),
          child: 
            ListTile(
              tileColor: Color.fromARGB(255, 235, 235, 235),
              leading: Icon(icon, color: Color.fromARGB(255, 255, 89, 89),size: 35),
              title: Text(text, style: TextStyle(fontSize:22, color: Colors.black,fontWeight:FontWeight.w500)),
              hoverColor: hoverColor,
              onTap: onClicked,
            ),
        ),
    );
  }
  
  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => YourForumPage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => YourCommuPage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => YourEventPage(),
        ));
        break;       
    }
  }

