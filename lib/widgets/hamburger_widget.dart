import 'package:flutter/material.dart';
import 'package:xculturetestapi/pages/hamburger/Setting.dart';
import 'package:xculturetestapi/pages/hamburger/profile_page.dart';
import 'package:xculturetestapi/pages/hamburger/profilepic_page.dart';
import 'package:xculturetestapi/pages/hamburger/your_forum_page.dart';
import 'package:xculturetestapi/pages/hamburger/your_community_page.dart';
import 'package:xculturetestapi/pages/hamburger/your_event_page.dart';
import 'package:xculturetestapi/model/user.dart';
import 'package:xculturetestapi/utils/user_info.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 23);
  @override
  Widget build(BuildContext context) {
    final user = UserInfo.userTest;
    
    // final name = 'Chat_eiei';
    // final username = 'SE@gmail.com';
    // final urlImage ='https://images.unsplash.com/photo-1537151672256-6caf2e9f8c95?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80';

    return Drawer(
      child: Material(
        color: Color.fromRGBO(0,0, 0,0),
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: user.imagePath,
              name: user.username,
              email: user.email,
              onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserPage(
                  name: user.username,
                  urlImage: user.imagePath,
                ),
              )),
            ),
            Container(
              padding: padding,
              child: Column(
                children: [
                  //const SizedBox(height: 12),
                  // buildSearchField(),
                Divider(height: 15,thickness: 4,),
                // const SizedBox(height: 0),
                  buildMenuItem(
                    text: 'Profile',
                    icon: Icons.person,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  const SizedBox(height: 10),
                  buildMenuItem(
                    text: 'Community',
                    icon: Icons.comment,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const SizedBox(height: 10),
                  buildMenuItem(
                    text: 'Forum',
                    icon: Icons.book_outlined,
                    //icon: Icons.article_outlined,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  const SizedBox(height: 10),
                  buildMenuItem(
                    text: 'Event',
                    icon: Icons.location_on_outlined,
                    onClicked: () => selectedItem(context, 3),
                  ),
                  const SizedBox(height: 24),
                  Divider(height: 15,thickness: 4,),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Setting',
                    icon: Icons.settings,
                    onClicked: () => selectedItem(context, 4),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Sign out',
                    icon: Icons.logout_sharp,
                    onClicked: () => selectedItem(context, 5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 25, color: Colors.red),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    email,
                    style: TextStyle(fontSize: 13, color: Colors.red),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      );

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.red;
    final hoverColor = Colors.red;
   
    return ListTile(
      leading: Icon(icon, color: color,size: 35),
      title: Text(text, style: TextStyle(fontSize:22, color: Colors.red)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }
 //style: TextStyle(fontSize: 13, color: Colors.white),
  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => YourCommuPage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => YourForumPage(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => YourEventPage(),
        ));
      break;    
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SettingsPage(),
        ));
      break;          
    }
  }//selected page
}
