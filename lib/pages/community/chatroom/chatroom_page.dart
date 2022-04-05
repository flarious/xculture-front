import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:xculturetestapi/arguments.dart';
import 'package:xculturetestapi/data.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/helper/auth.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({ Key? key }) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  Future<List<Message>>? _messages;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ChatRoomArguments;
    _messages = getRoomMessages(args.commuID, args.room.id);

    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        backgroundColor: const Color.fromRGBO(220, 71, 47, 1),
        title: Text("# ${args.room.name}"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context, args.commuID);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text("Edit"),
                  onTap: (){
                    //
                  },
                ),
                PopupMenuItem(
                  child: const Text("Delete"),
                  onTap: (){
                    //delete
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
                    groupBy: (message) => DateTime.parse(message.sentDate).toLocal(),
                    groupHeaderBuilder: (Message message) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(DateFormat.yMMMd().format(DateTime.parse(message.sentDate).toLocal())),
                      ),
                    ),
                    itemBuilder: (context, Message message) {
                      return message.sender.id == AuthHelper.auth.currentUser!.uid ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Card(
                              elevation: 8,
                              color: const Color.fromRGBO(220, 71, 47, 1),
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
                                  backgroundImage: AssetImage("assets/images/tomoe.jpg"),
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
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              hintText: "Type your message here....",
                              border: InputBorder.none,
                              suffixIcon: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color.fromRGBO(220, 71, 47, 1),
                                ),
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onSubmitted: (text) async {
                              var success = await sendMessage(args.commuID, args.room.id, text, 0);
                              if (success) {
                                setState(() {
                                  
                                });
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
}