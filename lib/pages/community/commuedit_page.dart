import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/navbar.dart';
import 'package:xculturetestapi/widgets/guesthamburger_widget.dart';
import 'package:xculturetestapi/widgets/textform_widget.dart';

import '../../widgets/hamburger_widget.dart';

// image
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xculturetestapi/helper/storage.dart';

class EditCommuPage extends StatefulWidget {
  const EditCommuPage({ Key? key }) : super(key: key);

  @override
  _EditCommuPageState createState() => _EditCommuPageState();
}

class _EditCommuPageState extends State<EditCommuPage>{

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

  Community? commuDetail;

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

  Widget commuPhoto() {
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
  Widget build(BuildContext context) {
    if(commuDetail == null) {
      commuDetail = ModalRoute.of(context)!.settings.arguments as Community;
      _name.text = commuDetail!.name;
      _shortdesc.text = commuDetail!.shortdesc;
      _thumbnail.text = commuDetail!.thumbnail;
      _desc.text = commuDetail!.desc;
      isPrivate = commuDetail!.type == "private" ? true: false;
      if (isPrivate) {
        questionAmount = commuDetail!.questions.length;
        valueChoose = commuDetail!.questions.length.toString();
        for (int i = _questions.length; i < questionAmount; i++) {
          _questions.add(TextEditingController(text: commuDetail!.questions[i].question));
        }
      }      
    }

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
          Navigator.pop(context, commuDetail!.id);
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
                  child: Text("Edit Community", 
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
                        Navigator.pop(context, commuDetail!.id);
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
                            commuPhoto(),
                            // TextFormField(
                            //   controller: _thumbnail,
                            //   decoration: const InputDecoration(
                            //     labelText: "Thumbnail URL",
                            //     labelStyle: TextStyle(color: Colors.grey),
                            //     enabledBorder: UnderlineInputBorder(
                            //       borderSide: BorderSide(
                            //         color: Colors.grey
                            //       ),
                            //     ),
                            //   ),
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return "Please enter community's thumbnail url";
                            //     }
                            //     else {
                            //       return null;
                            //     }
                            //   },
                            // ),
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
                                    title: Text("Edit Community"),
                                    content: Text("Do you want to edit this community?"),
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
                                              final fileName = DateTime.now().toString() + '_' + _name.text + '.jpg';
                                              firebase_storage.uploadCommu(path, fileName).then((value) async {
                                                var success = await updateCommuDetail(commuDetail!.id, _name.text, _shortdesc.text, value, _desc.text, isPrivate, _questions);
                                                if(success) {
                                                  Fluttertoast.showToast(msg: "Your community has been updated.");
                                                  Navigator.pop(context);
                                                  Navigator.pop(context, commuDetail!.id);
                                                } else {
                                                  Navigator.pop(context);
                                                }
                                              });  
                                            } else {
                                              var success = await updateCommuDetail(commuDetail!.id, _name.text, _shortdesc.text, _thumbnail.text, _desc.text, isPrivate, _questions);
                                              if(success) {
                                                Fluttertoast.showToast(msg: "Your community has been updated.");
                                                Navigator.pop(context);
                                                Navigator.pop(context, commuDetail!.id);
                                              } else {
                                                Navigator.pop(context);
                                              }
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
                              child: const Text("Edit Community")
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
      bottomNavigationBar: const Navbar(currentIndex: 3),
    );
  }

  updateCommuDetail(String commuID, String name, String shortdesc, String thumbnail, String desc, bool isPrivate, List<TextEditingController> _questions) async {
    final type = isPrivate ? "private" : "public";
    List<String> questions = isPrivate ? [for (int i = 0; i < _questions.length; i++) _questions[i].text] : [];
    
    final userToken = await AuthHelper.getToken();
    final response = await http.put(
      Uri.parse('https://xculture-server.herokuapp.com/communities/$commuID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $userToken'
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'short_description': shortdesc,
        'thumbnail': thumbnail,
        'description': desc,
        'type': type,
        'questions': questions
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