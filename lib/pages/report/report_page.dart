import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/data.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/helper/auth.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({ Key? key }) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<ReportCategory> topics = [];
  Future<List<ReportCategory>>? categories;
  final TextEditingController _detail = TextEditingController();

  @override
  void initState() {
    super.initState();
    categories = getReportCategories();
  }

  @override
  Widget build(BuildContext context) {
    final String itemId = ModalRoute.of(context)!.settings.arguments as String;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepOrange,
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, itemId);
            return false;
          },
          child: SingleChildScrollView(
            child: FutureBuilder<List<ReportCategory>>(
              future: categories,
              builder: (context, AsyncSnapshot<List<ReportCategory>> snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                
                      //Report text
                      Container(
                        margin: const EdgeInsets.only(right: 0, left: 0),
                        height: 180,
                        color: const Color.fromRGBO(220, 71, 47, 1),
                        child: const Center(
                          child: Text("Report", 
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
                              Navigator.pop(context, itemId);
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                
                              //Choose your report reason
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                child: Text("Choose your report reason",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23, color: Colors.red)
                                ),
                              ),
                
                              //FilterChip
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: snapshot.data!.map((item) => Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: FilterChip(
                                      label: Text(item.category),
                                      selected: topics.contains(item),
                                      selectedColor: const Color.fromRGBO(220, 71, 47, 1),
                                      onSelected: (bool selected){
                                        setState(() {
                                          if (selected) {
                                            topics.add(item);
                                          } else {
                                            topics.remove(item);
                                          }
                                        });
                                      },
                                    ),
                                  )).toList(),
                                ),
                              ),
                
                              //Tell us more about this
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Text("Please tell us more about this",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              
                              //Textformfield
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: TextFormField(
                                  maxLines: 5,
                                  controller: _detail,
                                  keyboardType: TextInputType.multiline,
                                  decoration: const InputDecoration(
                                    hintText: "Text here...",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                
                              const SizedBox(height: 20),
                
                              //Button
                              ElevatedButton(
                                onPressed: (){
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Report"),
                                      content: const Text("Are you sure you want to report?"),
                                      actions: [
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                          onPressed: (){
                                            //Back
                                            Navigator.pop(context);
                                          }, 
                                          child: const Text("No")
                                        ),
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                          onPressed: () async {
                                            var success = await sendReport(itemId, topics, _detail.text);
                                            if (success) {
                                              Fluttertoast.showToast(msg: "Your report has been received.");
                                              Navigator.pop(context);
                                              Navigator.pop(context, itemId);
                                            }
                                            //Join
                                          }, 
                                          child: const Text("Yes", 
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                      elevation: 24.0,
                                    ),
                                  );
                                }, 
                                child: const SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: Center(
                                    child: Text("Report"),
                                  ),
                                ),
                              ),
                
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ), 
                    ],
                  );
                }
                else {
                  return const CircularProgressIndicator();
                }
              } 
            ),
          ),
        ),
      ),
    );
  }

  Future<List<ReportCategory>> getReportCategories() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:3000/report"));
    final List<ReportCategory> categoryList = [];
    if(response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      decoded.forEach((obj) => categoryList.add(ReportCategory.fromJson(obj)));
      return categoryList;
    }
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return categoryList;
    }
  }

  Future<bool> sendReport(reportedId, List<ReportCategory> topics, String detail) async {
    List<int> topicsID = [];

    for (var topic in topics) {
      topicsID.add(topic.id);
      if(topic.category != "Others") {
        if(detail == "") {
          detail = topic.category;
        }
        else {
          detail = detail + ", " + topic.category;
        }
        
      }
    }

    final userToken = await AuthHelper.getToken();
    final response = await http.post(
      Uri.parse("http://10.0.2.2:3000/report/$reportedId"),
      headers: <String, String> {
        'Content-Type' : 'application/json; charset=UTF-8',
        'Authorization' : 'bearer $userToken'
      },
      body: jsonEncode(<String, dynamic> {
        'topics': topicsID,
        'detail': detail,
      })
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