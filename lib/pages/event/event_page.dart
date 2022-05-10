import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:xculturetestapi/pages/event/event_all.dart';
import 'package:xculturetestapi/widgets/guesthamburger_widget.dart';

import '../../data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:xculturetestapi/navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/pages/event/eventpost_page.dart';
import 'package:xculturetestapi/pages/event/eventdetail_page.dart';

import '../../helper/auth.dart';
import '../../size_config.dart';
import '../../widgets/hamburger_widget.dart';

class EventPage extends StatefulWidget {
  const EventPage({ Key? key }) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {

  Future<List<Event>>? trendingEvent;
  Future<List<Event>>? newestEvent;

  // TextEditing For Search
  String searchString = "";
  TextEditingController searchController = TextEditingController();

  // Change color (prefix icon)
  FocusNode fieldnode = FocusNode();

  @override
  void initState() {
    super.initState();

    trendingEvent = getEvents();
    newestEvent = getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: showTopFiveEvent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (AuthHelper.checkAuth()) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventPostPage(),
                )
              ).then(refreshPage);
            }
            else {
              Fluttertoast.showToast(msg: "You are not signed in");
            }
        },
        child: const Icon(Icons.add_location_alt_outlined)
      ),
      endDrawer: AuthHelper.checkAuth() ? const NavigationDrawerWidget() : const GuestHamburger(),
      bottomNavigationBar: const Navbar(currentIndex: 0),
    );
  }

  FutureOr refreshPage(dynamic value) {
    setState(() {
      trendingEvent = getEvents();
      newestEvent = getEvents();
    });
  }

  Widget showTopFiveEvent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          children: [

           //Post Forum text
            Container(
              //margin: const EdgeInsets.only(right: 0, left: 0),
              height: getProportionateScreenHeight(300),
              color: Colors.red,
              child: Center(
                child: Column(
                  children: [

                    SizedBox(height: getProportionateScreenHeight(30)),

                    Text("Events", 
                      style: TextStyle(fontSize: getProportionateScreenWidth(40), fontWeight: FontWeight.bold, color: Colors.white),
                    ),

                    SizedBox(height: getProportionateScreenHeight(10)),

                    Container (                                  
                      height: getProportionateScreenHeight(40),
                      width: getProportionateScreenWidth(330),
                      // margin: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 0),
                      //margin: const EdgeInsets.only(top: 100),
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
                          hintText: "Search Event..",
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
                  ],
                ),
              ),
            ),
      
            // Content
            Container(          
              margin: EdgeInsets.only(top: getProportionateScreenHeight(180)),
              child: Container(
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

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text("Trending Event",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: getProportionateScreenWidth(22)),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                            // Navigator.pushNamed(context, 'forumAllPage', arguments: _futureForum).then(refreshPage);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventAllPage(value: searchString),
                                settings: RouteSettings(
                                  arguments: trendingEvent,
                                ),
                              )
                            ).then(refreshPage);
                          }, 
                          child: const Text("See all")),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: getProportionateScreenHeight(300),
                      child: FutureBuilder<List<Event>>(
                        future: trendingEvent,
                        builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot){
                          if (snapshot.hasData) {
                            snapshot.data!.sort((b, a) => (a.interestedAmount).compareTo((b.interestedAmount)));
                            return ListView.separated(
                              itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (BuildContext context, int index) { 
                                return SizedBox(width: getProportionateScreenWidth(15)); 
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
                                        width: getProportionateScreenWidth(280),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Ink.image(
                                              image: NetworkImage(snapshot.data![index].thumbnail),
                                              height: getProportionateScreenHeight(170),
                                              fit: BoxFit.cover,
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Text(snapshot.data![index].name,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: getProportionateScreenWidth(23),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Text(dateEvent,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: getProportionateScreenWidth(13),
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),

                                            //const SizedBox(height: 10),
                                            
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Text(snapshot.data![index].location,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: getProportionateScreenWidth(13),
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
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
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                         Text("Newest Event",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: getProportionateScreenWidth(22)),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                            // Navigator.pushNamed(context, 'forumAllPage', arguments: _futureForum).then(refreshPage);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventAllPage(value: '',),
                                settings: RouteSettings(
                                  arguments: newestEvent,
                                ),
                              )
                            ).then(refreshPage);
                          }, 
                          child: const Text("See all")),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: getProportionateScreenHeight(300),
                      child: FutureBuilder<List<Event>>(
                        future: newestEvent,
                        builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot){
                          if (snapshot.hasData) {
                            snapshot.data!.sort((b, a) => (a.createDate).compareTo((b.createDate)));
                            return ListView.separated(
                              itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (BuildContext context, int index) { 
                                return SizedBox(width: getProportionateScreenWidth(15)); 
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
                                        width: getProportionateScreenWidth(280),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Ink.image(
                                              image: NetworkImage(snapshot.data![index].thumbnail),
                                              height: getProportionateScreenHeight(170),
                                              fit: BoxFit.cover,
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Text(snapshot.data![index].name,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: getProportionateScreenWidth(23),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Text(dateEvent,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: getProportionateScreenWidth(13),
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),

                                            //const SizedBox(height: 10),
                                            
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Text(snapshot.data![index].location,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: getProportionateScreenWidth(13),
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
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
                    ),
                    SizedBox(height: getProportionateScreenHeight(20)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ), 
    );
  }
}

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

  // Function Search Event
  bool searchEvent(Event data, String search) {
    var isContain = false;

    if (data.name.toLowerCase().contains(search.toLowerCase())) {
      isContain = true;
    }

    return isContain;

  }