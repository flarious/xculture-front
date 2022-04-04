import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/data.dart';
import 'package:xculturetestapi/navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/pages/event/event_all.dart';
import 'package:xculturetestapi/pages/forum/forum_new.dart';
import 'package:xculturetestapi/pages/forum/forum_all.dart';
import 'package:xculturetestapi/pages/forum/forum_detail.dart';
import 'package:xculturetestapi/pages/community/commu_all.dart';
import 'package:xculturetestapi/pages/event/eventdetail_page.dart';
import 'package:xculturetestapi/pages/community/commudetail_page.dart';

import '../../widgets/hamburger_widget.dart';



class SearchPage extends StatefulWidget {
  const SearchPage({ Key? key }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  // TextEditing For Search
  String searchString = "";
  TextEditingController searchController = TextEditingController();

  // About Future List
  Future<List<Event>>? _futureEvent;
  Future<List<Forum>>? _futureForum;
  Future<List<Community>>? _futureCommu;

  // Change color (prefix icon)
  FocusNode fieldnode = FocusNode();

  @override
  void initState() {
    super.initState();
    _futureForum = getForums();
    _futureEvent = getEvents();
    _futureCommu = getCommus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text(
      //     "Search",
      //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
      //   ),
      //   actions: <Widget>[Container()],
      // ),
      body: showTopFive(),
      endDrawer: const NavigationDrawerWidget(),
      bottomNavigationBar: const Navbar(currentIndex: 1),
      // bottomNavigationBar: Navbar.navbar(context, 1),
    );
  }

  FutureOr refreshPage(dynamic value) {
    setState(() {
      _futureForum = getForums();
      _futureEvent = getEvents();
      _futureCommu = getCommus();
    });
  }

  Widget showTopFive() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          children: [
            // Thumbnail Image
            Container(
              margin: const EdgeInsets.only(right: 0, left: 0),
              child: Container(
                height: 300,
                width: 500,
                color: Colors.red,
                child: Container(
                  padding: const EdgeInsets.only(left: 125, top: 30),
                  // padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: const Text("Explore",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40),
                  ),
                ),
              ),
            ),

            Center(
              child: Container (                                  
                height: 40,
                width: 350,
                // margin: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 0),
                margin: const EdgeInsets.only(top: 100),
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
                    hintText: "Search..",
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
                      color: Colors.black.withOpacity(0.7),
                      blurRadius: 3.0,
                      offset: const Offset(0.0, 4.0),
                    ),
                  ],
                ),
              ),
            ),
      
            // Content
            Container(          
              margin: const EdgeInsets.only(top: 160, left: 0, right: 0, bottom: 0),
              child: Container(
                height: 150,
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              )
            ),
            Column(
              children: [
                  // Box Forum
                  Container(
                    margin: const EdgeInsets.only(top: 170, left: 20, right: 20),
                    // margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Text("Trending Forum",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 22),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForumAllPage(value : searchString),
                                settings: RouteSettings(
                                  arguments: _futureForum,
                                ),
                              )
                            ).then(refreshPage);
                          }, 
                          child: const Text("See all")
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 290,
                    child: Container(
                      height: 250,
                      margin: const EdgeInsets.only(left: 5),
                      width: double.maxFinite,
                      child: FutureBuilder<List<Forum>>(
                        builder: (BuildContext context, AsyncSnapshot<List<Forum>> snapshot) {
                          if (snapshot.hasData) {
                            snapshot.data!.sort((b, a) => (a.viewed + a.favorited).compareTo((b.viewed + b.favorited)));
                            return ListView.builder(
                              itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                var contained = searchForum(snapshot.data![index], searchString);
                                return contained ? InkWell(
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    // margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                    width: 300,
                                    // height: 100,
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
                                          width: 300,
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
                                        )
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
                                ) : const SizedBox(height: 20);
                              }
                            );
                          }
                          else {
                            return const CircularProgressIndicator();
                          }
                        },
                        future: _futureForum,
                      )
                    ),
                  ),

                  // Box Event
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    // margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Text("Trending Event",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 22),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                          // Navigator.pushNamed(context, 'forumAllPage', arguments: _futureForum).then(refreshPage);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventAllPage(value : searchString),
                              settings: RouteSettings(
                                arguments: _futureEvent,
                              ),
                            )
                          ).then(refreshPage);
                        }, 
                        child: const Text("See all")),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    height: 250,
                    width: double.maxFinite,
                    child: FutureBuilder<List<Event>>(
                      future: _futureEvent,
                      builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) { 
                        if(snapshot.hasData) {
                          return ListView.builder(
                            itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5, // number of item to display
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              var contained = searchEvent(snapshot.data![index], searchString);
                              var dt = DateTime.parse(snapshot.data![index].date).toLocal();
                              String dateEvent = DateFormat('MMMM dd, yyyy').format(dt);
                              return contained ? InkWell(
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  width: 300,
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
                                      Positioned(
                                        top: 0,
                                        child: Container(
                                          height: 120,
                                          width: 300,
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
                                        )
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 140, left: 20, right: 0, bottom: 0),
                                        /* top: 140,
                                        left: 20, */
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data![index].name,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                              overflow: TextOverflow.ellipsis, // Event name
                                            ),
                                            Text(
                                              dateEvent,
                                              style: const TextStyle(fontSize: 15), // Event date
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              snapshot.data![index].location,
                                              style: const TextStyle(fontSize: 15),
                                              overflow: TextOverflow.ellipsis, // Event loca
                                            ),
                                          ],
                                        )
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
                              ) : const SizedBox(height: 20);
                            }
                          );
                        }
                        else {
                          return const CircularProgressIndicator();
                        }
                      }
                    ),
                  ),

                  // Box Community
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    // margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Text("Trending Community",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 22),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                          // Navigator.pushNamed(context, 'forumAllPage', arguments: _futureForum).then(refreshPage);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommuAllPage(value : searchString),
                              settings: RouteSettings(
                                arguments: _futureCommu,
                              ),
                            )
                          ).then(refreshPage);
                        }, 
                        child: const Text("See all")),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    height: 250,
                    width: double.maxFinite,
                    child: FutureBuilder<List<Community>>(
                      future: _futureCommu,
                      builder: (BuildContext context, AsyncSnapshot<List<Community>> snapshot) { 
                        if(snapshot.hasData) {
                          return ListView.builder(
                            itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5, // number of item to display
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              var contained = searchCommunity(snapshot.data![index], searchString);
                              return InkWell(
                                child: contained ? Container(
                                  margin: const EdgeInsets.all(10),
                                  width: 300,
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
                                      Positioned(
                                        top: 0,
                                        child: Container(
                                          height: 120,
                                          width: 300,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(snapshot.data![index].thumbnail) // Community Image
                                            ),
                                          ),
                                        )
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 140, left: 20, right: 0, bottom: 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data![index].name,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                              overflow: TextOverflow.ellipsis, // Community Title
                                            ),
                                            Text(
                                              snapshot.data![index].shortdesc,
                                              style: const TextStyle(fontSize: 15), // Community Subtitle
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              "Members : ${snapshot.data![index].memberAmount.toString()}",
                                              style: const TextStyle(fontSize: 15), // Community Subtitle
                                            ),
                                          ],
                                        )
                                      )
                                    ],
                                  ),
                                ) : const SizedBox(height: 20),
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
                              );
                            }
                          );
                        }
                        else {
                          return const CircularProgressIndicator();
                        }
                      }
                    ),
                  ),
              ],
            ),
          ],
        ),
      ), 
    );  
  }

  // Function get Forum
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


  // Function get Event
  Future<List<Event>> getEvents() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/events'));
    final List<Event> eventList = [];

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


  // Function get Community
  Future<List<Community>> getCommus() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/communities'));
    final List<Community> commuList = [];

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
