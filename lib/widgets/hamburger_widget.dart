import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/data.dart';
import 'package:xculturetestapi/navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/pages/hamburger/Setting.dart';
import 'package:xculturetestapi/pages/hamburger/profile_page.dart';
import 'package:xculturetestapi/pages/hamburger/profilepic_page.dart';
import 'package:xculturetestapi/pages/hamburger/your_forum_page.dart';
import 'package:xculturetestapi/pages/hamburger/your_community_page.dart';
import 'package:xculturetestapi/pages/hamburger/your_event_page.dart';
import 'package:xculturetestapi/pages/splash/splash_screen.dart';
// import 'package:xculturetestapi/model/user.dart';
import 'package:xculturetestapi/utils/user_info.dart';


import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/pages/forum/forum_detail.dart';
import 'package:xculturetestapi/widgets/normalprofile_widget.dart';
import 'package:xculturetestapi/pages/hamburger/your_event_page.dart';
import 'package:xculturetestapi/pages/hamburger/your_forum_page.dart';
import 'package:xculturetestapi/pages/hamburger/your_community_page.dart';

// class NavigationDrawerWidget extends StatelessWidget {
//   final padding = EdgeInsets.symmetric(horizontal: 23);

//   @override
//   Widget build(BuildContext context) {
    

//     final user = UserInfo.userTest;
    
//     // final name = 'Chat_eiei';
//     // final username = 'SE@gmail.com';
//     // final urlImage ='https://images.unsplash.com/photo-1537151672256-6caf2e9f8c95?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80';

//     return Scaffold(
//       body: SafeArea(
//         child: Drawer(
//           child: Material(
//             color: Color.fromRGBO(0,0, 0,0),
//             child: ListView(
//               children: <Widget>[
//                 buildHeader(
//                   urlImage: user.imagePath,
//                   name: user.username,
//                   email: user.email,
//                   onClicked: () => Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => UserPage(
//                       name: user.username,
//                       urlImage: user.imagePath,
//                     ),
//                   )),
//                 ),
//                 Container(
//                   padding: padding,
//                   child: Column(
//                     children: [
//                       //const SizedBox(height: 12),
//                       // buildSearchField(),
//                     Divider(height: 15, thickness: 4,),
//                     // const SizedBox(height: 0),
//                       buildMenuItem(
//                         text: 'Profile',
//                         icon: Icons.person,
//                         onClicked: () => selectedItem(context, 0),
//                       ),
//                       const SizedBox(height: 10),
//                       buildMenuItem(
//                         text: 'Community',
//                         icon: Icons.comment,
//                         onClicked: () => selectedItem(context, 1),
//                       ),
//                       const SizedBox(height: 10),
//                       buildMenuItem(
//                         text: 'Forum',
//                         icon: Icons.book_outlined,
//                         //icon: Icons.article_outlined,
//                         onClicked: () => selectedItem(context, 2),
//                       ),
//                       const SizedBox(height: 10),
//                       buildMenuItem(
//                         text: 'Event',
//                         icon: Icons.location_on_outlined,
//                         onClicked: () => selectedItem(context, 3),
//                       ),
//                       const SizedBox(height: 24),
//                       Divider(height: 15,thickness: 4,),
//                       const SizedBox(height: 24),
//                       buildMenuItem(
//                         text: 'Setting',
//                         icon: Icons.settings,
//                         onClicked: () => selectedItem(context, 4),
//                       ),
//                       const SizedBox(height: 16),
//                       buildMenuItem(
//                         text: 'Sign out',
//                         icon: Icons.logout_sharp,
//                         onClicked: () => selectedItem(context, 5),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildHeader({
//     required String urlImage,
//     required String name,
//     required String email,
//     required VoidCallback onClicked,
//   }) =>
//       InkWell(
//         onTap: onClicked,
//         child: Container(
//           padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
//           child: Row(
//             children: [
//               CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
//               SizedBox(width: 25),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: TextStyle(fontSize: 25, color: Colors.red),
//                   ),
//                   const SizedBox(height: 3),
//                   Text(
//                     email,
//                     style: TextStyle(fontSize: 13, color: Colors.red),
//                   ),
//                 ],
//               ),
//               Spacer(),
//             ],
//           ),
//         ),
//       );

//   Widget buildMenuItem({
//     required String text,
//     required IconData icon,
//     VoidCallback? onClicked,
//   }) {
//     final color = Colors.red;
//     final hoverColor = Colors.red;
   
//     return ListTile(
//       leading: Icon(icon, color: color,size: 35),
//       title: Text(text, style: TextStyle(fontSize:22, color: Colors.red)),
//       hoverColor: hoverColor,
//       onTap: onClicked,
//     );
//   }
//  //style: TextStyle(fontSize: 13, color: Colors.white),
//   void selectedItem(BuildContext context, int index) {
//     Navigator.of(context).pop();
//     switch (index) {
//       case 0:
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => ProfilePage(),
//         ));
//         break;
//       case 1:
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => YourCommuPage(),
//         ));
//         break;
//       case 2:
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => YourForumPage(),
//         ));
//         break;
//       case 3:
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => YourEventPage(),
//         ));
//       break;    
//       case 4:
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => SettingsPage(),
//         ));
//       break;          
//     }
//   } //selected page

