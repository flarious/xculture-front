import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/arguments.dart';
import 'package:xculturetestapi/constants.dart';
import 'package:xculturetestapi/data.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:http/http.dart' as http;

class FilterPage extends StatefulWidget {
  const FilterPage({ Key? key }) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  Future<List<Answer>>? answers;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as FilterArguments;
    answers = getAnswers(args.commu.id, args.commu.members[args.member].member.id);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [

              //Question text
              Container(
                margin: const EdgeInsets.only(right: 0, left: 0),
                height: 180,
                color: Colors.red,
                child: Center(
                  child: Text(args.commu.members[args.member].member.name, 
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
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
                      Navigator.pop(context, args.commu);
                    },
                  ),
                ),   
              ),

              //White box(content)
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
                  child: Column(
                    children: [
                      FutureBuilder<List<Answer>>(
                        future: answers,
                        builder: (BuildContext context, AsyncSnapshot<List<Answer>> snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: args.commu.questions.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Question
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Text(args.commu.questions[index].question,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Text(snapshot.data![index].answer,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                  ],
                                );
                              }
                            );
                          }
                          else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Accept member"),
                                      content: Text("Are you sure to accept this user's request to join this community?"),
                                      actions: [
                                        FlatButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          }, 
                                          child: Text("No")
                                        ),
                                        FlatButton(
                                          onPressed: () async {
                                            var success = await acceptMember(args.commu.id, args.commu.members[args.member].member.id);
                                            if (success) {
                                              Fluttertoast.showToast(msg: "You have accepted this user's request.");
                                              Navigator.pop(context);
                                              Navigator.pop(context, args.commu);
                                            }
                                            else {
                                              Navigator.pop(context);
                                            }
                                          }, 
                                          child: Text("Yes", style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                      elevation: 24.0,
                                    ),
                                  );
                                },
                                child: const Text("Approve"),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Decline member"),
                                      content: Text("Are you sure to decline this user's request to join this community?"),
                                      actions: [
                                        FlatButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          }, 
                                          child: Text("No")
                                        ),
                                        FlatButton(
                                          onPressed: () async {
                                            var success = await declineMember(args.commu.id, args.commu.members[args.member].member.id);
                                            if (success) {
                                              Fluttertoast.showToast(msg: "You have declined this user's request");
                                              Navigator.pop(context);
                                              Navigator.pop(context, args.commu);
                                            }
                                            else {
                                              Navigator.pop(context);
                                            }
                                          }, 
                                          child: Text("Yes", style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                      elevation: 24.0,
                                    ),
                                  );
                                },
                                child: const Text("Decline"),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Answer>> getAnswers(commuId, userId) async {
    final response = await http.get(Uri.parse("https://xculture-server.herokuapp.com/communities/$commuId/answers/$userId"));
    final List<Answer> answerList = [];

    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      decoded.forEach((obj) => answerList.add(Answer.fromJson(obj)));
      answerList.sort((a, b) => a.questionId.compareTo(b.questionId));
      return answerList;
    }
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return answerList;
    }
  }

  Future<bool> acceptMember(commuId, userId) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.put(
      Uri.parse("https://xculture-server.herokuapp.com/communities/$commuId/members/$userId/accept"),
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

  Future<bool> declineMember(commuId, userId) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.delete(
      Uri.parse("https://xculture-server.herokuapp.com/communities/$commuId/members/$userId/decline"),
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