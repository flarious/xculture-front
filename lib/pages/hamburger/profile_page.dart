import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/data.dart';
import 'package:xculturetestapi/navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:xculturetestapi/model/user.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/utils/user_info.dart';
import 'package:xculturetestapi/widgets/number_widget.dart';
import 'package:xculturetestapi/widgets/cardList_widget.dart';
import 'package:xculturetestapi/widgets/hamburger_widget.dart';
import 'package:xculturetestapi/pages/forum/forum_detail.dart';
import 'package:xculturetestapi/widgets/normalprofile_widget.dart';
import 'package:xculturetestapi/pages/hamburger/your_event_page.dart';
import 'package:xculturetestapi/pages/hamburger/your_forum_page.dart';
import 'package:xculturetestapi/pages/hamburger/your_community_page.dart';

import '../community/commudetail_page.dart';
import '../event/eventdetail_page.dart';




// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageStage createState() => _ProfilePageStage();

// }

// class _ProfilePageStage extends State<ProfilePage>{
//   @override
//     Widget build(BuildContext context){
//       final user = UserInfo.userTest;
//       return Scaffold(
//         endDrawer: NavigationDrawerWidget(),
//         appBar: AppBar(
          
//         title: Text('Profile'),
        
//         centerTitle: true,
//         backgroundColor: Colors.red, 
//         ),
//         body : ListView(
//           physics: BouncingScrollPhysics(),
//           children: [
//             const SizedBox(height: 20),
//             NormalProfileWidget(
//               imagePath : user.imagePath,
//               // onclicked: () {
//               //   Navigator.of(context).push(
//               //     MaterialPageRoute(builder: (context)=> EditProfilePage()),
//                 //);
//               //},
//             ),
//             const SizedBox(height: 10),
//             buildName(user),
//             //maybe tags here?? max 3 tags/at least 1 tags
//             NumbersWidget(),
//             const SizedBox(height: 10),
//             buildAboutme(user),
//           SingleChildScrollView(
//             child: Column(
//                children: <Widget>[
//                 buildCardItem(text: 'Forum', icon: Icons.book,onClicked: ()=> selectedItem(context, 0)),
//                 buildCardItem(text: 'Community', icon: Icons.comment,onClicked: ()=> selectedItem(context, 1)),
//                 buildCardItem(text: 'Event', icon: Icons.location_city,onClicked: ()=> selectedItem(context, 2))  // ListView.builder(
//                 //   itemBuilder:(context, index)=>CardListWidget(),
//                 //   shrinkWrap : true,
//                 //  itemCount: 6,
//                 // )
//               ],
//             ),
//           ),
//           ],
//       ),
//     );
//   }
//   Widget buildName(User user) => Column(
//     children: [
//         Text(
//           user.username,
//           style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),
//         )
//     ],
//   );

//   Widget buildAboutme(User user) => Container(
//   padding: EdgeInsets.symmetric(horizontal: 30),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//         Text('About me',
//             style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
//         ),
//       const SizedBox(height: 10),
//           Text(
//             user.about,
//             style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,height: 1.3),
//         ),
//       const SizedBox(height: 25),
//       // Container(
//       //   height: 150,
//       //   //color: Colors.red,
//       //   decoration: BoxDecoration(
//       //     borderRadius: BorderRadius.circular(30),
//       //     color: Colors.grey.shade300,
//       //   ),
//       // )
//         ],
//       )
//     );
// }
// Widget buildCardItem({
//     required String text,
//     required IconData icon,
//     VoidCallback? onClicked,
//   }) {
//     final color = Colors.red;
//     final hoverColor = Colors.red;
   
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 2.5),
//       child: 
//         Card(
//           margin: EdgeInsets.all(1),
//           child: 
//             ListTile(
//               tileColor: Color.fromARGB(255, 235, 235, 235),
//               leading: Icon(icon, color: Color.fromARGB(255, 255, 89, 89),size: 35),
//               title: Text(text, style: TextStyle(fontSize:22, color: Colors.black,fontWeight:FontWeight.w500)),
//               hoverColor: hoverColor,
//               onTap: onClicked,
//             ),
//         ),
//     );
//   }
  
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
//           builder: (context) => YourEventPage(),
//         ));
//         break;       
//     }
//   }


