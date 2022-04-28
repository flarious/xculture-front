import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:xculturetestapi/widgets/textform_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../data.dart';
import '../../helper/auth.dart';
import '../../navbar.dart';
import '../../widgets/hamburger_widget.dart';

class CommuPostPage extends StatefulWidget {
  const CommuPostPage({ Key? key }) : super(key: key);

  @override
  _CommuPostPageState createState() => _CommuPostPageState();
}

class _CommuPostPageState extends State<CommuPostPage> {

  List<String> items = ["1","2","3","4","5","6","7","8","9","10"];
  String valueChoose = "1";
  int questionAmount = 1;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _shortdesc = TextEditingController();
  final TextEditingController _thumbnail = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  List<TextEditingController> _questions = [];
  bool isPrivate = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (_questions.length != questionAmount) {
      if (_questions.length < questionAmount) {
        for (int i = _questions.length; i < questionAmount; i++) {
          _questions.add(TextEditingController());
        }
      }
      else if (_questions.length > questionAmount) {
        for (int i = _questions.length; i > questionAmount; i--) {
          _questions.removeLast();
        }
      }
    }

    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text(
      //     "Post Forum",
      //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
      //   ),
      // ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: SingleChildScrollView(
          child: Stack(
            children: [

              //Report text
              Container(
                margin: const EdgeInsets.only(right: 0, left: 0),
                height: 180,
                color: Color.fromRGBO(220, 71, 47, 1),
                child: const Center(
                  child: Text("Post Community", 
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
                      Navigator.pop(context);
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
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _name,
                            decoration: const InputDecoration(
                              labelText: "Name",
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter community's name";
                              }
                              else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _shortdesc,
                            decoration: const InputDecoration(
                              labelText: "Short Description",
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter community's short description";
                              }
                              else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _thumbnail,
                            decoration: const InputDecoration(
                              labelText: "Thumbnail URL",
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter community's thumbnail url";
                              }
                              else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            maxLines: 10,
                            keyboardType: TextInputType.multiline,
                            controller: _desc,
                            decoration: const InputDecoration(
                              hintText: "Description",
                              hintStyle: TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter community's description";
                              }
                              else {
                                return null;
                              }
                            },
                          ),
                        const SizedBox(height: 20),
                        SwitchListTile(
                          title: const Text("Private"),
                          activeColor: Theme.of(context).primaryColor,
                          subtitle: const Text("If private is on, anyone who want to join this community must have to answer the questions from you first."),
                          value: isPrivate, 
                          onChanged: (selected){
                            setState(() {
                              isPrivate = !isPrivate;
                            });
                          }
                        ),
                        const SizedBox(height: 20),
                        Visibility(
                          visible: isPrivate,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text("Question amount",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 20),
                                  DropdownButton(
                                    //hint: const Text("Select Items : "),
                                    value: valueChoose,
                                    items: items.map((valueItem) {
                                      return DropdownMenuItem(
                                        value: valueItem,
                                        child: Text(valueItem),
                                      );
                                    }).toList(), 
                                    onChanged: (value) {
                                      setState(() {
                                        valueChoose = value.toString();
                                        questionAmount = int.parse(valueChoose);
                                      });
                                    }
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  for(int i = 0; i < questionAmount; i++)
                                    TextFormField(
                                      controller: _questions[i],
                                      decoration: InputDecoration(
                                        labelText: "Question ${i + 1}",
                                        labelStyle: const TextStyle(color: Colors.grey),
                                        enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter community's question";
                                        }
                                        else {
                                          return null;
                                        }
                                      },
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                          const SizedBox(height: 20),
                          //Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(350, 50),
                            ),
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Post Community"),
                                  content: Text("Do you want to post this community?"),
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
                                          var success = await sendCommuDetail(_name.text, _shortdesc.text, _desc.text, _thumbnail.text, isPrivate, _questions);
                                          if (success) {
                                            Fluttertoast.showToast(msg: "Your community have been created.");
                                            Navigator.pop(context);
                                            Navigator.pop(context);
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
                            child: const Text("Post Community")
                          ),
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
      endDrawer: const NavigationDrawerWidget(),
      bottomNavigationBar: const Navbar(currentIndex: 3),
    );
  }

  Future<bool> sendCommuDetail(String name, String shortdesc, String desc, String thumbnail, bool isPrivate, List<TextEditingController> _questions) async {
    final type = isPrivate ? "private" : "public";
    List<String> questions = isPrivate ? [for (int i = 0; i < _questions.length; i++) _questions[i].text] : [];

    final userToken = await AuthHelper.getToken();

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/communities'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $userToken',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'short_description': shortdesc,
        'description': desc,
        'thumbnail': thumbnail,
        'type': type,
        'questions': questions
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