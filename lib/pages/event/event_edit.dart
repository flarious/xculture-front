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
  final TextEditingController _date = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    final eventDetail = ModalRoute.of(context)!.settings.arguments as Event;

    _location.text = eventDetail.location;
    _thumbnail.text = eventDetail.thumbnail;
    _name.text = eventDetail.name;
    _desc.text = eventDetail.body;
    var dt = DateTime.parse(eventDetail.date).toLocal();
    String dateEvent = DateFormat('dd/MM/yyyy').format(dt);
    _date.text = dateEvent;

    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text(
      //     "Edit Event",
      //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
      //   ),
      // ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, eventDetail.id);
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
                  child: Text("Post Event", 
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
                          TextFormField(
                            controller: _thumbnail,
                            decoration: const InputDecoration(
                              labelText: "Upload Thumbnail URL",
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter event's thumbnail url";
                              }
                              else {
                                return null;
                              }
                            },
                          ),

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

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(350, 50),
                            ),
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Post"),
                                  content: Text("Do you want to post this event?"),
                                  actions: [
                                    FlatButton(
                                      onPressed: (){}, 
                                      child: Text("No")
                                    ),
                                    FlatButton(
                                      onPressed: () async {
                                        if(_formKey.currentState!.validate()) {
                                          var success = await updateForumDetail(eventDetail.id, _name.text, _desc.text, _thumbnail.text, _location.text, _date.text);
                                          if (success) {
                                            Fluttertoast.showToast(msg: "Your post has been updated.");
                                            Navigator.pop(context, eventDetail.id);
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
      bottomNavigationBar: Navbar.navbar(context, 0),
    );
  }

  Future<bool> updateForumDetail(int eventID, String name, String desc, String thumbnail, String location, String date) async {
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

                  