class ProfilePage extends StatefulWidget {
  const ProfilePage({ Key? key }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  // Future<List<Forum>>? _futureForum;
  Future<List<Forum>>? _futureUserForum;
  Future<List<Event>>? _futureUserEvent;
  Future<List<Community>>? _futureUserCommu;

  // final user = UserInfo.userTest;
  Future<User>? userDetail;

  // Change color (prefix icon)
  FocusNode fieldnode = FocusNode();

  // Tab controller
  late TabController _tabController;

  // Search Function
  String searchString = "";
  TextEditingController searchController = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    userDetail = getUserProfile();
    _futureUserForum = getUserForums();
    _futureUserEvent = getUserEvents();
    _futureUserCommu = getUserCommu(); 
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);

  }


    @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<User>(
            future: userDetail,
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData) {
                  return Stack(
                    children: [
                      // Thumbnail Image
                      Container(
                        margin: const EdgeInsets.only(right: 0, left: 0),
                        child: Container(
                          height: 300,
                          width: 500,
                          color: Colors.red,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 50),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Name
                                    Center(
                                        child: Text(
                                          snapshot.data!.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23,
                                            color: Colors.red
                                          ),
                                        ),
                                    ),

                                    // Tags
                                    const Text(
                                      "Interest tag : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.start,
                                        children: snapshot.data!.tags!.map((tag) => Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: Chip(
                                            label: Text(tag.name),
                                          ),
                                        )).toList(),
                                      ),
                                    ),
                                    
                                    // Bio
                                    RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          
                                        ),
                                        children: <TextSpan>[
                                          const TextSpan(
                                            text: "Tell about yourself : ",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                                          ),
                                          TextSpan(
                                            text: snapshot.data!.bio,
                                            style: const TextStyle(fontSize: 16)
                                          )
                                        ]
                                      )
                                    ),

                                  ],
                                ),
                              ),



                              // Tab bar
                              Container(
                                height: 45,
                                // width: 260,
                                // margin: const EdgeInsets.only(top: 195),
                                child: TabBar(
                                  controller: _tabController,
                                  labelColor: Colors.red,
                                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                                  unselectedLabelColor: Colors.grey,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  // indicatorColor: Colors.transparent,
                                  labelPadding: const EdgeInsets.all(0),
                                  indicatorPadding: const EdgeInsets.all(0),
                                  tabs: const [
                                    // _individualTab("Forums"),
                                    // _individualTab("Events"),
                                    Tab(text: "Forums"),
                                    Tab(text: "Events"),
                                    Tab(text: "Communities")
                                  ],
                                ),
                              ), 

                              // Tabbar view
                              Container(
                                height: 400,
                                // color: Colors.red,
                                margin: const EdgeInsets.only(top: 20),
                                width: double.maxFinite,
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [ 
                                    FutureBuilder<List<Forum>>(
                                      builder: (BuildContext context, AsyncSnapshot<List<Forum>> snapshot) {
                                        if (snapshot.hasData) {
                                          snapshot.data!.sort((b, a) => (a.viewed + a.favorited).compareTo((b.viewed + b.favorited)));
                                          return ListView.builder(
                                            itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5,
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (BuildContext context, int index) {
                                              var contained = searchForum(snapshot.data![index], searchString);
                                              return contained ? InkWell(
                                                child: Container(
                                                  margin: const EdgeInsets.all(10),
                                                  // margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                                  width: 100,
                                                  height: 260,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: Colors.lightBlue[100],
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey.withOpacity(0.7),
                                                        blurRadius: 5.0,
                                                        offset: const Offset(0.0, 5.0),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: 120,
                                                        width: 350,
                                                        decoration: BoxDecoration(
                                                          borderRadius: const BorderRadius.only(
                                                            topLeft: Radius.circular(20),
                                                            topRight: Radius.circular(20),
                                                          ),
                                                          image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: NetworkImage(snapshot.data![index].thumbnail) // Forum Image
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 200,
                                                        margin: const EdgeInsets.only(top: 140, left: 20, right: 0, bottom: 20),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(snapshot.data![index].title,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle(
                                                                fontSize: 20.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            Text(snapshot.data![index].subtitle,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: snapshot.data![index].tags.take(2).map((tag) => Padding(
                                                                padding: const EdgeInsets.only(right: 10),
                                                                child: Chip(
                                                                  label: Text(tag.name),
                                                                ),
                                                              )).toList(),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => const ForumDetailPage(),
                                                      settings: RouteSettings(
                                                        arguments: snapshot.data![index],
                                                      ),
                                                    )
                                                  ).then(refreshPage);
                                                },
                                              ) : Container();
                                            }
                                          );
                                        }
                                        else {
                                          return const CircularProgressIndicator();
                                        }
                                      },
                                      future: _futureUserForum,
                                    ),

                                    // Event
                                    FutureBuilder<List<Event>>(
                                      builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
                                        if (snapshot.hasData) {
                                          return ListView.builder(
                                            itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5,
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (BuildContext context, int index) {
                                              var dt = DateTime.parse(snapshot.data![index].date).toLocal();
                                              String dateEvent = DateFormat('MMMM dd, yyyy').format(dt);
                                              var contained = searchEvent(snapshot.data![index], searchString);
                                              return contained ? InkWell(
                                                child: Container(
                                                  margin: const EdgeInsets.all(10),
                                                  // margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                                  width: 100,
                                                  height: 240,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: Colors.lightBlue[100],
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey.withOpacity(0.7),
                                                        blurRadius: 5.0,
                                                        offset: const Offset(0.0, 5.0),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: 120,
                                                        width: 350,
                                                        decoration: BoxDecoration(
                                                          borderRadius: const BorderRadius.only(
                                                            topLeft: Radius.circular(20),
                                                            topRight: Radius.circular(20),
                                                          ),
                                                          image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: NetworkImage(snapshot.data![index].thumbnail) // Event Image
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 200,
                                                        margin: const EdgeInsets.only(top: 140, left: 20, right: 0, bottom: 20),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(snapshot.data![index].name,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle(
                                                                fontSize: 20.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              dateEvent,
                                                              style: const TextStyle(fontSize: 15), // Event date
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                            Text(snapshot.data![index].location,    // Event location
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => const EventDetailPage(),
                                                      settings: RouteSettings(
                                                        arguments: snapshot.data![index],
                                                      ),
                                                    )
                                                  ).then(refreshPage);
                                                },
                                              ) : Container();
                                            }
                                          );
                                        }
                                        else {
                                          return const CircularProgressIndicator();
                                        }
                                      },
                                      future: _futureUserEvent,
                                    ),

                                    // Communities
                                    FutureBuilder<List<Community>>(
                                        builder: (BuildContext context, AsyncSnapshot<List<Community>> snapshot) {
                                          if (snapshot.hasData) {
                                            return ListView.builder(
                                              itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5,
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (BuildContext context, int index) {
                                                var contained = searchCommunity(snapshot.data![index], searchString);
                                                return contained ? InkWell(
                                                  child: Container(
                                                    margin: const EdgeInsets.all(10),
                                                    // margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                                    width: 100,
                                                    height: 240,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      color: Colors.lightBlue[100],
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey.withOpacity(0.7),
                                                          blurRadius: 5.0,
                                                          offset: const Offset(0.0, 5.0),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          height: 120,
                                                          width: 350,
                                                          decoration: BoxDecoration(
                                                            borderRadius: const BorderRadius.only(
                                                              topLeft: Radius.circular(20),
                                                              topRight: Radius.circular(20),
                                                            ),
                                                            image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: NetworkImage(snapshot.data![index].thumbnail) // Event Image
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 200,
                                                          margin: const EdgeInsets.only(top: 140, left: 20, right: 0, bottom: 20),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                snapshot.data![index].name,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: const TextStyle(
                                                                  fontSize: 20.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              Text(
                                                                snapshot.data![index].shortdesc,    // Event location
                                                                overflow: TextOverflow.ellipsis,
                                                                style: const TextStyle(
                                                                  fontSize: 15.0,
                                                                  color: Colors.black,
                                                                )
                                                              ),
                                                              Text(
                                                                "Members : ${snapshot.data![index].memberAmount.toString()}",
                                                                style: const TextStyle(fontSize: 15), // Community Subtitle
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => const CommuDetailPage(),
                                                        settings: RouteSettings(
                                                          arguments: snapshot.data![index],
                                                        ),
                                                      )
                                                    ).then(refreshPage);
                                                  },
                                                ) : Container();
                                              }
                                            );
                                          }
                                          else {
                                            return const CircularProgressIndicator();
                                          }
                                        },
                                        future: _futureUserCommu,
                                      ),
                                  ],
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 70, left: 0, right: 0, bottom: 0),
                        child: const NormalProfileWidget(
                          imagePath: "https://steamuserimages-a.akamaihd.net/ugc/869615759254530873/E55E7391CA55A2131421E856A144897064D32F82/?imw=512&&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
                          // imagePath: user.imagePath,
                        )
                      ),
                                            
                    ],
                  );
              } else {
                return const CircularProgressIndicator();
              }
            }
          ),
        ),
        endDrawer: const NavigationDrawerWidget(),
        bottomNavigationBar: const Navbar(currentIndex: 4),
      ),
    );
  }

    FutureOr refreshPage(dynamic value) {
    setState(() {
      // _futureForum = getForums();
      _futureUserEvent = getUserEvents(); 
      _futureUserForum = getUserForums();
     _futureUserCommu = getUserCommu();
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
      return User(id: "", name: "", profilePic: "", bio: "", email: "", tags: []);
    }
  }


  // Function get user forums
  Future<List<Forum>> getUserForums() async {

    final List<Forum> forumList = [];

    final userToken = await AuthHelper.getToken();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/user/forums'),
      headers: <String, String> {
        'Authorization': 'bearer $userToken'
      }
    );

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

  // Function get user events  
  Future<List<Event>> getUserEvents() async {

    final List<Event> eventList = [];

    final userToken = await AuthHelper.getToken();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/user/events'),
      headers: <String, String> {
        'Authorization': 'bearer $userToken'
      }
    );

    if(response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      decoded.forEach((obj) => eventList.add(Event.fromJson(obj)));
      return eventList;
    } 
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return eventList;
    }

  }


  // Function get user communities  
  Future<List<Community>> getUserCommu() async {

    final List<Community> commuList = [];

    final userToken = await AuthHelper.getToken();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/user/communities'),
      headers: <String, String> {
        'Authorization': 'bearer $userToken'
      }
    );

    if(response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      decoded.forEach((obj) => commuList.add(Community.fromJson(obj)));
      return commuList;
    } 
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return commuList;
    }

  }


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


    // Function Search Event
  bool searchEvent(Event data, String search) {
    var isContain = false;

    if (data.name.toLowerCase().contains(search.toLowerCase())) {
      isContain = true;
    }

    return isContain;

  }

  // Function Search Community
  bool searchCommunity(Community data, String search) {
    var isContain = false;

    if (data.name.toLowerCase().contains(search.toLowerCase())) {
      isContain = true;
    }

    return isContain;

  }

}

