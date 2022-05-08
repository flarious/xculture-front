import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/data.dart';
import 'package:xculturetestapi/navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/pages/forum/forum_detail.dart';
import 'package:xculturetestapi/widgets/guesthamburger_widget.dart';
import 'package:xculturetestapi/widgets/hamburger_widget.dart';




class YourForumPage extends StatefulWidget {
  const YourForumPage({ Key? key }) : super(key: key);

  @override
  _YourForumPageState createState() => _YourForumPageState();
}

class _YourForumPageState extends State<YourForumPage> with TickerProviderStateMixin {
  
  // Future List
  Future<List<Forum>>? _futureUserForum;
  Future<List<Forum>>? _futureUserFavoritedForum;
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
    _futureUserFavoritedForum = getUserFavoritedForums();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);

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
                          child: Container(
                            padding: const EdgeInsets.only(left: 30, top: 70),
                            // padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: const Text("Your\nForum",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40),
                            ),
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
                        margin: const EdgeInsets.only(top: 220, left: 0, right: 0, bottom: 0),
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
                              Container (                                  
                                height: 40,
                                margin: const EdgeInsets.only(top: 20),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  focusNode: fieldnode,
                                  onChanged: (value) {
                                      setState((){
                                        searchString = value; 
                                      });
                                  },
                                  
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    hintText: "Search Forum..",
                                    hintStyle: const TextStyle(
                                      color: Colors.grey, // <-- Change this
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                    ),
                                    contentPadding: const EdgeInsets.only(bottom: 10),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    
                                    // prefixIcon: const Icon(Icons.search, color: Colors.grey),
                                    prefixIcon: Icon(Icons.search,
                                          color: fieldnode.hasFocus 
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey),
                                  ),
                                  
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.7),
                                      blurRadius: 3.0,
                                      offset: const Offset(0.0, 4.0),
                                    ),
                                  ],
                                ),
                              ),

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
                                          //snapshot.data!.sort((b, a) => (a.viewed + a.favorited).compareTo((b.viewed + b.favorited)));
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

                                    // Forum
                                    FutureBuilder<List<Forum>>(
                                      future: _futureUserFavoritedForum,
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
                                  ],
                                )
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Tab bar
                      Center(
                        child: Container(
                          height: 45,
                          width: 260,
                          margin: const EdgeInsets.only(top: 195, left: 65, right: 65),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.red, width: 3.0),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                blurRadius: 3.0,
                                offset: const Offset(0.0, 4.0),
                              ),
                            ],
                          ),
                          child: TabBar(
                            controller: _tabController,
                            labelColor: Colors.black,
                            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                            unselectedLabelColor: Colors.grey,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Colors.transparent,
                            labelPadding: const EdgeInsets.all(0),
                            indicatorPadding: const EdgeInsets.all(0),
                            tabs: [

                              _individualTab("Owned"),
                              const Tab(text: "Liked forum")
                            ],
                          ),
                        ),
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
      _futureUserForum = getUserForums();
      _futureUserFavoritedForum = getUserFavoritedForums();
    });
  }

    // Function get profile
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

  Future<List<Forum>> getUserFavoritedForums() async {

    final List<Forum> forumList = [];

    final userToken = await AuthHelper.getToken();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/user/forums/favorites'),
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

  // Divider
  Widget _individualTab(String topic) {
    return Container(
      height: 30,
      padding: const EdgeInsets.all(0),
      width: double.infinity,
      decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.black, width: 1, style: BorderStyle.solid))),
      child: Tab(
        text: topic,
      ),
    );
  }

}




