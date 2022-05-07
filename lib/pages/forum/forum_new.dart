import 'dart:async';
import 'dart:convert';
import 'package:xculturetestapi/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/navbar.dart';

import '../../widgets/hamburger_widget.dart';


class NewForumPage extends StatefulWidget {
  const NewForumPage({ Key? key }) : super(key: key);
  @override
  _NewForumPageState createState() => _NewForumPageState();
}
class _NewForumPageState extends State<NewForumPage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _subtitle = TextEditingController();
  final TextEditingController _thumbnail = TextEditingController();
  final TextEditingController _content = TextEditingController();
  bool incognito = false;

  List<Tag> arr = [];
  Future<List<Tag>>? tags;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    tags = getTags();
  }

  @override
  Widget build(BuildContext context) {
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
                //color: Color.fromRGBO(220, 71, 47, 1),
                color: Colors.red,
                child: const Center(
                  child: Text("Post Forum", 
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
                            controller: _title,
                            decoration: const InputDecoration(
                              labelText: "Title",
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter forum's title";
                              }
                              else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _subtitle,
                            decoration: const InputDecoration(
                              labelText: "Subtitle",
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter forum's subtitle";
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
                              labelText: "Upload Forum Thumbnail",
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter forum's thumbnail url";
                              }
                              else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          FutureBuilder<List<Tag>>(
                            future: tags,
                            builder: (BuildContext context, AsyncSnapshot<List<Tag>> snapshot) {
                              if(snapshot.hasData) {
                                return Row(
                                  children: [
                                    const Text("Add Tags"),
                                    const SizedBox(width: 20),
                                    FindDropdown<Tag>(
                                      items: snapshot.data,
                                      onChanged: (item) {
                                        setState(() {
                                          if(!arr.contains(item)){
                                            arr.add(item!);
                                          }
                                        });
                                      },
                                      // ignore: deprecated_member_use
                                      searchHint: "Search here",
                                      backgroundColor: Colors.white,
                                    ),
                                  ],
                                );
                              }
                              else {
                                return const CircularProgressIndicator();
                              }
                            }
                          ),
                          
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              children: arr.map((e) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Chip(
                                  label: Text(e.name),
                                  deleteIcon: const Icon(Icons.clear),
                                  onDeleted: () {
                                    setState(() {
                                      arr.remove(e);
                                    });
                                  },
                                ),
                              )).toList(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            maxLines: 10,
                            keyboardType: TextInputType.multiline,
                            controller: _content,
                            decoration: const InputDecoration(
                              hintText: "Enter Your Content Here",
                              hintStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter forum's content";
                              }
                              else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          SwitchListTile(
                            title: const Text("Incognito"),
                            activeColor: Theme.of(context).primaryColor,
                            subtitle: const Text("If incognito is on this post will hide author/owner username."),
                            value: incognito, 
                            onChanged: (selected){
                              setState(() {
                                incognito = !incognito;
                              });
                            }
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
                                  title: Text("Post Forum"),
                                  content: Text("Do you want to post this forum?"),
                                  actions: [
                                    FlatButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      }, 
                                      child: Text("No")
                                    ),
                                    FlatButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          var success =  await sendForumDetail(_title.text, _subtitle.text, _thumbnail.text, _content.text, incognito, arr);
                                          if(success) {
                                            Fluttertoast.showToast(msg: "Your post has been created.");
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
                            child: const Text("Post Forum")
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
      bottomNavigationBar: const Navbar(currentIndex: 2),
    );
  }

  Future<bool> sendForumDetail(String title, String subtitle, String thumbnailUrl, String content, bool isSwitched, List<Tag> tags) async {
    List<int> tagsID = [];
    for (var tag in tags) {
      tagsID.add(tag.id);
    }

    final userToken = await AuthHelper.getToken();

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/forums'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $userToken',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'subtitle': subtitle,
        'thumbnail': thumbnailUrl,
        'content': content,
        'incognito': isSwitched,
        'tags': tagsID,
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

  Future<List<Tag>> getTags() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/tags'));
    final List<Tag> tagList = [];
    if(response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      decoded.forEach((obj) => tagList.add(Tag.fromJson(obj)));
      return tagList;
    }
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return tagList;
    }
  }
}
