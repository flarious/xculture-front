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
import 'package:xculturetestapi/widgets/guesthamburger_widget.dart';
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
  Future<List<Community>>? _futureUserJoinedCommu;

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
    _futureUserJoinedCommu = getUserJoinedCommu();
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

                                    const SizedBox(height: 20),
                                    
                                    // Tags
                                    const Text(
                                      "Interest tag : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
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

                                    Row(
                                      children: [
                                        Text(
                                          "Bio : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),

                                        Text(
                                          snapshot.data!.bio.toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    // // Bio
                                    // RichText(
                                    //   textAlign: TextAlign.left,
                                    //   text: TextSpan(
                                    //     style: const TextStyle(
                                    //       fontSize: 15,
                                    //       color: Colors.black,
                                    //       fontFamily: 'Poppins',
                                    //     ),
                                    //     children: <TextSpan>[
                                    //       const TextSpan(
                                    //         text: "Tell about yourself : ",
                                    //         //style: TextStyle(fontWeight: FontWeight.bold)
                                    //       ),
                                    //       TextSpan(
                                    //         text: snapshot.data!.bio,
                                    //       )
                                    //     ]
                                    //   )
                                    // ),

                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Tab bar
                              SizedBox(
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
                                    // Forum
                                    FutureBuilder<List<Forum>>(
                                      future: _futureUserForum,
                                      builder: (BuildContext context, AsyncSnapshot<List<Forum>> snapshot){
                                        if (snapshot.hasData) {
                                          snapshot.data!.sort((b, a) => (a.viewed + a.favorited).compareTo((b.viewed + b.favorited)));
                                          return ListView.separated(
                                            itemCount: snapshot.data!.length,
                                            scrollDirection: Axis.vertical,
                                            separatorBuilder: (BuildContext context, int index) { 
                                              return const SizedBox(height: 15); 
                                            },
                                            itemBuilder: (BuildContext context, int index) {
                                              var contained = searchForum(snapshot.data![index], searchString);
                                              return contained ? Card(
                                                  //elevation: 4.0,
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20)
                                                  ),
                                                  child: InkWell(
                                                    child: SizedBox(
                                                      width: double.maxFinite,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          Ink.image(
                                                            image: NetworkImage(snapshot.data![index].thumbnail),
                                                            height: 150,
                                                            fit: BoxFit.cover,
                                                          ),

                                                          Padding(
                                                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                                            child: Text(snapshot.data![index].title,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle(
                                                                fontSize: 25.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),

                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                                            child: Text(snapshot.data![index].subtitle,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),

                                                          SizedBox(
                                                            width: double.maxFinite,
                                                            height: 60,
                                                            child: ListView(
                                                              scrollDirection: Axis.horizontal,
                                                              children: snapshot.data![index].tags.map((tag) => Padding(
                                                                padding: const EdgeInsets.only(left: 10),
                                                                child: Chip(
                                                                  label: Text(tag.name),
                                                                ),
                                                              )).toList(),
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
                                                  ), 
                                                ): Container();
                                            },
                                          );
                                        }
                                        else {
                                            return const CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                    
                                    // Event
                                    FutureBuilder<List<Event>>(
                                      future: _futureUserEvent,
                                      builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot){
                                        if (snapshot.hasData) {
                                          snapshot.data!.sort((b, a) => (a.interestedAmount).compareTo((b.interestedAmount)));
                                          return ListView.separated(
                                            itemCount: snapshot.data!.length,
                                            scrollDirection: Axis.vertical,
                                            separatorBuilder: (BuildContext context, int index) { 
                                              return const SizedBox(height: 15); 
                                            },
                                            itemBuilder: (BuildContext context, int index) {
                                              var dt = DateTime.parse(snapshot.data![index].eventDate).toLocal();
                                              String dateEvent = DateFormat('MMMM dd, yyyy').format(dt);
                                              var contained = searchEvent(snapshot.data![index], searchString);
                                              return contained ? Card(
                                                  //elevation: 4.0,
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20)
                                                  ),
                                                  child: InkWell(
                                                    child: SizedBox(
                                                      width: double.maxFinite,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          Ink.image(
                                                            image: NetworkImage(snapshot.data![index].thumbnail),
                                                            height: 150,
                                                            fit: BoxFit.cover,
                                                          ),

                                                          Padding(
                                                            padding: const EdgeInsets.all(10.0),
                                                            child: Text(snapshot.data![index].name,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle(
                                                                fontSize: 25.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),

                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                                            child: Text(dateEvent,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),

                                                          //const SizedBox(height: 10),
                                                          
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                                            child: Text(snapshot.data![index].location,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),

                                                          const SizedBox(height: 10),
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
                                                  ), 
                                                ): Container();
                                            },
                                          );
                                        }
                                        else {
                                            return const CircularProgressIndicator();
                                        }
                                      },
                                    ),

                                    // Communities
                                    FutureBuilder<List<Community>>(
                                      future: _futureUserJoinedCommu,
                                      builder: (BuildContext context, AsyncSnapshot<List<Community>> snapshot){
                                        if (snapshot.hasData) {
                                          snapshot.data!.sort((b, a) => (a.memberAmount).compareTo((b.memberAmount)));
                                          return ListView.separated(
                                            itemCount: snapshot.data!.length,
                                            scrollDirection: Axis.vertical,
                                            separatorBuilder: (BuildContext context, int index) { 
                                              return const SizedBox(width: 15); 
                                            },
                                            itemBuilder: (BuildContext context, int index) {
                                              var contained = searchCommunity(snapshot.data![index], searchString);
                                              return contained ? Card(
                                                  //elevation: 4.0,
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20)
                                                  ),
                                                  child: InkWell(
                                                    child: SizedBox(
                                                      width: double.maxFinite,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          Ink.image(
                                                            image: NetworkImage(snapshot.data![index].thumbnail),
                                                            height: 150,
                                                            fit: BoxFit.cover,
                                                          ),

                                                          Padding(
                                                            padding: const EdgeInsets.all(10.0),
                                                            child: Text(snapshot.data![index].name,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle(
                                                                fontSize: 25.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),

                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                                            child: Text(snapshot.data![index].shortdesc,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),

                                                          //const SizedBox(height: 10),

                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                                            child: Text("Members : ${snapshot.data![index].memberAmount.toString()}",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),

                                                          const SizedBox(height: 10),
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
                                                  ), 
                                                ): Container();
                                            },
                                          );
                                        }
                                        else {
                                            return const CircularProgressIndicator();
                                        }
                                      },
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
                        child: NormalProfileWidget(
                          imagePath: snapshot.data!.profilePic,
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
        endDrawer: AuthHelper.checkAuth() ? const NavigationDrawerWidget() : const GuestHamburger(),
        bottomNavigationBar: const Navbar(currentIndex: 4),
      ),
    );
  }

    FutureOr refreshPage(dynamic value) {
    setState(() {
      userDetail = getUserProfile();
      _futureUserEvent = getUserEvents(); 
      _futureUserForum = getUserForums();
     _futureUserCommu = getUserCommu();
     _futureUserJoinedCommu = getUserJoinedCommu();
    });
  }


  Future<User> getUserProfile() async {
    final userToken = await AuthHelper.getToken();
    final response = await http.get(
      Uri.parse("https://xculture-server.herokuapp.com/user"),
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


  // Function get user forums
  Future<List<Forum>> getUserForums() async {

    final List<Forum> forumList = [];

    final userToken = await AuthHelper.getToken();
    final response = await http.get(
      Uri.parse('https://xculture-server.herokuapp.com/user/forums'),
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
      Uri.parse('https://xculture-server.herokuapp.com/user/events'),
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
      Uri.parse('https://xculture-server.herokuapp.com/user/communities'),
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

  // Function get user joined communities  
  Future<List<Community>> getUserJoinedCommu() async {

    final List<Community> commuList = [];

    final userToken = await AuthHelper.getToken();
    final response = await http.get(
      Uri.parse('https://xculture-server.herokuapp.com/user/communities/joined'),
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

