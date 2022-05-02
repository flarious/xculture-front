import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/arguments.dart';
import 'package:xculturetestapi/data.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/pages/community/chatroom/chatroom_page.dart';
import 'package:xculturetestapi/pages/community/member_page.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({ Key? key }) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {

  bool isPost = false;

  Future<List<Room>>? rooms;

  @override
  Widget build(BuildContext context) {
    final commu = ModalRoute.of(context)!.settings.arguments as Community;
    rooms = getRooms(commu.id);

    final TextEditingController _roomName = TextEditingController();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: FutureBuilder<List<Room>>(
            future: rooms,
            builder: (context, AsyncSnapshot<List<Room>> snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: [
                    //Post Forum text
                    Container(
                      margin: const EdgeInsets.only(right: 0, left: 0),
                      height: 180,
                      color: Color.fromRGBO(220, 71, 47, 1),
                      child: Center(
                        child: Text("Rooms", 
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
              
                    //Back Icon
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
                            //Back
                            Navigator.pop(context, commu.id);
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
                              child: const Text("Member"),
                              onTap: () async {
                                await Future.delayed(const Duration(milliseconds: 1));
                                await Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) => const MemberPage(),
                                    settings: RouteSettings(
                                      arguments: commu
                                    )
                                  )
                                );
                                setState(() {
                                  
                                });
                              },
                            ),
                            PopupMenuItem(
                              child: const Text("Leave"),
                              onTap: () async {
                                await Future.delayed(const Duration(milliseconds: 1));
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Leave"),
                                    content: Text("Do you want to leave?"),
                                    actions: [
                                      FlatButton(
                                        onPressed: (){
                                          Navigator.pop(context, commu.id);
                                        }, 
                                        child: Text("No")
                                      ),
                                      FlatButton(
                                        onPressed: () async {
                                          if(commu.owner.id != AuthHelper.auth.currentUser!.uid) {
                                            var success = await unjoinCommu(commu.id);
                                            if (success) {
                                              Fluttertoast.showToast(msg: "Leaved");
                                              Navigator.pop(context);
                                              Navigator.pop(context, commu.id);
                                            }
                                          }
                                          else {
                                            Fluttertoast.showToast(msg: "Action not allowed");
                                          }
                                        }, 
                                        child: Text("Yes", style: TextStyle(color: Colors.deepOrange)),
                                      ),
                                    ],
                                    elevation: 24.0,
                                  ),
                                );
                              },
                            )
                          ],
                          child: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 30,
                          ), 
                        ),
                      ),
                    ),
              
                    Container(
                      margin: const EdgeInsets.only(top: 150, left: 0, right: 0, bottom: 0),
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
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      InkWell(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                            child: Container(
                                              height: 70,
                                              width: double.maxFinite,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(colors: [
                                                  Colors.lightBlue.withOpacity(0.2),
                                                  Colors.lightBlue.withOpacity(0.05),
                                                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                                borderRadius: BorderRadius.circular(20)
                                              ),
                                              child: Row(
                                                children: [
                                                  const SizedBox(width: 30),
                                                  Text("# ${snapshot.data![index].name}",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(fontSize: 20.0),
                                                  ),
                                                  Spacer(),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                    ),
                                                  ),
                                                ]
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () async {
                                          await Navigator.push(
                                            context, 
                                            MaterialPageRoute(
                                              builder: (context) => const ChatRoomPage(),
                                              settings: RouteSettings(
                                                arguments: ChatRoomArguments(commu: commu, room: snapshot.data![index])
                                              )
                                            )
                                          );
                                          setState(() {
                                            
                                          });
                                        },
                                      ),
                      
                                      const SizedBox(height: 20),
                                    ],
                                  );
                                }
                              ),
                            
                              Visibility(
                                visible: isPost,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(20)
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextFormField(
                                              controller: _roomName,
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.only(left: 30),
                                                hintText: "Enter room name",
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Material(
                                        color: Colors.white,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isPost = !isPost;
                                            });
                                          }, 
                                          icon: Icon(Icons.close),
                                          color: Colors.red,
                                          splashRadius: 20,
                                        ),
                                      ),
                                      Material(
                                        color: Colors.white,
                                        child: IconButton(
                                          onPressed: () async {
                                            if (_roomName.text != "") {
                                              if (AuthHelper.checkAuth() && commu.members.any((member) => member.member.id == AuthHelper.auth.currentUser!.uid)) {
                                                var success = await sendRoomDetail(commu.id, _roomName.text); 
                                                if (success) {
                                                  Fluttertoast.showToast(msg: "Your community have been created.");
                                                  setState(() {
                                                    
                                                  });
                                                }
                                              }
                                              else {
                                                Fluttertoast.showToast(msg: "Only members can create room");
                                              }
                                              
                                            } 
                                            else {
                                              Fluttertoast.showToast(msg: "You need a name to create a room");
                                            }
                                          }, 
                                          icon: Icon(Icons.done),
                                          color: Colors.green,
                                          splashRadius: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              InkWell(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      height: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(220, 71, 47, 1),
                                        borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Icon(
                                        Icons.add_circle,
                                        color: Colors.white,
                                        size: 37,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  setState(() {
                                    isPost = !isPost;
                                  });
                                },
                              ),
                            ],
                          ),
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
      ),
    );
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

  Future<List<Room>> getRooms(commuId) async {
    final response = await http.get(Uri.parse("http://10.0.2.2:3000/communities/$commuId/rooms"));
    final List<Room> roomList = [];

    if(response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      decoded.forEach((obj) => roomList.add(Room.fromJson(obj)));
      return roomList;
    } 
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return roomList;
    }
  }

  Future<bool> sendRoomDetail(commuId, name) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.post(
      Uri.parse("http://10.0.2.2:3000/communities/$commuId/rooms"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $userToken',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } 
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return false;
    }
  }
}