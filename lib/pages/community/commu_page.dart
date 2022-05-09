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
import 'package:xculturetestapi/widgets/guesthamburger_widget.dart';
import '../../data.dart';
import '../../helper/auth.dart';
import '../../widgets/hamburger_widget.dart';

class CommuPage extends StatefulWidget {
  const CommuPage({ Key? key }) : super(key: key);

  @override
  _CommuPageState createState() => _CommuPageState();
}

class _CommuPageState extends State<CommuPage> {
  Future<List<Community>>? trendingCommu;
  Future<List<Community>>? newestCommu;

  // Change color (prefix icon)
  FocusNode fieldnode = FocusNode();

  // Search Function
  String searchString = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    trendingCommu = getCommus();
    newestCommu = getCommus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: showTopFiveCommunity(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (AuthHelper.checkAuth()) {
            await Navigator.push(
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
      endDrawer: AuthHelper.checkAuth() ? const NavigationDrawerWidget() : const GuestHamburger(),
      bottomNavigationBar: const Navbar(currentIndex: 3),
    );
  }

  FutureOr refreshPage(dynamic value) {
    setState(() {
      trendingCommu = getCommus();
      newestCommu = getCommus();
    });
  }

  Widget showTopFiveCommunity() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          children: [

            //Post Forum text
            Container(
              margin: const EdgeInsets.only(right: 0, left: 0),
              height: 300,
              color: Colors.red,
              child: Center(
                child: Column(
                  children: [

                    const SizedBox(height: 30),

                    const Text("Communities", 
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                    ),

                    const SizedBox(height: 10),

                    Container (                                  
                      height: 40,
                      width: 350,
                      // margin: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 0),
                      //margin: const EdgeInsets.only(top: 100),
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
                  ],
                ),
              ),
            ),
      
            // Content
            Container(          
              margin: const EdgeInsets.only(top: 160, left: 0, right: 0, bottom: 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(10.0),
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
                                  arguments: trendingCommu,
                                ),
                              )
                            ).then(refreshPage);
                          }, 
                          child: const Text("See all")),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 270,
                      child: FutureBuilder<List<Community>>(
                        future: trendingCommu,
                        builder: (BuildContext context, AsyncSnapshot<List<Community>> snapshot){
                          if (snapshot.hasData) {
                            snapshot.data!.sort((b, a) => (a.memberAmount).compareTo((b.memberAmount)));
                            return ListView.separated(
                              itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (BuildContext context, int index) { 
                                return const SizedBox(width: 15); 
                              },
                              itemBuilder: (BuildContext context, int index) {
                                var contained = searchCommunity(snapshot.data![index], searchString);
                                return contained ? Card(
                                    //elevation: 4.0,
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: InkWell(
                                      child: SizedBox(
                                        width: 300,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Ink.image(
                                              image: NetworkImage(snapshot.data![index].thumbnail),
                                              height: 150,
                                              fit: BoxFit.cover,
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Text(snapshot.data![index].name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Text(snapshot.data![index].shortdesc,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),

                                            //const SizedBox(height: 10),

                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Text("Members : ${snapshot.data![index].memberAmount.toString()}",
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
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
                                    ), 
                                  ): Container();
                              },
                            );
                          }
                          else {
                              return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          const Text("Newest Community",
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
                                  arguments: newestCommu,
                                ),
                              )
                            ).then(refreshPage);
                          }, 
                          child: const Text("See all")),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 270,
                      child: FutureBuilder<List<Community>>(
                        future: newestCommu,
                        builder: (BuildContext context, AsyncSnapshot<List<Community>> snapshot){
                          if (snapshot.hasData) {
                            snapshot.data!.sort((b, a) => (a.createDate).compareTo((b.createDate)));
                            return ListView.separated(
                              itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (BuildContext context, int index) { 
                                return const SizedBox(width: 15); 
                              },
                              itemBuilder: (BuildContext context, int index) {
                                var contained = searchCommunity(snapshot.data![index], searchString);
                                return contained ? Card(
                                    //elevation: 4.0,
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: InkWell(
                                      child: SizedBox(
                                        width: 300,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Ink.image(
                                              image: NetworkImage(snapshot.data![index].thumbnail),
                                              height: 150,
                                              fit: BoxFit.cover,
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Text(snapshot.data![index].name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Text(snapshot.data![index].shortdesc,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),

                                            //const SizedBox(height: 10),

                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Text("Members : ${snapshot.data![index].memberAmount.toString()}",
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
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
                                    ), 
                                  ): Container();
                              },
                            );
                          }
                          else {
                              return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ), 
    );
  }
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