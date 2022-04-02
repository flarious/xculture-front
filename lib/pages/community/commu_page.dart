import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/navbar.dart';
import 'package:xculturetestapi/pages/community/commu_all.dart';
import 'package:xculturetestapi/pages/community/commudetail_page.dart';
import 'package:xculturetestapi/pages/community/commupost_page.dart';
import 'package:http/http.dart' as http;
import '../../data.dart';
import '../../helper/auth.dart';
import '../../widgets/hamburger_widget.dart';

class CommuPage extends StatefulWidget {
  const CommuPage({ Key? key }) : super(key: key);

  @override
  _CommuPageState createState() => _CommuPageState();
}

class _CommuPageState extends State<CommuPage> {
  Future<List<Community>>? _futureCommu;

  // Change color (prefix icon)
  FocusNode fieldnode = FocusNode();

  // Search Function
  String searchString = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _futureCommu = getCommus();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: const Text(
        //     "Community",
        //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
        //   ),
        //   actions: <Widget>[Container()],
        // ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                // Thumbnail Image
                Container(
                  margin: const EdgeInsets.only(right: 0, left: 0),
                  child: Container(
                    height: 300,
                    width: 500,
                    color: Colors.red,
                    child: Container(
                      padding: const EdgeInsets.only(left: 60, top: 30),
                      // padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text("Community",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container (                                  
                    height: 40,
                    width: 350,
                    // margin: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 0),
                    margin: const EdgeInsets.only(top: 100),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      focusNode: fieldnode,
                      onChanged: (value) {
                          setState((){
                            searchString = value; 
                          });
                      },
                      
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search Community..",
                        hintStyle: const TextStyle(
                          color: Colors.grey, // <-- Change this
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                        contentPadding: const EdgeInsets.only(bottom: 10),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        
                        // prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        prefixIcon: Icon(Icons.search,
                              color: fieldnode.hasFocus 
                              ? Theme.of(context).primaryColor
                              : Colors.grey),
                      ),
                      
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.7),
                          blurRadius: 3.0,
                          offset: const Offset(0.0, 4.0),
                        ),
                      ],
                    ),
                  ),
                ),
          
                // Iconbutton back
                // Container(
                //   margin: const EdgeInsets.only(top: 20, left: 20),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.grey.withOpacity(0.8),
                //       shape: BoxShape.circle,
                //     ),
                //     child: IconButton(
                //       visualDensity: VisualDensity.compact,
                //       icon: const Icon(Icons.arrow_back),
                //       iconSize: 30,
                //       color: Colors.white,
                //       onPressed: () {
                //         Navigator.pop(context);
                //       },
                //     ),
                //   ),   
                // ),
          
                // Content
                Container(          
                  margin: const EdgeInsets.only(top: 160, left: 0, right: 0, bottom: 0),
                  child: Container(
                    height: 150,
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                  )
                ),
      
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 170, left: 20, right: 20),
                      // margin: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const Text("Trending Community",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 22),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                            // Navigator.pushNamed(context, 'forumAllPage', arguments: _futureForum).then(refreshPage);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommuAllPage(value: searchString),
                                settings: RouteSettings(
                                  arguments: _futureCommu,
                                ),
                              )
                            ).then(refreshPage);
                          }, 
                          child: const Text("See all")),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
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
                                var contained = searchCommunity(snapshot.data![index], searchString);
                                return contained ? InkWell(
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
                                ) : Container();
                              }
                            );
                          }
                          else {
                            return const CircularProgressIndicator();
                          }
                        }
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                      // margin: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const Text("Newest Community",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 22),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => CommuAllPage(value: '',),
                            //     settings: RouteSettings(
                            //       arguments: _futureCommu,
                            //     ),
                            //   )
                            // ).then(refreshPage);
                          }, 
                          child: const Text("See all")),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
        endDrawer: const NavigationDrawerWidget(),
        bottomNavigationBar: const Navbar(currentIndex: 3),
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

  // Function Search Community
  bool searchCommunity(Community data, String search) {
    var isContain = false;

    if (data.name.toLowerCase().contains(search.toLowerCase())) {
      isContain = true;
    }

    return isContain;

  }

}