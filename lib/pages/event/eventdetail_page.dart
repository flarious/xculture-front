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
                        margin: const EdgeInsets.only(top: 40, right: 20),
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
                                onTap: (){
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
                              PopupMenuItem(
                                child: const Text("Delete"),
                                onTap: (){
                                  //delete
                                },
                              ),
                              PopupMenuItem(
                                child: const Text("Report"),
                                onTap: (){
                                  //report
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
                                      title: Text("Join"),
                                      content: Text("Do you want to join?"),
                                      actions: [
                                        FlatButton(
                                          onPressed: (){
                                            //No
                                          }, 
                                          child: Text("No")
                                        ),
                                        FlatButton(
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
                                          child: Text("Yes", style: TextStyle(color: Colors.red)),
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
                                      Text("Uninterest"),
                                    ],
                                  ),
                                ),
                              ) : 
                              ElevatedButton(
                                onPressed: (){
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Interest"),
                                      content: Text("Do you interesting?"),
                                      actions: [
                                        FlatButton(
                                          onPressed: (){
                                            //No
                                          }, 
                                          child: Text("No")
                                        ),
                                        FlatButton(
                                          onPressed: () async {
                                            var success = await joinEvent(snapshot.data!.id);
                                            if (success) {
                                              Fluttertoast.showToast(msg: "Interested");
                                            }
                                            setState(() {
                                              toggle = !toggle;
                                            });
                                          }, 
                                          child: Text("Yes", style: TextStyle(color: Colors.red)),
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




