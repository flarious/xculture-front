import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:xculturetestapi/arguments.dart';
import 'package:xculturetestapi/data.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/pages/community/chatroom/roomedit_page.dart';

import '../../../size_config.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({ Key? key }) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  Future<List<Message>>? _messages;
  TextEditingController _text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ChatRoomArguments;
    _messages = getRoomMessages(args.commu.id, args.room.id);
    

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // elevation: 5.0,
          // backgroundColor: Colors.red,
          // title: Text("# ${args.room.name}"),
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back),
          //   onPressed: (){
          //     Navigator.pop(context, args.commu.id);
          //   },
          // ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          toolbarHeight: getProportionateScreenHeight(80),
          title: Text("# ${args.room.name}"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
              color: Colors.red,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: PopupMenuButton(
                itemBuilder: (context) => [

                  PopupMenuItem(
                    child: const Text("Edit"),
                    onTap: () async {
                      // 
                      await Future.delayed(const Duration(milliseconds: 1));
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditRoomPage(),
                          settings: RouteSettings(
                            arguments: ChatRoomArguments(commu: args.commu, room: args.room)),
                        )
                      );
                    },
                  ),
                  
                  PopupMenuItem(
                    child: const Text("Delete"),
                    onTap: () async {
                      //delete
                      await Future.delayed(const Duration(milliseconds: 1));
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete"),
                          content: const Text("Do you really want to delete this room?"),
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
                                var success = await deleteRoom(args.commu.id, args.room.id);
                                if (success) {
                                  Fluttertoast.showToast(msg: "Deleted");
                                  Navigator.pop(context);
                                  Navigator.pop(context, args.commu.id);
                                }
                              }, 
                              child: const Text("Yes", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                          elevation: 24.0,
                        ),
                      ); 
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
          ],
        ),
        body: FutureBuilder<List<Message>>(
          future: _messages,
          builder: (context, AsyncSnapshot<List<Message>> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Expanded(
                    child: GroupedListView<Message, DateTime>(
                      padding: const EdgeInsets.all(10),
                      reverse: true,
                      order: GroupedListOrder.DESC,
                      //useStickyGroupSeparators: true,
                      //floatingHeader: true,
                      elements: snapshot.data!,
                      groupBy: (message) { 
                        var dt = DateTime.parse(message.sentDate).toLocal();
                        return DateTime(dt.year, dt.month, dt.day);
                      },
                      groupHeaderBuilder: (Message message) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(DateFormat.yMMMd().format(DateTime.parse(message.sentDate).toLocal())),
                        ),
                      ),
                      itemBuilder: (context, Message message) {
                        return (AuthHelper.checkAuth() && message.sender.id == AuthHelper.auth.currentUser!.uid) ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Card(
                                elevation: 8,
                                color: Colors.red,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(message.message,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  text: TextSpan(
                                    text: DateFormat.Hm().format(DateTime.parse(message.sentDate).toLocal()),
                                    style: DefaultTextStyle.of(context).style
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundImage: NetworkImage(message.sender.profilePic),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(message.sender.name),
                                ),
                              ],
                            ),
                            Card(
                              elevation: 8,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(message.message),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RichText(
                                text: TextSpan(
                                  text: DateFormat.Hm().format(DateTime.parse(message.sentDate).toLocal()),
                                  style: DefaultTextStyle.of(context).style
                                ),
                              ),
                            ),
                          ],
                        );
                      } 
                    )
                  ),
            
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: TextField(
                              controller: _text,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(15),
                                hintText: "Type your message here....",
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                     Icons.send,
                                     color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    if (_text.text != "") {
                                      if (AuthHelper.checkAuth() && args.commu.members.any((member) => member.member.id == AuthHelper.auth.currentUser!.uid)) {
                                        var success = await sendMessage(args.commu.id, args.room.id, _text.text, 0);
                                        if (success) {
                                          setState(() {
                                            _text.text = "";
                                          });
                                        }
                                      }
                                      else {
                                        Fluttertoast.showToast(msg: "Only members can send a message");
                                      }
                                      
                                    }
                                    else {
                                      Fluttertoast.showToast(msg: "You can't send an empty message");
                                    }
                                  },
                                ),
                                // suffixIcon: Container(
                                //   padding: const EdgeInsets.all(15),
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(50),
                                //     color: Color.fromRGBO(220, 71, 47, 1),
                                //   ),
                                //   child: const Icon(
                                //     Icons.send,
                                //     color: Colors.white,
                                //   ),
                                // ),
                              ),
                              onSubmitted: (text) async {
                                if (text != "") {
                                  if (AuthHelper.checkAuth() && args.commu.members.any((member) => member.member.id == AuthHelper.auth.currentUser!.uid)) {
                                    var success = await sendMessage(args.commu.id, args.room.id, text, 0);
                                    if (success) {
                                      setState(() {
                                        _text.text = "";
                                      });
                                    }
                                  }
                                  else {
                                    Fluttertoast.showToast(msg: "Only members can send a message");
                                  }
                                  
                                }
                                else {
                                  Fluttertoast.showToast(msg: "You can't send an empty message");
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              );
            }
            else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Future<List<Message>> getRoomMessages(commuId, roomId) async {
    final response = await http.get(Uri.parse("http://10.0.2.2:3000/communities/$commuId/rooms/$roomId/messages"));
    List<Message> messageList = [];

    if(response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      decoded.forEach((obj) => messageList.add(Message.fromJson(obj)));
      return messageList;
    } 
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return messageList;
    }
  }

  Future<bool> sendMessage(commuId, roomId, message, repliedTo) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.post(
      Uri.parse("http://10.0.2.2:3000/communities/$commuId/rooms/$roomId/messages"),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $userToken',
      },
      body: jsonEncode(<String, dynamic> {
        'message': message,
        'repliedTo': repliedTo,
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

  Future<bool> deleteRoom(commuId, roomId) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.delete(
      Uri.parse("http://10.0.2.2:3000/communities/$commuId/rooms/$roomId"),
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