import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:xculturetestapi/data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/pages/event/event_edit.dart';
import 'package:xculturetestapi/pages/report/report_page.dart';

import '../../navbar.dart';
import '../../widgets/hamburger_widget.dart';


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
                  toggle = (AuthHelper.checkAuth() && snapshot.data!.members.map((member) => member.member.id).contains(AuthHelper.auth.currentUser!.uid));
                  var dt = DateTime.parse(snapshot.data!.eventDate).toLocal();
                  String dateEvent = DateFormat('MMMM dd, yyyy – HH:mm a').format(dt);
                  
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

                      // Iconbutton menu
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(top: 20, right: 20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: const Text("Edit"),
                                onTap: () async {
                                  if (AuthHelper.checkAuth() && snapshot.data!.host.id == AuthHelper.auth.currentUser!.uid) {
                                    await Future.delayed(const Duration(milliseconds: 1));
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const EditEventPage(),
                                        settings: RouteSettings(
                                          arguments: snapshot.data!,
                                        ),
                                      )
                                    ).then(refreshPage);
                                  }
                                  else {
                                    Fluttertoast.showToast(msg: "You are not the owner");
                                  }
                                },
                              ),
                              PopupMenuItem(
                                child: const Text("Delete"),
                                onTap: () async {
                                  //delete
                                  if (AuthHelper.checkAuth() && snapshot.data!.host.id == AuthHelper.auth.currentUser!.uid) {
                                    await Future.delayed(const Duration(milliseconds: 1));
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Delete"),
                                        content: const Text("Do you really want to delete this event?"),
                                        actions: [
                                          TextButton(
                                            onPressed: (){
                                              //No
                                              Navigator.pop(context);
                                            }, 
                                            child: const Text("No", style: TextStyle(color: Colors.grey)),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              if(snapshot.data!.host.id == AuthHelper.auth.currentUser!.uid) {
                                                var success = await deleteEvent(snapshot.data!.id);
                                                if (success) {
                                                  Fluttertoast.showToast(msg: "Deleted");
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                }
                                              } 
                                              else {
                                                Fluttertoast.showToast(msg: "You are not the owner");
                                              }
                                            }, 
                                            child: const Text("Yes", style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                        elevation: 24.0,
                                      ),
                                    ); 
                                  }
                                  else {
                                    Fluttertoast.showToast(msg: "You are not the owner");
                                  }
                                },
                              ),
                              PopupMenuItem(
                                child: const Text("Report"),
                                onTap: () async {
                                  await Future.delayed(const Duration(milliseconds: 1));
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(
                                      builder: (context) => const ReportPage(),
                                      settings: RouteSettings(
                                        arguments: snapshot.data!.id,
                                      ),
                                    )
                                  ).then(refreshPage);
                                },
                              ),
                            ],
                            child: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 30,
                            ), 
                          ),
                        ),
                      ),
  
                      //Content
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

                              //Header
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(snapshot.data!.name,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.red)
                                ),
                              ),

                              //Date Event
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(dateEvent,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),

                              //Location
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(snapshot.data!.location,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),

                              //Host Name
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(snapshot.data!.host.name,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),

                              //Interested Count
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text("Interested : ${snapshot.data!.interestedAmount.toString()}",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),

                              //Division line
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Container(
                                    height: 1.0,
                                    width: 400,
                                    color: Colors.grey,
                                ),
                              ),

                              //Description
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text("Description",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),

                              // Desc Content
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(snapshot.data!.body),
                              ),

                              const SizedBox(height: 20),
                              /*(AuthHelper.checkAuth()  && snapshot.data!.members.contains(AuthHelper.auth.currentUser!.uid) )*/ 
                              
                              toggle ?
                              ElevatedButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Uninterest"),
                                      content: const Text("Do you uninterested in this event?"),
                                      actions: [
                                        TextButton(
                                          onPressed: (){
                                            //No
                                            Navigator.pop(context);
                                          }, 
                                          child: const Text("No", style: TextStyle(color: Colors.grey)),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if(snapshot.data!.host.id != AuthHelper.auth.currentUser!.uid) {
                                              var success = await unjoinEvent(snapshot.data!.id);
                                              if (success) {
                                                Fluttertoast.showToast(msg: "Uninterested");
                                                Navigator.pop(context);
                                              }
                                              setState(() {
                                                toggle = !toggle;
                                              });
                                            } 
                                            else {
                                              Fluttertoast.showToast(msg: "Action not allowed");
                                            }
                                          }, 
                                          child: const Text("Yes", style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                      elevation: 24.0,
                                    ),
                                  ); 
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: Row(
                                    children: const [
                                      Icon(Icons.star),
                                      SizedBox(width: 5),
                                      Text("Interested"),
                                    ],
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
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: Row(
                                    children: const [
                                      Icon(Icons.star_border),
                                      SizedBox(width: 5),
                                      Text("Interest"),
                                    ],
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
      endDrawer: const NavigationDrawerWidget(),
      bottomNavigationBar: const Navbar(currentIndex: 0),
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
      return Event(id: "", name: "", body: "", interestedAmount: 0, thumbnail: "", location: "", createDate: DateTime.now().toString(), updateDate: DateTime.now().toString(), eventDate: DateTime.now().toString(), host: User(id: "", name: "", profilePic: "", bio: "", email: "", tags: []), members: []);
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

  Future<bool> deleteEvent(eventID) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.delete(
      Uri.parse("http://10.0.2.2:3000/events/$eventID"),
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




