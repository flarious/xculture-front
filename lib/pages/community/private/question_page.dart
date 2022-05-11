import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/constants.dart';
import 'package:xculturetestapi/data.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:http/http.dart' as http;

class QuestionPage extends StatefulWidget {
  const QuestionPage({ Key? key }) : super(key: key);

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<TextEditingController> _answers = [];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final commuDetail = ModalRoute.of(context)!.settings.arguments as Community;
    if (_answers.length != commuDetail.questions.length) {
      if (_answers.length < commuDetail.questions.length) {
        for (int i = _answers.length; i < commuDetail.questions.length; i++) {
          _answers.add(TextEditingController());
        }
      }
      else if (_answers.length > commuDetail.questions.length) {
        for (int i = _answers.length; i > commuDetail.questions.length; i--) {
          _answers.removeLast();
        }
      }
    }

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
                child: const Center(
                  child: Text("Question", 
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
                      Navigator.pop(context, commuDetail);
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
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [

                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: commuDetail.questions.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Question
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    child: Text(commuDetail.questions[index].question,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                  ),

                                  //Answer
                                  TextFormField(
                                    maxLines: 3,
                                    keyboardType: TextInputType.multiline,
                                    controller: _answers[index],
                                    decoration: InputDecoration(
                                      hintText: "Answer here",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please answer community's question";
                                      }
                                      else {
                                        return null;
                                      }
                                    },
                                  ),

                                  const SizedBox(height: 40),
                                ],
                              );
                            }
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(350, 50),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Answer Question"),
                                  content: Text("Do you want to send these answer to ask for permission to join the community?"),
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
                                          var success = await sendAnswers(commuDetail.id, commuDetail.questions, _answers);
                                          var success2 = await joinCommu(commuDetail.id);
                                          if (success && success2) {
                                            Fluttertoast.showToast(msg: "Your answers have been sent.");
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }
                                          else {
                                            Navigator.pop(context);
                                          }
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
                            child: const Text("Send Answer")
                          )
                        ]
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

  Future<bool> sendAnswers(String commuId, List<Question> _questions, List<TextEditingController> _answers) async {
    List<int> questions = [for (int i = 0; i < _questions.length; i++) _questions[i].id];
    List<String> answers = [for (int i = 0; i < _answers.length; i++) _answers[i].text];

    final userToken = await AuthHelper.getToken();

    final response = await http.post(
      Uri.parse('https://xculture-server.herokuapp.com/communities/$commuId/answers'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $userToken',
      },
      body: jsonEncode(<String, dynamic>{
        'questions': questions,
        'answers': answers
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
}