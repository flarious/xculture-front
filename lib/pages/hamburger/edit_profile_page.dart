import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:xculturetestapi/data.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/model/user.dart';
import 'package:xculturetestapi/navbar.dart';
import 'package:xculturetestapi/utils/user_info.dart';
import 'package:xculturetestapi/widgets/hamburger_widget.dart';
import 'package:xculturetestapi/widgets/profile_widget.dart';
import 'package:xculturetestapi/widgets/textfield_widget.dart';
//import 'package:xculturetestapi/widgets/uploadprofile_widget.dart';
import 'package:xculturetestapi/widgets/uploadprofilepic_widget.dart';

class EditProfilePage extends StatefulWidget{
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage>{
  final TextEditingController _name = TextEditingController();
  final TextEditingController _thumbnail = TextEditingController();
  final TextEditingController _bio = TextEditingController();

  List<Tag> arr = [];
  Future<List<Tag>>? tags;

  final _formKey = GlobalKey<FormState>();

  Future<User>? userDetail;

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
                color: Color.fromRGBO(220, 71, 47, 1),
                child: const Center(
                  child: Text("Edit Profile", 
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
                  child: FutureBuilder<User>(
                    future: getUserProfile(),
                    builder: (context, AsyncSnapshot<User> snapshot) {
                      if (snapshot.hasData) {
                        if (userDetail == null) {
                          userDetail = getUserProfile();
                          _name.text = snapshot.data!.name;
                          _thumbnail.text = snapshot.data!.profilePic;
                          _bio.text = snapshot.data!.bio!;
                          arr = snapshot.data!.tags!;
                        }
                        
                        return Form(
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
                                      return "Please enter user's name";
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
                                    labelText: "User Thumbnail Url",
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter user's thumbnail url";
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
                                  controller: _bio,
                                  decoration: const InputDecoration(
                                    hintText: "Enter your bio here",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter user's bio";
                                    }
                                    else {
                                      return null;
                                    }
                                  },
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
                                        title: Text("Edit Profile"),
                                        content: Text("Do you want to edit your profile?"),
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
                                                var success = await updateUserProfile(_name.text, _thumbnail.text, _bio.text, arr);
                                                if(success) {
                                                  Fluttertoast.showToast(msg: "Your profile has been updated.");
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
                                  child: const Text("Edit Profile")
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      else {
                        return const CircularProgressIndicator();
                      }
                  })
                ),
              ),
            ],
          ),
        ),
      ),
      endDrawer: const NavigationDrawerWidget(),
      bottomNavigationBar: const Navbar(currentIndex: 4),
    );

/*
    return GetMaterialApp(
        theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: "Poppins",
      ),
        home: 
          Scaffold(
              appBar: AppBar(
              title: Text('Edit Profile'),
              centerTitle: true,
              backgroundColor: Colors.red,
            ),
            body: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 32),
              physics: BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 20),
                //const UploadProfileImageWidget(),
                UploadProfilePicWidget(
                  imagePath: user.imagePath, 
                  isEdit : true,
                  onclicked: () async{},
                  ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  label: 'Username', 
                  text: user.username, 
                  onChanged: (name){}
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  label: 'About me', 
                  text: user.about, 
                  maxLines:5,
                  onChanged: (about){},
                ),
                const SizedBox(height:20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(350, 50),
                      ),
                      onPressed: () async {}, 
                        child: const Text("Edit Profile")
                      ),        
              ],
            ),
          ),
  );
  */
  }

  Future<User> getUserProfile() async {
    final userToken = await AuthHelper.getToken();
    final response = await http.get(
      Uri.parse("http://10.0.2.2:3000/user"),
      headers: <String, String>{
        "Authorization" : "bearer $userToken",
      }
    );

    if(response.statusCode == 200) {
      print(jsonDecode(response.body));
      return User.formJson(jsonDecode(response.body));
    }
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      Navigator.pop(context);
      return User(id: "", name: "", profilePic: "", bio: "", email: "", tags: []);
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

  Future<bool> updateUserProfile(name, thumbnail, bio, tags) async {
    List<int> tagsID = [];
    for (var tag in tags) {
      tagsID.add(tag.id);
    }

    final userToken = await AuthHelper.getToken();
    final response = await http.put(
      Uri.parse("http://10.0.2.2:3000/user"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $userToken',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'profile_pic': thumbnail,
        'bio': bio,
        'tags': tagsID,
      }),
    );

    if(response.statusCode == 200) {
      return true;
    }
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return false;
    }
  }

}
