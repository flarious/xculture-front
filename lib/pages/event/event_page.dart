import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:xculturetestapi/pages/event/event_all.dart';

import '../../data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:xculturetestapi/navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/pages/event/eventpost_page.dart';
import 'package:xculturetestapi/pages/event/eventdetail_page.dart';

import '../../helper/auth.dart';

class EventPage extends StatefulWidget {
  const EventPage({ Key? key }) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {

  Future<List<Event>>? _futureEvent;

  @override
  void initState() {
    super.initState();

    _futureEvent = getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Event",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            //Trending Event
            Container(
              margin: const EdgeInsets.all(10),
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
                        builder: (context) => EventAllPage(value: '',),
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

            //Event Box
            Container(
              height: 150,
              width: double.maxFinite,
              child: FutureBuilder<List<Event>>(
                future: _futureEvent,
                builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) { 
                  if(snapshot.hasData) {
                    return ListView.builder(
                      itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5, // number of item to display
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        var dt = DateTime.parse(snapshot.data![index].date).toLocal();
                        String dateEvent = DateFormat('MMMM dd, yyyy').format(dt);

                        return InkWell(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                width: 350,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(colors: [
                                    Colors.lightBlue.withOpacity(0.2),
                                    Colors.lightBlue.withOpacity(0.05),
                                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                  border: Border.all(
                                    color: Colors.lightBlue.withOpacity(0.08),
                                  ),
                                ),
                                child: Stack(
                                  children: [

                                    //Cover Photo
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                        height: 130,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                          image: DecorationImage(
                                            fit: BoxFit.fitHeight,
                                            image: NetworkImage(snapshot.data![index].thumbnail) // Event Image
                                          ),
                                        ),
                                      )
                                    ),

                                    //Text
                                    Container(
                                      margin: const EdgeInsets.only(top: 0, left: 120, right: 0, bottom: 0),
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data![index].name,
                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

            const SizedBox(height: 20),

            //Newest Event
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Text("Newest Event",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 22),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => EventAllPage(value: '',),
                    //     settings: RouteSettings(
                    //       arguments: _futureEvent,
                    //     ),
                    //   )
                    // ).then(refreshPage);
                  }, 
                  child: const Text("See all")),
                ],
              ),
            ),
          ],
        ),
      ),
      
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
      bottomNavigationBar: Navbar.navbar(context, 0),
    );
  }

  FutureOr refreshPage(dynamic value) {
    setState(() {
      _futureEvent = getEvents();
    });
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


}