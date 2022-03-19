import 'dart:convert';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Event",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, eventDetail.id);
          return false;
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /*
                  TextFormField(
                    controller: _locationname,
                    decoration: const InputDecoration(
                      labelText: "Location Name",
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter event's location name";
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _address1,
                    decoration: const InputDecoration(
                      labelText: "Address 1",
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter event's address 1";
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _address2,
                    decoration: const InputDecoration(
                      labelText: "Address 2",
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter event's address 2";
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _subdistrict,
                    decoration: const InputDecoration(
                      labelText: "Sub-District",
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter event's sub-district";
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _district,
                    decoration: const InputDecoration(
                      labelText: "District",
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter event's district";
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _province,
                    decoration: const InputDecoration(
                      labelText: "Province",
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter event's province";
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _zipcode,
                    decoration: const InputDecoration(
                      labelText: "ZIP Code",
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter event's zip code";
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                  */
                  // const SizedBox(height: 20),
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
                  TextFormField(
                    controller: _thumbnail,
                    decoration: const InputDecoration(
                      hintText: "Upload Thumbnail URL",
                      hintStyle: TextStyle(color: Colors.grey),
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
                TextFormField(
                  controller: _location,
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
                      return "Please enter event's location";
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
                      labelText: "Description",
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
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
                  TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller: _date,
                        decoration: const InputDecoration(
                          labelText: "Event Date DD/MM/YYYY",
                          labelStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter event's date";
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                  /*
                  Row(
                    children: [
                      TextFormField(
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        controller: _date,
                        decoration: const InputDecoration(
                          hintText: "Event Date DD/MM/YYYY",
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter event's date";
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                      IconButton(onPressed: (){}, icon: Icon(Icons.event)),
                      const SizedBox(width: 100),
                    ],
                  ),
                  */
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(350, 50),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState!.validate()) {
                        var success = await updateForumDetail(eventDetail.id, _name.text, _desc.text, _thumbnail.text, _location.text, _date.text);
                        if (success) {
                          Fluttertoast.showToast(msg: "Your post has been updated.");
                          Navigator.pop(context, eventDetail.id);
                        }
                      }
                    }, 
                    child: const Text("Edit Event")
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            )
          )
        )
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