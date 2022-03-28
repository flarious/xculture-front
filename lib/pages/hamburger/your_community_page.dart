import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/data.dart';
import 'package:xculturetestapi/navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/pages/community/commudetail_page.dart';



class YourCommuPage extends StatefulWidget {
  const YourCommuPage({ Key? key }) : super(key: key);

  @override
  _YourCommuPageState createState() => _YourCommuPageState();
}

class _YourCommuPageState extends State<YourCommuPage> with TickerProviderStateMixin {
  Future<List<Community>>? _futureCommu;


  // Change color (prefix icon)
  FocusNode fieldnode = FocusNode();

  // Tab controller
  late TabController _tabController;

  // Search Function
  String searchString = "";
  TextEditingController searchController = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    _futureCommu = getCommus();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);

  }


    @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<List<Community>>(
            future: _futureCommu,
            builder: (BuildContext context, AsyncSnapshot<List<Community>> snapshot) {
              if (snapshot.hasData) {               
                  return Stack(
                    children: [
                      // Thumbnail Image
                      Container(
                        margin: const EdgeInsets.only(right: 0, left: 0),
                        child: Container(
                          height: 300,
                          width: 500,
                          color: Colors.red,
                          child: Container(
                            padding: const EdgeInsets.only(left: 30, top: 70),
                            // padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: const Text("Your \n Community",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40),
                            ),
                          ),
                        ),
                      ),

                      // Iconbutton back
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20),
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

                      // Content
                      Container(
                        margin: const EdgeInsets.only(top: 220, left: 0, right: 0, bottom: 0),
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
                                Container (                                  
                                  height: 40,
                                  margin: const EdgeInsets.only(top: 20),
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
                                        color: Colors.grey.withOpacity(0.7),
                                        blurRadius: 3.0,
                                        offset: const Offset(0.0, 4.0),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  height: 400,
                                  // color: Colors.red,
                                  margin: const EdgeInsets.only(top: 20),
                                  width: double.maxFinite,
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [ 
                                      FutureBuilder<List<Community>>(
                                        builder: (BuildContext context, AsyncSnapshot<List<Community>> snapshot) {
                                          if (snapshot.hasData) {
                                            // snapshot.data!.sort((b, a) => (a.viewed + a.favorited).compareTo((b.viewed + b.favorited)));
                                            return ListView.builder(
                                              itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5,
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (BuildContext context, int index) {
                                                var contained = searchCommunity(snapshot.data![index], searchString);
                                                return contained ? InkWell(
                                                  child: Container(
                                                    margin: const EdgeInsets.all(10),
                                                    // margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                                    width: 100,
                                                    height: 240,
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
                                                        Container(
                                                          height: 120,
                                                          width: 350,
                                                          decoration: BoxDecoration(
                                                            borderRadius: const BorderRadius.only(
                                                              topLeft: Radius.circular(20),
                                                              topRight: Radius.circular(20),
                                                            ),
                                                            image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: NetworkImage(snapshot.data![index].thumbnail) // Forum Image
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 200,
                                                          margin: const EdgeInsets.only(top: 140, left: 20, right: 0, bottom: 20),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(snapshot.data![index].name,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: const TextStyle(
                                                                  fontSize: 20.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              Text(snapshot.data![index].shortdesc,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: const TextStyle(
                                                                  fontSize: 15.0,
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              Text(
                                                                "Members : ${snapshot.data![index].memberAmount.toString()}",
                                                                style: const TextStyle(fontSize: 15), // Community Subtitle
                                                              ),
                                                            ],
                                                          ),
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
                                        },
                                        future: _futureCommu,
                                      ),
                                      FutureBuilder<List<Community>>(
                                        builder: (BuildContext context, AsyncSnapshot<List<Community>> snapshot) {
                                          if (snapshot.hasData) {
                                            return ListView.builder(
                                              itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5,
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (BuildContext context, int index) {
                                                var contained = searchCommunity(snapshot.data![index], searchString);
                                                return contained ? InkWell(
                                                  child: Container(
                                                    margin: const EdgeInsets.all(10),
                                                    // margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                                    width: 100,
                                                    height: 240,
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
                                                        Container(
                                                          height: 120,
                                                          width: 350,
                                                          decoration: BoxDecoration(
                                                            borderRadius: const BorderRadius.only(
                                                              topLeft: Radius.circular(20),
                                                              topRight: Radius.circular(20),
                                                            ),
                                                            image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: NetworkImage(snapshot.data![index].thumbnail) // Event Image
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 200,
                                                          margin: const EdgeInsets.only(top: 140, left: 20, right: 0, bottom: 20),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                snapshot.data![index].name,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: const TextStyle(
                                                                  fontSize: 20.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              Text(
                                                                snapshot.data![index].shortdesc,    // Event location
                                                                overflow: TextOverflow.ellipsis,
                                                                style: const TextStyle(
                                                                  fontSize: 15.0,
                                                                  color: Colors.black,
                                                                )
                                                              ),
                                                              Text(
                                                                "Members : ${snapshot.data![index].memberAmount.toString()}",
                                                                style: const TextStyle(fontSize: 15), // Community Subtitle
                                                              ),
                                                            ],
                                                          ),
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
                                        },
                                        future: _futureCommu,
                                      ),
                                    ],
                                  )
                                ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Tab bar
                      Container(
                        height: 45,
                        width: 260,
                        margin: const EdgeInsets.only(top: 195, left: 65),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.red, width: 3.0),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.7),
                              blurRadius: 3.0,
                              offset: const Offset(0.0, 4.0),
                            ),
                          ],
                        ),
                        child: TabBar(
                          controller: _tabController,
                          labelColor: Colors.black,
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          unselectedLabelColor: Colors.grey,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: Colors.transparent,
                          labelPadding: const EdgeInsets.all(0),
                          indicatorPadding: const EdgeInsets.all(0),
                          tabs: [

                            _individualTab("Joined"),
                            const Tab(text: "Pending")
                          ],
                        ),
                      ),
                    ],
                  );
              } else {
                return const CircularProgressIndicator();
              }
            }
          ),
        ),
        // Navbar
        bottomNavigationBar: Navbar.navbar(context, 4),
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

  // Function Search Community
  bool searchCommunity(Community data, String search) {
    var isContain = false;

    if (data.name.toLowerCase().contains(search.toLowerCase())) {
      isContain = true;
    }

    return isContain;

  }

  // Divider
  Widget _individualTab(String topic) {
    return Container(
      height: 30,
      padding: const EdgeInsets.all(0),
      width: double.infinity,
      decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.black, width: 1, style: BorderStyle.solid))),
      child: Tab(
        text: topic,
      ),
    );
  }

}






