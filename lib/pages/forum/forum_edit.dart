import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/navbar.dart';
import 'package:xculturetestapi/widgets/guesthamburger_widget.dart';

import '../../widgets/hamburger_widget.dart';

// image
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xculturetestapi/helper/storage.dart';

class EditForumPage extends StatefulWidget {
  const EditForumPage({ Key? key }) : super(key: key);

  @override
  _EditForumPageState createState() => _EditForumPageState();
}

class _EditForumPageState extends State<EditForumPage>{
  final TextEditingController _title = TextEditingController();
  final TextEditingController _subtitle = TextEditingController();
  final TextEditingController _thumbnail = TextEditingController();
  final TextEditingController _content = TextEditingController();
  bool incognito = false;

  List<Tag> arr = [];
  Future<List<Tag>>? tags;

  final _formKey = GlobalKey<FormState>();

  Forum? forumDetail;


  // image
  File? image;
  final Storage firebase_storage = Storage();


  Future takePhoto(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image $e');
    }
  }

  Widget forumPhoto() {
    return Stack(
        children: <Widget>[
          Container(
              child: image == null ? Container(
                child: Row(
                  children: const [
                    Text(
                      "Upload Thumbnail ",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Icon(
                      Icons.file_upload_sharp,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ],
                ),
                // child: CircleAvatar(
                //     radius: 50,
                //     backgroundColor: Colors.transparent,
                //     backgroundImage: NetworkImage(_thumbnail.text)
                // ),
              ) : Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(0)
                ),
                child: Flexible(
                  child: Image.file(
                    image!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              )
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              // color: Colors.amber,
              height: 300,
              width: 350,
              // decoration: BoxDecoration(
              //     color: Colors.black.withOpacity(0.3),
              //     borderRadius: BorderRadius.circular(50)
              // ),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet<void>(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 150,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 0.8,
                                        color: Colors.grey.withOpacity(0.5)),
                                  )
                                ),
                                child: ListTile(
                                  onTap: () async {
                                    Future.delayed(Duration(seconds: 5));
                                    Navigator.of(context).pop();
                                    await takePhoto(ImageSource.camera);
                                  },
                                  leading: const Icon(
                                    Icons.photo_camera_front_outlined,
                                    color: Colors.black,
                                  ),
                                  title: const Text("Take a photo",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  )
                                ),
                            ),
                            Container(
                                child: ListTile(
                                  onTap: () async {
                                    Future.delayed(Duration(seconds: 5));
                                    Navigator.of(context).pop();
                                    await takePhoto(ImageSource.gallery);
                                  },
                                  leading: const Icon(
                                    Icons.photo_library_outlined,
                                    color: Colors.black,
                                  ),
                                  title: const Text("Choose from gallery",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  )
                                ),
                            ),
                          ],
                        ),

                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      );
  }


  @override
  void initState() {
    super.initState();
    tags = getTags();
  }

  @override
  Widget build(BuildContext context) {
    if(forumDetail == null) {
      forumDetail = ModalRoute.of(context)!.settings.arguments as Forum;
      _title.text = forumDetail!.title;
      _subtitle.text = forumDetail!.subtitle;
      _thumbnail.text = forumDetail!.thumbnail;
      _content.text = forumDetail!.content;
      incognito = forumDetail!.incognito;
      arr = forumDetail!.tags;
    }

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: const Text(
        //     "Post Forum",
        //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
        //   ),
        // ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, forumDetail!.id);
            return false;
          },
          child: SingleChildScrollView(
            child: Stack(
              children: [
    
                //Report text
                Container(
                  margin: const EdgeInsets.only(right: 0, left: 0),
                  height: 180,
                  color: Colors.red,
                  child: const Center(
                    child: Text("Edit Forum", 
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
                        Navigator.pop(context, forumDetail!.id);
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
                            forumPhoto(),
                            // TextFormField(
                            //   controller: _thumbnail,
                            //   decoration: const InputDecoration(
                            //     labelText: "Upload Forum Thumbnail",
                            //     labelStyle: TextStyle(color: Colors.grey),
                            //     enabledBorder: UnderlineInputBorder(
                            //       borderSide: BorderSide(
                            //         color: Colors.grey
                            //       ),
                            //     ),
                            //   ),
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return "Please enter forum's thumbnail url";
                            //     }
                            //     else {
                            //       return null;
                            //     }
                            //   },
                            // ),
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
                              decoration: InputDecoration(
                                label: Text("Description"),
                                labelStyle: TextStyle(color: Colors.grey),
                                alignLabelWithHint: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.grey
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
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
                                    title: Text("Edit Forum"),
                                    content: Text("Do you want to edit this forum?"),
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
                                            final path = image?.path;
                                            if (path != null) {
                                              final fileName = DateTime.now().toString() + '_' + _title.text + '.jpg';
                                              firebase_storage.uploadForum(path, fileName).then((value) async {
                                                var success = await updateForumDetail(forumDetail!.id, _title.text, _subtitle.text, value, _content.text, incognito, arr);
                                                if(success) {
                                                  Fluttertoast.showToast(msg: "Your forum has been updated.");
                                                  Navigator.pop(context);
                                                  Navigator.pop(context, forumDetail!.id);
                                                }
                                              });  
                                            } else {
                                              var success = await updateForumDetail(forumDetail!.id, _title.text, _subtitle.text, _thumbnail.text, _content.text, incognito, arr);
                                              if(success) {
                                                Fluttertoast.showToast(msg: "Your forum has been updated.");
                                                Navigator.pop(context);
                                                Navigator.pop(context, forumDetail!.id);
                                              }
                                            }
                                            // var success = await updateForumDetail(forumDetail!.id, _title.text, _subtitle.text, _thumbnail.text, _content.text, incognito, arr);
                                            // if(success) {
                                            //   Fluttertoast.showToast(msg: "Your forum has been updated.");
                                            //   Navigator.pop(context);
                                            //   Navigator.pop(context, forumDetail!.id);
                                            // }
                                          }
                                        }, 
                                        child: Text("Yes", style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                    elevation: 24.0,
                                  ),
                                );
                              }, 
                              child: const Text("Edit Forum")
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
        endDrawer: AuthHelper.checkAuth() ? const NavigationDrawerWidget() : const GuestHamburger(),
        bottomNavigationBar: const Navbar(currentIndex: 2),
      ),
    );
  }

  Future<bool> updateForumDetail(String forumID, String title, String subtitle, String thumbnailUrl, String content, bool incognito, List<Tag> tags) async {
    List<int> tagsID = [];
    for (var tag in tags) {
      tagsID.add(tag.id);
    }

    final userToken = await AuthHelper.getToken();

    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/forums/$forumID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $userToken',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'subtitle': subtitle,
        'thumbnail': thumbnailUrl,
        'content': content,
        'incognito': incognito,
        'tags': tagsID,
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