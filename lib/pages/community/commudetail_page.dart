import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:xculturetestapi/data.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/pages/community/commuedit_page.dart';

import '../../navbar.dart';
import '../../widgets/hamburger_widget.dart';

class CommuDetailPage extends StatefulWidget {
  const CommuDetailPage({ Key? key }) : super(key: key);

  @override
  _CommuDetailPageState createState() => _CommuDetailPageState();
}

class _CommuDetailPageState extends State<CommuDetailPage> {
  Future<Community>? commuDetail;

  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    final commuID = ModalRoute.of(context)!.settings.arguments as Community;
    commuDetail = getCommu(commuID.id);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<Community>(
            future: commuDetail,
            builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
              if(snapshot.hasData) {
                toggle = (AuthHelper.checkAuth() && snapshot.data!.members.map((member) => member.id).contains(AuthHelper.auth.currentUser!.uid));
                var dt = DateTime.parse(snapshot.data!.date).toLocal();
                String dateCommu = DateFormat('MMMM dd, yyyy – HH:mm a').format(dt);
                
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
                            if (AuthHelper.checkAuth() && snapshot.data!.owner.id == AuthHelper.auth.currentUser!.uid) {
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
                              child: Text(snapshot.data!.shortdesc,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Text("Created by: ${snapshot.data!.owner.name}",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(dateCommu,
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
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(snapshot.data!.desc),
                            ),
                            const SizedBox(height: 20),
                            /*(AuthHelper.checkAuth() && snapshot.data!.members.contains(AuthHelper.auth.currentUser!.uid) )*/ 
                            toggle ?
                            ElevatedButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Leave"),
                                    content: const Text("Do you want to leave this community?"),
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
                                          if(snapshot.data!.owner.id != AuthHelper.auth.currentUser!.uid) {
                                            var success = await unjoinCommu(snapshot.data!.id);
                                            if (success) {
                                              Fluttertoast.showToast(msg: "Leaved");
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
                              child: const SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: Center(
                                  child: Text("Leave community")
                                ),
                              ),
                            ) : 
                            ElevatedButton(
                              onPressed: () async {
                                var success = await joinCommu(snapshot.data!.id);
                                if (success) {
                                  Fluttertoast.showToast(msg: "Joined");
                                }
                                setState(() {
                                  toggle = !toggle;
                                });
                              }, 
                              child: const SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: Center(
                                  child: Text("Join community")
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
        endDrawer: const NavigationDrawerWidget(),
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
    print(commuID);
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/communities/$commuID'));

    if (response.statusCode == 200) {
      return Community.fromJson(jsonDecode(response.body));
    } else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      Navigator.pop(context);
      return Community(id: "", name: "", shortdesc: "", desc: "", thumbnail: "", memberAmount: 0, date: DateTime.now().toString(), owner: User(id: "", name: "", profilePic: "", bio: "", email: ""), members: []);
    }
  }

  Future<bool> joinCommu(commuID) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/communities/$commuID/join'),
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

  Future<bool> unjoinCommu(commuID) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/communities/$commuID/unjoin'),
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