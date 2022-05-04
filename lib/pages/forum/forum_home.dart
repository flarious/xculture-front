import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/navbar.dart';
import 'package:xculturetestapi/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/pages/forum/forum_new.dart';
import 'package:xculturetestapi/pages/forum/forum_all.dart';
import 'package:xculturetestapi/pages/forum/forum_detail.dart';
import 'package:xculturetestapi/widgets/hamburger_widget.dart';



class ForumPage extends StatefulWidget {
  const ForumPage({ Key? key }) : super(key: key);

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  Future<List<Forum>>? trendingForum;
  Future<List<Forum>>? newestForum;


  // Change color (prefix icon)
  FocusNode fieldnode = FocusNode();

  // Search Function
  String searchString = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    trendingForum = getForums();
    newestForum = getForums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text(
      //     "Forum",
      //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
      //   ),
      //   actions: <Widget>[Container()],
      // ),
      backgroundColor: Colors.white,
      body: showTopFiveForum(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (AuthHelper.checkAuth()) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewForumPage(),
              )
            ).then(refreshPage);
          }
          else {
            Fluttertoast.showToast(msg: "You are not signed in");
          }
        },
        child: const Icon(Icons.post_add)
      ),
      endDrawer: const NavigationDrawerWidget(),
      bottomNavigationBar: const Navbar(currentIndex: 2),
    );
  }

  FutureOr refreshPage(dynamic value) {
    setState(() {
      trendingForum = getForums();
      newestForum = getForums();
    });
  }

  Widget showTopFiveForum() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          children: [

            // Forum
            Container(
              margin: const EdgeInsets.only(right: 0, left: 0),
              child: Container(
                height: 300,
                width: 500,
                color: Colors.red,
                child: Container(
                  padding: const EdgeInsets.only(left: 120, top: 30),
                  // padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: const Text("Forums",
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
                    hintText: "Search Forum..",
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
                          const Text("Trending Forum",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 22),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                            // Navigator.pushNamed(context, 'forumAllPage', arguments: _futureForum).then(refreshPage);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForumAllPage(value: searchString),
                                settings: RouteSettings(
                                  arguments: trendingForum,
                                ),
                              )
                            ).then(refreshPage);
                          }, 
                          child: const Text("See all")),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 300,
                      child: FutureBuilder<List<Forum>>(
                        future: trendingForum,
                        builder: (BuildContext context, AsyncSnapshot<List<Forum>> snapshot){
                          if (snapshot.hasData) {
                            snapshot.data!.sort((b, a) => (a.viewed + a.favorited).compareTo((b.viewed + b.favorited)));
                            return ListView.separated(
                              itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (BuildContext context, int index) { 
                                return const SizedBox(width: 15); 
                              },
                              itemBuilder: (BuildContext context, int index) {
                                var contained = searchForum(snapshot.data![index], searchString);
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
                                            Stack(
                                              children: [
                                                Ink.image(
                                                  image: NetworkImage(snapshot.data![index].thumbnail),
                                                  height: 150,
                                                  fit: BoxFit.cover,
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Text(snapshot.data![index].title,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Text(snapshot.data![index].subtitle,
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
                                            builder: (context) => const ForumDetailPage(),
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
                        // child: ListView(
                        //   scrollDirection: Axis.horizontal,
                        //   children: [
                        //     Container(
                        //       width: 300,
                        //       height: 400,
                        //       color: Colors.blue,
                        //       child: Column(
                        //         children: [
                                  
                        //         ],
                        //       ),
                        //     ),
                        //     const SizedBox(width: 12),
                        //   ],
                        // ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          const Text("Newest Forum",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 22),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                            // Navigator.pushNamed(context, 'forumAllPage', arguments: _futureForum).then(refreshPage);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForumAllPage(value: '',),
                                settings: RouteSettings(
                                  arguments: newestForum,
                                ),
                              )
                            ).then(refreshPage);
                          }, 
                          child: const Text("See all")),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 300,
                      child: FutureBuilder<List<Forum>>(
                        future: newestForum,
                        builder: (BuildContext context, AsyncSnapshot<List<Forum>> snapshot){
                          if (snapshot.hasData) {
                            snapshot.data!.sort((b, a) => (a.createDate).compareTo((b.createDate)));
                            return ListView.separated(
                              itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (BuildContext context, int index) { 
                                return const SizedBox(width: 15); 
                              },
                              itemBuilder: (BuildContext context, int index) {
                                var contained = searchForum(snapshot.data![index], searchString);
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
                                            Stack(
                                              children: [
                                                Ink.image(
                                                  image: NetworkImage(snapshot.data![index].thumbnail),
                                                  height: 150,
                                                  fit: BoxFit.cover,
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Text(snapshot.data![index].title,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Text(snapshot.data![index].subtitle,
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
                                            builder: (context) => const ForumDetailPage(),
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
                        // child: ListView(
                        //   scrollDirection: Axis.horizontal,
                        //   children: [
                        //     Container(
                        //       width: 300,
                        //       height: 400,
                        //       color: Colors.blue,
                        //       child: Column(
                        //         children: [
                                  
                        //         ],
                        //       ),
                        //     ),
                        //     const SizedBox(width: 12),
                        //   ],
                        // ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                // child: Column(
                //   children: [
                //     Row(
                //       children: [
                //         const Text("Trending Forum",
                //           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 22),
                //         ),
                //         const Spacer(),
                //         TextButton(
                //           onPressed: () {
                //           // Navigator.pushNamed(context, 'forumAllPage', arguments: _futureForum).then(refreshPage);
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => ForumAllPage(value: searchString),
                //               settings: RouteSettings(
                //                 arguments: trendingForum,
                //               ),
                //             )
                //           ).then(refreshPage);
                //         }, 
                //         child: const Text("See all")),
                //       ],
                //     ),

                //     Container(
                //       width: double.maxFinite,
                //       height: 250,
                //       // color: Colors.red,
                //       margin: const EdgeInsets.only(left: 5, bottom: 10),
                //       // margin: const EdgeInsets.only(bottom: 10),
                //       child: FutureBuilder<List<Forum>>(
                //         future: trendingForum,
                //         builder: (BuildContext context, AsyncSnapshot<List<Forum>> snapshot) {
                //           if (snapshot.hasData) {
                //             snapshot.data!.sort((b, a) => (a.viewed + a.favorited).compareTo((b.viewed + b.favorited)));
                //             return ListView.builder(
                //               itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5,
                //               scrollDirection: Axis.horizontal,
                //               itemBuilder: (BuildContext context, int index) {
                //                 var contained = searchForum(snapshot.data![index], searchString);
                //                 return contained ? InkWell(
                //                   // child: Container(
                //                   //   margin: const EdgeInsets.all(10),
                //                   //   width: 300,
                //                   //   //height: 100,
                //                   //   decoration: BoxDecoration(
                //                   //     borderRadius: BorderRadius.circular(20),
                //                   //     color: Colors.white,
                //                   //     boxShadow: [
                //                   //       BoxShadow(
                //                   //         color: Colors.grey.withOpacity(0.7),
                //                   //         blurRadius: 5.0,
                //                   //         offset: const Offset(0.0, 5.0),
                //                   //       ),
                //                   //     ],
                //                   //   ),
                //                   //   child: Stack(
                //                   //     children: [
                //                   //       Container(
                //                   //         height: 120,
                //                   //         width: 300,
                //                   //         decoration: BoxDecoration(
                //                   //           borderRadius: const BorderRadius.only(
                //                   //             topLeft: Radius.circular(20),
                //                   //             topRight: Radius.circular(20),
                //                   //           ),
                //                   //           image: DecorationImage(
                //                   //             fit: BoxFit.fill,
                //                   //             image: NetworkImage(snapshot.data![index].thumbnail) // Forum Image
                //                   //           ),
                //                   //         ),
                //                   //       ),
                //                   //       Container(
                //                   //         height: 200,
                //                   //         margin: const EdgeInsets.only(top: 140, left: 20, right: 0, bottom: 20),
                //                   //         child: Column(
                //                   //           crossAxisAlignment: CrossAxisAlignment.start,
                //                   //           children: [
                //                   //             Text(snapshot.data![index].title,
                //                   //               overflow: TextOverflow.ellipsis,
                //                   //               style: const TextStyle(
                //                   //                 fontSize: 20.0,
                //                   //                 fontWeight: FontWeight.bold,
                //                   //               ),
                //                   //             ),
                //                   //             Text(snapshot.data![index].subtitle,
                //                   //               overflow: TextOverflow.ellipsis,
                //                   //               style: const TextStyle(
                //                   //                 fontSize: 15.0,
                //                   //                 color: Colors.black,
                //                   //               ),
                //                   //             ),
                //                   //             Row(
                //                   //               crossAxisAlignment: CrossAxisAlignment.start,
                //                   //               children: snapshot.data![index].tags.take(2).map((tag) => Padding(
                //                   //                 padding: const EdgeInsets.only(right: 10),
                //                   //                 child: Chip(
                //                   //                   label: Text(tag.name),
                //                   //                 ),
                //                   //               )).toList(),
                //                   //             ),
                //                   //           ],
                //                   //         ),
                //                   //       )
                //                   //     ],
                //                   //   ),
                //                   // ),
                //                   child: Card(
                //                     elevation: 4.0,
                //                     shape: RoundedRectangleBorder(
                //                       borderRadius: BorderRadius.circular(20)
                //                     ),
                //                     child: SizedBox(
                //                       height: 250,
                //                       width: 250,
                //                       child: Stack(
                //                         children: [
                //                           Ink.image(
                //                             image: NetworkImage(snapshot.data![index].thumbnail),
                //                             height: 150,
                //                             fit: BoxFit.cover,
                //                           ),
                //                           Text("hi")
                //                         ],
                //                       ),
                //                     ), 
                //                   ),
                //                   onTap: () {
                //                     Navigator.push(
                //                       context,
                //                       MaterialPageRoute(
                //                         builder: (context) => const ForumDetailPage(),
                //                         settings: RouteSettings(
                //                           arguments: snapshot.data![index],
                //                         ),
                //                       )
                //                     ).then(refreshPage);
                //                   },
                //                 ) : Container();
                //               }
                //             );
                //           }
                //           else {
                //             return const CircularProgressIndicator();
                //           }
                //         },
                //       )
                //     ),
                //     Container(
                //       margin: const EdgeInsets.only(left: 20, right: 20),
                //       // margin: const EdgeInsets.all(20),
                //       child: Row(
                //         children: [
                //           const Text("Newest Forum",
                //             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 22),
                //           ),
                //           const Spacer(),
                //           TextButton(
                //             onPressed: () {
                            
                //             // Navigator.pushNamed(context, 'forumAllPage', arguments: _futureForum).then(refreshPage);
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                 builder: (context) => ForumAllPage(value: '',),
                //                 settings: RouteSettings(
                //                   arguments: newestForum,
                //                 ),
                //               )
                //             ).then(refreshPage);

                //           }, 
                //           child: const Text("See all")),
                //         ],
                //       ),
                //     ),
                //     Container(
                //       height: 290,
                //       child: Container(
                //         height: 250,
                //         // color: Colors.red,
                //         margin: const EdgeInsets.only(left: 5, bottom: 10),
                //         // margin: const EdgeInsets.only(bottom: 10),
                //         width: double.maxFinite,
                //         child: FutureBuilder<List<Forum>>(
                //           future: newestForum,
                //           builder: (BuildContext context, AsyncSnapshot<List<Forum>> snapshot) {
                //             if (snapshot.hasData) {
                //               snapshot.data!.sort((b, a) => (a.createDate).compareTo((b.createDate)));
                //               return ListView.builder(
                //                 itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5,
                //                 scrollDirection: Axis.horizontal,
                //                 itemBuilder: (BuildContext context, int index) {
                //                   var contained = searchForum(snapshot.data![index], searchString);
                //                   return contained ? InkWell(
                //                     child: Container(
                //                       margin: const EdgeInsets.all(10),
                //                       width: 300,
                //                       // height: 100,
                //                       decoration: BoxDecoration(
                //                         borderRadius: BorderRadius.circular(20),
                //                         color: Colors.lightBlue[100],
                //                         boxShadow: [
                //                           BoxShadow(
                //                             color: Colors.grey.withOpacity(0.7),
                //                             blurRadius: 5.0,
                //                             offset: const Offset(0.0, 5.0),
                //                           ),
                //                         ],
                //                       ),
                //                       child: Stack(
                //                         children: [
                //                           Container(
                //                             height: 120,
                //                             width: 300,
                //                             decoration: BoxDecoration(
                //                               borderRadius: const BorderRadius.only(
                //                                 topLeft: Radius.circular(20),
                //                                 topRight: Radius.circular(20),
                //                               ),
                //                               image: DecorationImage(
                //                                 fit: BoxFit.fill,
                //                                 image: NetworkImage(snapshot.data![index].thumbnail) // Forum Image
                //                               ),
                //                             ),
                //                           ),
                //                           Container(
                //                             height: 200,
                //                             margin: const EdgeInsets.only(top: 140, left: 20, right: 0, bottom: 20),
                //                             child: Column(
                //                               crossAxisAlignment: CrossAxisAlignment.start,
                //                               children: [
                //                                 Text(snapshot.data![index].title,
                //                                   overflow: TextOverflow.ellipsis,
                //                                   style: const TextStyle(
                //                                     fontSize: 20.0,
                //                                     fontWeight: FontWeight.bold,
                //                                   ),
                //                                 ),
                //                                 Text(snapshot.data![index].subtitle,
                //                                   overflow: TextOverflow.ellipsis,
                //                                   style: const TextStyle(
                //                                     fontSize: 15.0,
                //                                     color: Colors.black,
                //                                   ),
                //                                 ),
                //                                 Row(
                //                                   crossAxisAlignment: CrossAxisAlignment.start,
                //                                   children: snapshot.data![index].tags.take(2).map((tag) => Padding(
                //                                     padding: const EdgeInsets.only(right: 10),
                //                                     child: Chip(
                //                                       label: Text(tag.name),
                //                                     ),
                //                                   )).toList(),
                //                                 ),
                //                               ],
                //                             ),
                //                           )
                //                         ],
                //                       ),
                //                     ),
                //                     onTap: () {
                //                       Navigator.push(
                //                         context,
                //                         MaterialPageRoute(
                //                           builder: (context) => const ForumDetailPage(),
                //                           settings: RouteSettings(
                //                             arguments: snapshot.data![index],
                //                           ),
                //                         )
                //                       ).then(refreshPage);
                //                     },
                //                   ) : Container();
                //                 }
                //               );
                //             }
                //             else {
                //               return const CircularProgressIndicator();
                //             }
                //           }
                //         )
                //       ),
                //     ),
                //   ],
                // ),
              ),
            ),
      
            // Column(
            //   children: [
            //     Row(
            //       children: [
            //         const Text("Trending Forum",
            //           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 22),
            //         ),
            //         const Spacer(),
            //         TextButton(
            //           onPressed: () {
            //           // Navigator.pushNamed(context, 'forumAllPage', arguments: _futureForum).then(refreshPage);
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => ForumAllPage(value: searchString),
            //               settings: RouteSettings(
            //                 arguments: trendingForum,
            //               ),
            //             )
            //           ).then(refreshPage);
            //         }, 
            //         child: const Text("See all")),
            //       ],
            //     ),

            //     Container(
            //       width: double.maxFinite,
            //       height: 250,
            //       // color: Colors.red,
            //       margin: const EdgeInsets.only(left: 5, bottom: 10),
            //       // margin: const EdgeInsets.only(bottom: 10),
            //       child: FutureBuilder<List<Forum>>(
            //         future: trendingForum,
            //         builder: (BuildContext context, AsyncSnapshot<List<Forum>> snapshot) {
            //           if (snapshot.hasData) {
            //             snapshot.data!.sort((b, a) => (a.viewed + a.favorited).compareTo((b.viewed + b.favorited)));
            //             return ListView.builder(
            //               itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5,
            //               scrollDirection: Axis.horizontal,
            //               itemBuilder: (BuildContext context, int index) {
            //                 var contained = searchForum(snapshot.data![index], searchString);
            //                 return contained ? InkWell(
            //                   // child: Container(
            //                   //   margin: const EdgeInsets.all(10),
            //                   //   width: 300,
            //                   //   //height: 100,
            //                   //   decoration: BoxDecoration(
            //                   //     borderRadius: BorderRadius.circular(20),
            //                   //     color: Colors.white,
            //                   //     boxShadow: [
            //                   //       BoxShadow(
            //                   //         color: Colors.grey.withOpacity(0.7),
            //                   //         blurRadius: 5.0,
            //                   //         offset: const Offset(0.0, 5.0),
            //                   //       ),
            //                   //     ],
            //                   //   ),
            //                   //   child: Stack(
            //                   //     children: [
            //                   //       Container(
            //                   //         height: 120,
            //                   //         width: 300,
            //                   //         decoration: BoxDecoration(
            //                   //           borderRadius: const BorderRadius.only(
            //                   //             topLeft: Radius.circular(20),
            //                   //             topRight: Radius.circular(20),
            //                   //           ),
            //                   //           image: DecorationImage(
            //                   //             fit: BoxFit.fill,
            //                   //             image: NetworkImage(snapshot.data![index].thumbnail) // Forum Image
            //                   //           ),
            //                   //         ),
            //                   //       ),
            //                   //       Container(
            //                   //         height: 200,
            //                   //         margin: const EdgeInsets.only(top: 140, left: 20, right: 0, bottom: 20),
            //                   //         child: Column(
            //                   //           crossAxisAlignment: CrossAxisAlignment.start,
            //                   //           children: [
            //                   //             Text(snapshot.data![index].title,
            //                   //               overflow: TextOverflow.ellipsis,
            //                   //               style: const TextStyle(
            //                   //                 fontSize: 20.0,
            //                   //                 fontWeight: FontWeight.bold,
            //                   //               ),
            //                   //             ),
            //                   //             Text(snapshot.data![index].subtitle,
            //                   //               overflow: TextOverflow.ellipsis,
            //                   //               style: const TextStyle(
            //                   //                 fontSize: 15.0,
            //                   //                 color: Colors.black,
            //                   //               ),
            //                   //             ),
            //                   //             Row(
            //                   //               crossAxisAlignment: CrossAxisAlignment.start,
            //                   //               children: snapshot.data![index].tags.take(2).map((tag) => Padding(
            //                   //                 padding: const EdgeInsets.only(right: 10),
            //                   //                 child: Chip(
            //                   //                   label: Text(tag.name),
            //                   //                 ),
            //                   //               )).toList(),
            //                   //             ),
            //                   //           ],
            //                   //         ),
            //                   //       )
            //                   //     ],
            //                   //   ),
            //                   // ),
            //                   child: Card(
            //                     elevation: 4.0,
            //                     shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.circular(20)
            //                     ),
            //                     child: SizedBox(
            //                       height: 250,
            //                       width: 250,
            //                       child: Stack(
            //                         children: [
            //                           Ink.image(
            //                             image: NetworkImage(snapshot.data![index].thumbnail),
            //                             height: 150,
            //                             fit: BoxFit.cover,
            //                           ),
            //                           Text("hi")
            //                         ],
            //                       ),
            //                     ), 
            //                   ),
            //                   onTap: () {
            //                     Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                         builder: (context) => const ForumDetailPage(),
            //                         settings: RouteSettings(
            //                           arguments: snapshot.data![index],
            //                         ),
            //                       )
            //                     ).then(refreshPage);
            //                   },
            //                 ) : Container();
            //               }
            //             );
            //           }
            //           else {
            //             return const CircularProgressIndicator();
            //           }
            //         },
            //       )
            //     ),
            //     Container(
            //       margin: const EdgeInsets.only(left: 20, right: 20),
            //       // margin: const EdgeInsets.all(20),
            //       child: Row(
            //         children: [
            //           const Text("Newest Forum",
            //             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 22),
            //           ),
            //           const Spacer(),
            //           TextButton(
            //             onPressed: () {
                        
            //             // Navigator.pushNamed(context, 'forumAllPage', arguments: _futureForum).then(refreshPage);
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) => ForumAllPage(value: '',),
            //                 settings: RouteSettings(
            //                   arguments: newestForum,
            //                 ),
            //               )
            //             ).then(refreshPage);

            //           }, 
            //           child: const Text("See all")),
            //         ],
            //       ),
            //     ),
            //     Container(
            //       height: 290,
            //       child: Container(
            //         height: 250,
            //         // color: Colors.red,
            //         margin: const EdgeInsets.only(left: 5, bottom: 10),
            //         // margin: const EdgeInsets.only(bottom: 10),
            //         width: double.maxFinite,
            //         child: FutureBuilder<List<Forum>>(
            //           future: newestForum,
            //           builder: (BuildContext context, AsyncSnapshot<List<Forum>> snapshot) {
            //             if (snapshot.hasData) {
            //               snapshot.data!.sort((b, a) => (a.createDate).compareTo((b.createDate)));
            //               return ListView.builder(
            //                 itemCount: (snapshot.data!.length <= 5) ? snapshot.data!.length : 5,
            //                 scrollDirection: Axis.horizontal,
            //                 itemBuilder: (BuildContext context, int index) {
            //                   var contained = searchForum(snapshot.data![index], searchString);
            //                   return contained ? InkWell(
            //                     child: Container(
            //                       margin: const EdgeInsets.all(10),
            //                       width: 300,
            //                       // height: 100,
            //                       decoration: BoxDecoration(
            //                         borderRadius: BorderRadius.circular(20),
            //                         color: Colors.lightBlue[100],
            //                         boxShadow: [
            //                           BoxShadow(
            //                             color: Colors.grey.withOpacity(0.7),
            //                             blurRadius: 5.0,
            //                             offset: const Offset(0.0, 5.0),
            //                           ),
            //                         ],
            //                       ),
            //                       child: Stack(
            //                         children: [
            //                           Container(
            //                             height: 120,
            //                             width: 300,
            //                             decoration: BoxDecoration(
            //                               borderRadius: const BorderRadius.only(
            //                                 topLeft: Radius.circular(20),
            //                                 topRight: Radius.circular(20),
            //                               ),
            //                               image: DecorationImage(
            //                                 fit: BoxFit.fill,
            //                                 image: NetworkImage(snapshot.data![index].thumbnail) // Forum Image
            //                               ),
            //                             ),
            //                           ),
            //                           Container(
            //                             height: 200,
            //                             margin: const EdgeInsets.only(top: 140, left: 20, right: 0, bottom: 20),
            //                             child: Column(
            //                               crossAxisAlignment: CrossAxisAlignment.start,
            //                               children: [
            //                                 Text(snapshot.data![index].title,
            //                                   overflow: TextOverflow.ellipsis,
            //                                   style: const TextStyle(
            //                                     fontSize: 20.0,
            //                                     fontWeight: FontWeight.bold,
            //                                   ),
            //                                 ),
            //                                 Text(snapshot.data![index].subtitle,
            //                                   overflow: TextOverflow.ellipsis,
            //                                   style: const TextStyle(
            //                                     fontSize: 15.0,
            //                                     color: Colors.black,
            //                                   ),
            //                                 ),
            //                                 Row(
            //                                   crossAxisAlignment: CrossAxisAlignment.start,
            //                                   children: snapshot.data![index].tags.take(2).map((tag) => Padding(
            //                                     padding: const EdgeInsets.only(right: 10),
            //                                     child: Chip(
            //                                       label: Text(tag.name),
            //                                     ),
            //                                   )).toList(),
            //                                 ),
            //                               ],
            //                             ),
            //                           )
            //                         ],
            //                       ),
            //                     ),
            //                     onTap: () {
            //                       Navigator.push(
            //                         context,
            //                         MaterialPageRoute(
            //                           builder: (context) => const ForumDetailPage(),
            //                           settings: RouteSettings(
            //                             arguments: snapshot.data![index],
            //                           ),
            //                         )
            //                       ).then(refreshPage);
            //                     },
            //                   ) : Container();
            //                 }
            //               );
            //             }
            //             else {
            //               return const CircularProgressIndicator();
            //             }
            //           }
            //         )
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ), 
    );
  }

  Future<List<Forum>> getForums() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/forums'));
    final List<Forum> forumList = [];

    if(response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      decoded.forEach((obj) => forumList.add(Forum.fromJson(obj)));
      return forumList;
    } 
    else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      return forumList;
    }
  } 


    // Function Search Forum
  bool searchForum(Forum data, String search) {
    var isContain = false;

    if (data.title.toLowerCase().contains(search.toLowerCase())) {
      isContain = true;
    }
    else if (data.tags.isNotEmpty) {
      for (var tag in data.tags) {
        if(tag.name.toLowerCase().contains(search.toLowerCase())) {
          isContain = true;
        }
      }
    }

    return isContain;

  }

}