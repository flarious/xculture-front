import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/navbar.dart';

class EditCommuPage extends StatefulWidget {
  const EditCommuPage({ Key? key }) : super(key: key);

  @override
  _EditCommuPageState createState() => _EditCommuPageState();
}

class _EditCommuPageState extends State<EditCommuPage>{

  List<String> items = ["1","2","3","4","5","6","7","8","9","10"];
  String valueChoose = "1";
  int j = 1;
  
  final TextEditingController _name = TextEditingController();
  final TextEditingController _shortdesc = TextEditingController();
  final TextEditingController _thumbnail = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  bool? isPrivate;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final commuDetail = ModalRoute.of(context)!.settings.arguments as Community;

    if(isPrivate == null) {
       _name.text = commuDetail.name;
       _shortdesc.text = commuDetail.shortdesc;
       _thumbnail.text = commuDetail.thumbnail;
       _desc.text = commuDetail.desc;
       isPrivate = false;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Community",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, commuDetail.id);
          return false;
        },
        child: SingleChildScrollView(
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
                  // const SizedBox(height: 20),
                  // SwitchListTile(
                  //   title: const Text("Incognito"),
                  //   activeColor: Theme.of(context).primaryColor,
                  //   subtitle: const Text("If incognito is on this post will hide author/owner username."),
                  //   value: incognito!, 
                  //   onChanged: (selected){
                  //     setState(() {
                  //       incognito = !incognito!;
                  //     });
                  //   }
                  // ),
                  SwitchListTile(
                    title: const Text("Private"),
                    activeColor: Theme.of(context).primaryColor,
                    subtitle: const Text("If private is on, anyone who want to join this community must have to answer the questions from you first."),
                    value: isPrivate!, 
                    onChanged: (selected){
                      setState(() {
                        isPrivate = !isPrivate!;
                      });
                    }
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: isPrivate!,
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
                                  j = int.parse(valueChoose);
                                });
                              }
                            )
                          ],
                        ),
                        Column(
                          children: [
                            for(int i = 1; i <= j; i++)
                              Text("Add Question $i"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(350, 50),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState!.validate()) {
                        var success = await updateCommuDetail(commuDetail.id, _name.text, _shortdesc.text, _thumbnail.text, _desc.text);
                        if (success) {
                          Fluttertoast.showToast(msg: "Your community has been updated.");
                          Navigator.pop(context, commuDetail.id);
                        }
                      }
                    }, 
                    child: const Text("Edit Community")
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            )
          )
        )
      ),
      bottomNavigationBar: Navbar.navbar(context, 3),
    );
  }

  updateCommuDetail(int commuID, String name, String shortdesc, String thumbnail, String desc) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/communities/$commuID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $userToken'
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'short_description': shortdesc,
        'thumbnail': thumbnail,
        'description': desc
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