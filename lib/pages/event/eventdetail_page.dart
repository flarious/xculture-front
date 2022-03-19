import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:xculturetestapi/data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/pages/event/event_edit.dart';


class EventDetailPage extends StatefulWidget {
  const EventDetailPage({ Key? key }) : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {

  Future<Event>? eventDetail;
  bool toggle = false;

  @override
  Widget build(BuildContext context) {

    final eventID = ModalRoute.of(context)!.settings.arguments as Event;
    eventDetail = getEvent(eventID.id);
    
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<Event>(
            future: eventDetail,
            builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.hasData) {
                  var dt = DateTime.parse(snapshot.data!.date).toLocal();
                  String dateEvent = DateFormat('MMMM dd, yyyy').format(dt);

                  return Stack(
                    children: [
                      // Thumbnail Image
                      Container(
                        margin: const EdgeInsets.only(right: 0, left: 0),
                        child: Container(
                          height: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(snapshot.data!.thumbnail),
                              fit: BoxFit.cover, 
                            ),
                          ),
                        ),
                      ),
                      // Iconbutton back
                      Container(
                        margin: const EdgeInsets.only(top: 40, left: 20),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.arrow_back),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),   
                      ),
                      // Iconbutton menu
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(top: 40, right: 20),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                            
                          ),
                          child: IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.edit),
                            // icon: const Icon(Icons.more_vert),
                            color: Colors.white,
                            onPressed: () {
                              if (AuthHelper.checkAuth() && snapshot.data!.host.id == AuthHelper.auth.currentUser!.uid) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const EditEventPage(),
                                    settings: RouteSettings(
                                      arguments: snapshot.data,),
                                  )
                                ).then(refreshPage);
                              }
                              else {
                                Fluttertoast.showToast(msg: "You are not the owner");
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 280, left: 0, right: 0, bottom: 0),
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
                              // Desc Header
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(snapshot.data!.name,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23, color: Colors.red)
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(dateEvent,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              // Desc Header
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(snapshot.data!.location,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(snapshot.data!.host.name,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text("Interested : ${snapshot.data!.interestedAmount.toString()}",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              // Division line
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Container(
                                    height: 1.0,
                                    width: 400,
                                    color: Colors.grey,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text("Description",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              // Desc Content
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(snapshot.data!.body),
                              ),
                              const SizedBox(height: 20),
                              /*(AuthHelper.checkAuth()  && snapshot.data!.members.contains(AuthHelper.auth.currentUser!.uid) )*/ 
                              toggle ?
                              ElevatedButton(
                                onPressed: () async {
                                  if(snapshot.data!.host.id != AuthHelper.auth.currentUser!.uid) {
                                    var success = await unjoinEvent(snapshot.data!.id);
                                    if (success) {
                                      Fluttertoast.showToast(msg: "Uninterested");
                                    }
                                    setState(() {
                                      toggle = !toggle;
                                    });
                                  } 
                                  else {
                                    Fluttertoast.showToast(msg: "Action not allowed");
                                  }
                                }, 
                                child: const SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: Center(
                                    child: Text("Uninterest")
                                  ),
                                ),
                              ) : 
                              ElevatedButton(
                                onPressed: () async {
                                  var success = await joinEvent(snapshot.data!.id);
                                  if (success) {
                                    Fluttertoast.showToast(msg: "Interested");
                                  }
                                  setState(() {
                                    toggle = !toggle;
                                  });
                                }, 
                                child: const SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: Center(
                                    child: Text("Interest")
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
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
      ),
    );
  }


  FutureOr refreshPage(eventID) {
    setState(() {
      eventDetail = getEvent(eventID);
    });
  }

  Future<Event> getEvent(eventID) async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/events/$eventID'));

    if (response.statusCode == 200) {
      return Event.fromJson(jsonDecode(response.body));
    } else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      Navigator.pop(context);
      return Event(id: 0, name: "", body: "", interestedAmount: 0, thumbnail: "", location: "", date: DateTime.now().toString(), host: User(id: "", name: "", profilePic: ""), members: []);
    }
  }

  Future<bool> joinEvent(eventID) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/events/$eventID/join'),
      headers: <String, String> {
        'Authorization' : 'bearer $userToken'
      }
    );

    if (response.statusCode == 200) {
      return true;
    }
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return false;
    }
  }



  Future<bool> unjoinEvent(eventID) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/events/$eventID/unjoin'),
      headers: <String, String> {
        'Authorization' : 'bearer $userToken'
      }
    );

    if (response.statusCode == 200) {
      return true;
    }
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return false;
    }
  }
}




