import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:xculturetestapi/data.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/pages/community/chatroom/room_page.dart';
import 'package:xculturetestapi/pages/community/commuedit_page.dart';
import 'package:xculturetestapi/pages/community/private/question_page.dart';
import 'package:xculturetestapi/widgets/guesthamburger_widget.dart';

import '../../navbar.dart';
import '../../widgets/hamburger_widget.dart';
import '../report/report_page.dart';

class CommuDetailPage extends StatefulWidget {
  const CommuDetailPage({ Key? key }) : super(key: key);

  @override
  _CommuDetailPageState createState() => _CommuDetailPageState();
}

class _CommuDetailPageState extends State<CommuDetailPage> {
  Future<Community>? commuDetail;

  bool isJoin = false;
  bool isPrivate = false;
  String userType = "";

  @override
  Widget build(BuildContext context) {
    final commuID = ModalRoute.of(context)!.settings.arguments as Community;
    commuDetail = getCommu(commuID.id);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: FutureBuilder<Community>(
            future: commuDetail,
            builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
              if(snapshot.hasData) {
                isJoin = (AuthHelper.checkAuth() && snapshot.data!.members.any((member) => member.member.id == AuthHelper.auth.currentUser!.uid));
                userType = isJoin ? snapshot.data!.members.firstWhere((member) => member.member.id == AuthHelper.auth.currentUser!.uid).type! : ""; 
                isPrivate = snapshot.data!.type == "private" ? true : false;
                var dt = DateTime.parse(snapshot.data!.updateDate).toLocal();
                String dateCommu = DateFormat('MMMM dd, yyyy ??? HH:mm a').format(dt);
                
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
                              onTap: () async {
                                if (AuthHelper.checkAuth() && snapshot.data!.owner.id == AuthHelper.auth.currentUser!.uid) {
                                  await Future.delayed(const Duration(milliseconds: 1));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const EditCommuPage(),
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
                              onTap: () async {
                                  //delete
                                  if (AuthHelper.checkAuth() && snapshot.data!.owner.id == AuthHelper.auth.currentUser!.uid) {
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
                                              var success = await deleteCommu(snapshot.data!.id);
                                              if (success) {
                                                Fluttertoast.showToast(msg: "Deleted");
                                                Navigator.pop(context);
                                                Navigator.pop(context);
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
                                if (AuthHelper.checkAuth() && snapshot.data!.owner.id != AuthHelper.auth.currentUser!.uid) {
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
                                }
                                else {
                                  Fluttertoast.showToast(msg: "The owner can't report their community");
                                }
                              }
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

                            // //Header
                            // Padding(
                            //   padding: EdgeInsets.symmetric(vertical: 5.0),
                            //   child: Text(snapshot.data!.name,
                            //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.red)
                            //   ),
                            // ),

                            //Header
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5.0),
                                    child: Text(snapshot.data!.name,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)
                                    ),
                                  ),
                                ),
                                Chip(
                                  label: Text(snapshot.data!.type,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              ],
                            ),

                            //Catagory
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(snapshot.data!.shortdesc,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),

                            const SizedBox(height: 20),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                  ),
                                  children: <TextSpan>[
                                    const TextSpan(text: 'Created by  ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(text: '${snapshot.data!.owner.name}'),
                                  ],
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                  ),
                                  children: <TextSpan>[
                                    const TextSpan(text: 'Created at  ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(text: '$dateCommu'),
                                  ],
                                ),
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
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),

                            // Desc Content
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(snapshot.data!.desc),
                            ),

                            const SizedBox(height: 20),

                            Visibility(
                              visible: (isPrivate && userType == "member") || !isPrivate,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await Navigator.push(
                                    context, 
                                    MaterialPageRoute(
                                      builder: (context) => const RoomPage(),
                                      settings: RouteSettings(
                                        arguments: snapshot.data!
                                      )
                                    )
                                  );
                                  setState(() {
                                    
                                  });
                                }, 
                                child: const SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: Center(
                                    child: Text("Discuss Room")
                                  ),
                                ),
                              ),
                            ),

                            Visibility(
                              visible: (isPrivate && userType == "member") || !isPrivate,
                              child: const SizedBox(height: 20),
                            ),

                            Visibility(
                              visible: isPrivate && userType == "pending",
                              child: ElevatedButton(
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Cancel Join Request"),
                                        content: const Text("Do you really want to cancel your request? You will have to answer the question again before joining this community."),
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
                                              var success = await cancelJoinRequest(snapshot.data!.id);
                                              if (success) {
                                                Fluttertoast.showToast(msg: "Request Cancelled");
                                                Navigator.pop(context);
                                              }
                                              setState(() {

                                              });
                                            }, 
                                            child: const Text("Yes", style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                        elevation: 24.0,
                                      ),
                                    );
                                }, 
                                child: const SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: Center(
                                    child: Text("Pending")
                                  ),
                                ),
                              ),
                            ),

                            Visibility(
                              visible: !isJoin,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (isPrivate) {
                                    if (AuthHelper.checkAuth()) {
                                      await Navigator.push(
                                        context, 
                                        MaterialPageRoute(
                                          builder: (context) => const QuestionPage(),
                                          settings: RouteSettings(
                                            arguments: snapshot.data!
                                          )
                                        )
                                      );
                                      setState(() {
                                        
                                      });
                                    }
                                    else {
                                      Fluttertoast.showToast(msg: "You need to sign in to join this community");
                                    }
                                  }
                                  else {
                                    var success = await joinCommu(snapshot.data!.id);
                                    if (success) {
                                      Fluttertoast.showToast(msg: "Joined");
                                    }
                                    setState(() {
                                      isJoin = !isJoin;
                                    });
                                  }
                                  
                                }, 
                                child: const SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: Center(
                                    child: Text("Join Community")
                                  ),
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
              }
              else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
        endDrawer: AuthHelper.checkAuth() ? const NavigationDrawerWidget() : const GuestHamburger(),
        bottomNavigationBar: const Navbar(currentIndex: 3), 
      ),
    );
  }

  FutureOr refreshPage(commuID) {
    setState(() {
      commuDetail = getCommu(commuID);
    });
  }

  Future<Community> getCommu(commuID) async {
    final response =
        await http.get(Uri.parse('https://xculture-server.herokuapp.com/communities/$commuID'));

    if (response.statusCode == 200) {
      return Community.fromJson(jsonDecode(response.body));
    } else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      Navigator.pop(context);
      return Community(id: "", name: "", shortdesc: "", desc: "", thumbnail: "", memberAmount: 0, createDate: DateTime.now().toString(), updateDate: DateTime.now().toString(), 
      owner: User(id: "", name: "", profilePic: "", bio: "", email: "", lastBanned: "", userType: "", bannedAmount: 0, tags: []), members: [], type: "", questions: []);
    }
  }

  Future<bool> joinCommu(commuID) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.put(
      Uri.parse('https://xculture-server.herokuapp.com/communities/$commuID/join'),
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

  Future<bool> cancelJoinRequest(commuID) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.delete(
      Uri.parse('https://xculture-server.herokuapp.com/communities/$commuID/cancel'),
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

  Future<bool> deleteCommu(commuID) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.delete(
      Uri.parse("https://xculture-server.herokuapp.com/communities/$commuID"),
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