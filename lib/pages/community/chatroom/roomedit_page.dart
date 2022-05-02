import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/data.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:http/http.dart' as http;
import '../../../arguments.dart';

class EditRoomPage extends StatefulWidget {
  const EditRoomPage({ Key? key }) : super(key: key);

  @override
  State<EditRoomPage> createState() => _EditRoomPageState();
}

class _EditRoomPageState extends State<EditRoomPage> {
  TextEditingController _name = TextEditingController();
  Room? roomDetail;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ChatRoomArguments;

    if(roomDetail == null) {
      roomDetail = args.room;
      _name.text = roomDetail!.name;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, args);
          return false;
        },
        child: SingleChildScrollView(
          child: Stack(
            children: [
      
              //Edit Room text
              Container(
                margin: const EdgeInsets.only(right: 0, left: 0),
                height: 180,
                color: Color.fromRGBO(220, 71, 47, 1),
                child: Center(
                  child: Text("Edit Room", 
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
                      Navigator.pop(context, args);
                    },
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
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        
                          TextFormField(
                            controller: _name,
                            decoration: const InputDecoration(
                              labelText: "Room name",
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter room's name";
                              }
                              else {
                                return null;
                              }
                            },
                          ),
      
                          const SizedBox(height: 30),
      
                          ElevatedButton(
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Edit room"),
                                  content: Text("Do you want to edit this room?"),
                                  actions: [
                                    FlatButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      }, 
                                      child: Text("No")
                                    ),
                                    FlatButton(
                                      onPressed: () async {
                                        if(_formKey.currentState!.validate()) {
                                            var success = await updateRoomDetail(args.commu.id, roomDetail!.id, _name.text);
                                            if (success) {
                                              Fluttertoast.showToast(msg: "The room has been edited.");
                                              Navigator.pop(context);
                                              Navigator.pop(context, args);
                                              Navigator.pop(context, args.commu.id);
                                            }
                                          }
                                      }, 
                                      child: Text("Yes", style: TextStyle(color: Colors.red)),
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
                                child: Text("Edit Room")
                              ),
                            ),
                          ),
      
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> updateRoomDetail(commuId, roomId, name) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.put(
      Uri.parse("http://10.0.2.2:3000/communities/$commuId/rooms/$roomId"),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $userToken'
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
      }),
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