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
  int j = 1;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _shortdesc = TextEditingController();
  final TextEditingController _thumbnail = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  bool isPrivate = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // leading: const Icon(Icons.arrow_back),
          title: const Text("Create Community",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*
                  TextForm(label: "Topic"),
                  TextForm(label: "Catagory"),
                  // Row(
                  //   children: [
                  //     const Text("Upload Thumbnail", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  //     IconButton(onPressed: (){}, icon: const Icon(Icons.upload_file)),
                  //   ],
                  // ),
                  TextForm(label: "Upload Thumbnail URL"),
                  TextForm(label: "Description", isMultiText: true),
                  */
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
                                  j = int.parse(valueChoose);
                                });
                              }
                            )
                          ],
                        ),
                        Column(
                          children: [
                            for(int i = 1; i <= j; i++)
                              TextForm(label: "Add Question $i"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if(_formKey.currentState!.validate()) {
                        var success = await sendCommuDetail(_name.text, _shortdesc.text, _desc.text, _thumbnail.text);
                        if (success) {
                          Fluttertoast.showToast(msg: "Your community have been created.");
                          Navigator.pop(context);
                        }
                      }
                    }, 
                    child: const SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: Text("Post Now")
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
        endDrawer: const NavigationDrawerWidget(),
        bottomNavigationBar: const Navbar(currentIndex: 3),
    );
  }

  Future<bool> sendCommuDetail(String name, String shortdesc, String desc, String thumbnail) async {
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