// }

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({ Key? key }) : super(key: key);

  @override
  _NavigationDrawerWidgetState createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> with TickerProviderStateMixin {
  // Future<List<Forum>>? _futureForum;

  // final user = UserInfo.userTest;
  Future<User>? userDetail;

  
  @override
  void initState() {
    super.initState();
    // _futureForum = getForums();
    userDetail = getUserProfile();

  }


    @override
  Widget build(BuildContext context) {
    
    return  FutureBuilder<User>(
            future: userDetail,
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData) {
                  return Drawer(
                    child: Material(
                      color: const Color.fromRGBO(0, 0, 0, 0),
                        child: ListView(
                          children: <Widget>[
                            buildHeader(
                              urlImage: snapshot.data!.profilePic,
                              name: snapshot.data!.name,
                              email: snapshot.data!.email!,
                              onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UserPage(
                                  name: snapshot.data!.name,
                                  urlImage: snapshot.data!.profilePic,
                                ),
                              )),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(height: 15, thickness: 2),

                                  const SizedBox(height: 24),

                                  buildMenuItem(
                                    text: 'Profile',
                                    icon: Icons.person,
                                    onClicked: () => selectedItem(context, 0),
                                  ),

                                  const SizedBox(height: 10),

                                  buildMenuItem(
                                    text: 'Your Community',
                                    icon: Icons.comment,
                                    onClicked: () => selectedItem(context, 1),
                                  ),

                                  const SizedBox(height: 10),

                                  buildMenuItem(
                                    text: 'Your Forum',
                                    icon: Icons.book,
                                    //icon: Icons.article_outlined,
                                    onClicked: () => selectedItem(context, 2),
                                  ),

                                  const SizedBox(height: 10),

                                  buildMenuItem(
                                    text: 'Your Event',
                                    icon: Icons.location_on,
                                    onClicked: () => selectedItem(context, 3),
                                  ),

                                  const SizedBox(height: 24),

                                  const Divider(height: 15,thickness: 2),

                                  const SizedBox(height: 24),

                                  buildMenuItem(
                                    text: 'Setting',
                                    icon: Icons.settings,
                                    onClicked: () => selectedItem(context, 4),
                                  ),

                                  const SizedBox(height: 10),

                                  buildMenuItem(
                                    text: 'Sign out',
                                    icon: Icons.logout,
                                    onClicked: () => selectedItem(context, 5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  );
              } else {
                return const CircularProgressIndicator();
              }
            }
          );
        // Navbar
        // bottomNavigationBar: Navbar.navbar(context, 4),

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
          padding: EdgeInsets.only(top: 20),
          // color: Colors.amber,
          // padding: const EdgeInsets.symmetric(vertical: 40),
          child: Row(
            children: [
              SizedBox(width: 25),
              CircleAvatar(radius: 30, backgroundImage: urlImage == "" ? const AssetImage("assets/images/User_icon.jpg") : NetworkImage(urlImage) as ImageProvider),
              SizedBox(width: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 25, color: Colors.red),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 13, color: Colors.red),
                  ),
                ],
              ),
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
      title: Text(text, style: const TextStyle(fontSize:22, color: Colors.red)),
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
          builder: (context) => const ProfilePage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const YourCommuPage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const YourForumPage(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const YourEventPage(),
        ));
      break;    
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SettingsPage(),
        ));
      break;
      case 5:
        AuthHelper.signOut();     
        // Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SplashScreen(),
        ));     
    }
  } //selected page


    FutureOr refreshPage(dynamic value) {
    setState(() {
      // _futureForum = getForums();
      // userDetail = getUserProfile();
    });
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
      return User(id: "", name: "", profilePic: "", bio: "", email: "", lastBanned: "", userType: "", bannedAmount: 0, tags: []);
    }
  }


  Future<List<Forum>> getForums() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/forums'));
    final List<Forum> forumList = [];

    if(response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      decoded.forEach((obj) => forumList.add(Forum.fromJson(obj)));
      return forumList;
    } 
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return forumList;
    }
  } 

  // Future<Forum> getUserForums(uid) async {
  //   final response =
  //       await http.get(Uri.parse('http://10.0.2.2:3000/user/$uid'));

  //   if (response.statusCode == 200) {
  //     return Forum.fromJson(jsonDecode(response.body));
  //   } else {
  //     Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
  //     Navigator.pop(context);
  //     return Forum(id: "", title: "", subtitle: "", content: "", thumbnail: "", author: User(id: "", name: "", profilePic: "", bio: ""), 
  //     incognito: false, viewed: 0, favorited: 0, date: DateTime.now().toString(), updateDate: DateTime.now().toString(), comments: [], tags: []);
  //   }
  // }


  // Function Search Forum
  bool searchForum(Forum data, String search) {
    var isContain = false;

    if (data.title.toLowerCase().contains(search.toLowerCase())) {
      isContain = true;
    }
    else if (data.tags.isNotEmpty) {
      for (var tag in data.tags) {
        if(tag.name.toLowerCase().contains(search.toLowerCase())) {
          isContain = true;
        }
      }
    }

    return isContain;

  }

}
