import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/navbar.dart';
import 'package:xculturetestapi/pages/community/commudetail_page.dart';
import 'package:xculturetestapi/pages/community/commupost_page.dart';
import 'package:http/http.dart' as http;
import '../../data.dart';
import '../../helper/auth.dart';

class CommuPage extends StatefulWidget {
  const CommuPage({ Key? key }) : super(key: key);

  @override
  _CommuPageState createState() => _CommuPageState();
}

class _CommuPageState extends State<CommuPage> {
  Future<List<Community>>? _futureCommu;

  @override
  void initState() {
    super.initState();

    _futureCommu = getCommus();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Community",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: const [
                    Text("Trending Community",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 22),
                    ),
                    Spacer(),
                    Text("See all"),
                  ],
                ),
              ),
              Container(
                height: 250,
                width: double.maxFinite,
                child: FutureBuilder<List<Community>>(
                  future: _futureCommu,
                  builder: (BuildContext context, AsyncSnapshot<List<Community>> snapshot) { 
                    if(snapshot.hasData) {
                      return ListView.builder(
                        itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5, // number of item to display
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.lightBlue[100],
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    blurRadius: 5.0,
                                    offset: const Offset(0.0, 5.0),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    child: Container(
                                      height: 120,
                                      width: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(snapshot.data![index].thumbnail) // Community Image
                                        ),
                                      ),
                                    )
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 140, left: 20, right: 0, bottom: 0),
                                    /* top: 140,
                                    left: 20, */
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data![index].name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                          overflow: TextOverflow.ellipsis, // Community Title
                                        ),
                                        Text(
                                          snapshot.data![index].shortdesc,
                                          style: const TextStyle(fontSize: 15), // Community Subtitle
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "Members : ${snapshot.data![index].memberAmount.toString()}",
                                          style: const TextStyle(fontSize: 15), // Community Subtitle
                                        ),
                                      ],
                                    )
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CommuDetailPage(),
                                  settings: RouteSettings(
                                    arguments: snapshot.data![index],
                                  ),
                                )
                              ).then(refreshPage);
                            },
                          );
                        }
                      );
                    }
                    else {
                      return const CircularProgressIndicator();
                    }
                  }
                ),
              ),

              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: const [
                    Text("Newest Community",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 22),
                    ),
                    Spacer(),
                    Text("See all"),
                  ],
                ),
              ),
              /*
              Container(
                height: 250,
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: 5, // number of item to display
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.all(10),
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.lightBlue[100],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            blurRadius: 5.0,
                            offset: const Offset(0.0, 5.0),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            child: Container(
                              height: 120,
                              width: 300,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage("assets/images/Rengoku.jpg") // Community Image
                                ),
                              ),
                            )
                          ),
                          Positioned(
                            top: 140,
                            left: 20,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Bacon",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), // Community Title
                                  ),
                                  Text(
                                    "Bacon Addict",
                                    style: TextStyle(fontSize: 15), // Community Subtitle
                                  ),
                                  Text(
                                    "11 Members",
                                    style: TextStyle(fontSize: 15), // Community Subtitle
                                  ),
                                ],
                              ),
                            )
                          )
                        ],
                      ),
                    );
                  }
                ),
                
              ),
              */
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (AuthHelper.checkAuth()) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CommuPostPage(),
                )
              ).then(refreshPage);
            }
            else {
              Fluttertoast.showToast(msg: "You are not signed in");
            }
          },
          child: const Icon(Icons.group_add_outlined)
        ),
        bottomNavigationBar: Navbar.navbar(context, 3),
      ),
    );
  }

  FutureOr refreshPage(dynamic value) {
    setState(() {
      _futureCommu = getCommus();
    });
  }

  Future<List<Community>> getCommus() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/communities'));
    final List<Community> forumList = [];

    if(response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      decoded.forEach((obj) => forumList.add(Community.fromJson(obj)));
      return forumList;
    } 
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return forumList;
    }
  } 
}