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

import '../../../size_config.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({ Key? key }) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {

  bool isPost = false;

  Future<List<Room>>? rooms;

  // Change color (prefix icon)
  FocusNode fieldnode = FocusNode();

  // Search Function
  String searchString = "";
  TextEditingController searchController = TextEditingController();

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
                    
                    //Room text
                    Container(
                      //margin: const EdgeInsets.only(right: 0, left: 0),
                      height: getProportionateScreenHeight(180),
                      color: Colors.red,
                      child: Center(
                        child: Text("Rooms", 
                          style: TextStyle(fontSize: getProportionateScreenWidth(30), fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
              
                    //Back Icon
                    Container(
                      margin: EdgeInsets.only(top: getProportionateScreenHeight(40), left: getProportionateScreenWidth(20)),
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
                      margin: EdgeInsets.only(top: getProportionateScreenHeight(40), right: getProportionateScreenWidth(20)),
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
                                        child: Text("Yes", style: TextStyle(color: Colors.red)),
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
                      margin: EdgeInsets.only(top: getProportionateScreenHeight(150)),
                      child: Container(
                        padding: const EdgeInsets.all(20),
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

                            Container (                                  
                              height: getProportionateScreenHeight(50),
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
                                  hintText: "Search Room..",
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
                            
                            SizedBox(height: getProportionateScreenHeight(20)),

                            ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                var contained = searchRoom(snapshot.data![index], searchString);
                                return contained ? Column(
                                  children: [

                                    Card(
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: InkWell(
                                        child: SizedBox(
                                          height: getProportionateScreenHeight(80),
                                          child: Row(
                                            children: [
                                              
                                              Padding(
                                                padding: const EdgeInsets.all(20),
                                                child: Text("# ${snapshot.data![index].name}",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(fontSize: getProportionateScreenWidth(20)),
                                                ),
                                              ),

                                              const Spacer(),

                                              const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 20),
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                ),
                                              ),
                                            ]
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
                                    ),

                                    SizedBox(height: getProportionateScreenHeight(20)),
                                  ],
                                ): Container(); 
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
                                        height: getProportionateScreenHeight(70),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: TextFormField(
                                            controller: _roomName,
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.only(left: 20),
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
                                        icon: const Icon(Icons.close),
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
                                                Fluttertoast.showToast(msg: "Your room has been created.");
                                                setState(() {
                                                  isPost = !isPost;
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
                                        icon: const Icon(Icons.done),
                                        color: Colors.green,
                                        splashRadius: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            InkWell(
                              child: Container(
                                height: getProportionateScreenHeight(60),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: const Icon(
                                  Icons.add_circle,
                                  color: Colors.white,
                                  size: 37,
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
      Uri.parse('https://xculture-server.herokuapp.com/communities/$commuID/unjoin'),
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
    final response = await http.get(Uri.parse("https://xculture-server.herokuapp.com/communities/$commuId/rooms"));
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
      Uri.parse("https://xculture-server.herokuapp.com/communities/$commuId/rooms"),
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

    // Function Search Forum
  bool searchRoom(Room data, String search) {
    var isContain = false;

    if (data.name.toLowerCase().contains(search.toLowerCase())) {
      isContain = true;
    }

    return isContain;

  }
}