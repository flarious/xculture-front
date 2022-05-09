import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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

class EditEventPage extends StatefulWidget {
  const EditEventPage({ Key? key }) : super(key: key);
  @override
  _EditEventPageState createState() => _EditEventPageState();
}
class _EditEventPageState extends State<EditEventPage>{
  /*
  final TextEditingController _locationname = TextEditingController();
  final TextEditingController _address1 = TextEditingController();
  final TextEditingController _address2 = TextEditingController();
  final TextEditingController _district = TextEditingController();
  final TextEditingController _subdistrict = TextEditingController();
  final TextEditingController _province = TextEditingController();
  final TextEditingController _zipcode = TextEditingController();
  */
  final TextEditingController _location = TextEditingController();
  final TextEditingController _thumbnail = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _dateTime;
  Event? eventDetail;

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

  Widget eventPhoto() {
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
  Widget build(BuildContext context) {
    if (eventDetail == null) {
      eventDetail = ModalRoute.of(context)!.settings.arguments as Event;
      _location.text = eventDetail!.location;
      _thumbnail.text = eventDetail!.thumbnail;
      _name.text = eventDetail!.name;
      _desc.text = eventDetail!.body;
      _dateTime = DateTime.parse(eventDetail!.eventDate);
    }

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: const Text(
        //     "Edit Event",
        //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
        //   ),
        // ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, eventDetail!.id);
            return false;
          },
          child: SingleChildScrollView(
            child: Stack(
              children: [
                //Event text
                Container(
                  margin: const EdgeInsets.only(right: 0, left: 0),
                  height: 180,
                  color: Color.fromRGBO(220, 71, 47, 1),
                  child: const Center(
                    child: Text("Edit Event", 
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
                        Navigator.pop(context, eventDetail!.id);
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
                            //Name of Event
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
                                  return "Please enter event's name";
                                }
                                else {
                                  return null;
                                }
                              },
                            ),
                            
                            const SizedBox(height: 20),
                            //Thumbnail URL
                            eventPhoto(),
                            // TextFormField(
                            //   controller: _thumbnail,
                            //   decoration: const InputDecoration(
                            //     labelText: "Upload Thumbnail URL",
                            //     labelStyle: TextStyle(color: Colors.grey),
                            //     enabledBorder: UnderlineInputBorder(
                            //       borderSide: BorderSide(
                            //         color: Colors.grey
                            //       ),
                            //     ),
                            //   ),
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return "Please enter event's thumbnail url";
                            //     }
                            //     else {
                            //       return null;
                            //     }
                            //   },
                            // ),
                            const SizedBox(height: 20),
                            //Location
                            TextFormField(
                              controller: _location,
                              decoration: const InputDecoration(
                                labelText: "Location",
                                labelStyle: TextStyle(color: Colors.grey),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter event's location";
                                }
                                else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            //Description
                            TextFormField(
                              maxLines: 10,
                              keyboardType: TextInputType.multiline,
                              controller: _desc,
                              decoration: const InputDecoration(
                                hintText: "Description",
                                hintStyle: TextStyle(color: Colors.grey),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter event's description";
                                }
                                else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            //Start Date
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Text("Start Date",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                ),
                                IconButton(
                                  onPressed: (){
                                    DatePicker.showDateTimePicker(context, 
                                      showTitleActions: true,
                                      minTime: DateTime.now(),
                                      onChanged: (date) {
                                        print('change $date in time zone ' +
                                            date.timeZoneOffset.inHours.toString());
                                      }, onConfirm: (date) {
                                        setState(() {
                                          _dateTime = date;
                                        });
                                      }, currentTime: DateTime.now()
                                    );
                                  }, icon: const Icon(Icons.event)
                                ),
                              ],
                            ),
                            //Date result
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(_dateTime == null ? "Click an calendar icon above" : _dateTime.toString(),
                                style: const TextStyle(fontSize: 15, color: Colors.black),
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
                                    title: Text("Edit Event"),
                                    content: Text("Do you want to edit this event?"),
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
                                              firebase_storage.uploadEvent(path, fileName).then((value) async {
                                                var success = await updateEventDetail(eventDetail!.id, _name.text, _desc.text, value, _location.text, _dateTime.toString());
                                                if(success) {
                                                  Fluttertoast.showToast(msg: "Your event has been edited.");
                                                  Navigator.pop(context);
                                                  Navigator.pop(context, eventDetail!.id);
                                                }
                                              });  
                                            } else {
                                              var success = await updateEventDetail(eventDetail!.id, _name.text, _desc.text, _thumbnail.text, _location.text, _dateTime.toString());
                                              if(success) {
                                                Fluttertoast.showToast(msg: "Your event has been edited.");
                                                Navigator.pop(context);
                                                Navigator.pop(context, eventDetail!.id);
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
                              child: const Text("Edit Event")
                            ),
                            const SizedBox(height: 30),
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
        endDrawer: AuthHelper.checkAuth() ? const NavigationDrawerWidget() : const GuestHamburger(),
        bottomNavigationBar: const Navbar(currentIndex: 0),
      ),
    );
  }
  Future<bool> updateEventDetail(String eventID, String name, String desc, String thumbnail, String location, String date) async {
    final userToken = await AuthHelper.getToken();
    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/events/$eventID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $userToken'
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'body': desc,
        'thumbnail': thumbnail,
        'location': location,
        'date': date
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
                  
