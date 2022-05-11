import 'package:intl/intl.dart';
import 'package:xculturetestapi/widgets/guesthamburger_widget.dart';
import '../../helper/auth.dart';
import 'package:flutter/material.dart';
import 'package:xculturetestapi/data.dart';
import 'package:xculturetestapi/navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/pages/forum/forum_new.dart';
import 'package:xculturetestapi/pages/event/eventdetail_page.dart';

import '../../widgets/hamburger_widget.dart';



class EventAllPage extends StatefulWidget {
  // const EventAllPage({Key? key}) : super(key: key);

  String value;
  EventAllPage({Key? key, required this.value}) : super(key: key);

  @override
  _EventAllPageState createState() => _EventAllPageState(value);
}

class _EventAllPageState extends State<EventAllPage> {

  String? values;
  String searchString;
  _EventAllPageState(this.searchString);

  bool isAscending = false;
  bool isDescending = false;

  List sortList = [
    "Ascending",
    "Descending"
  ];
  // String searchString = "";
  // TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final eventList =
        ModalRoute.of(context)!.settings.arguments as Future<List<Event>>;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: showAllEvent(eventList),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (AuthHelper.checkAuth()) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewForumPage(),
                )
              );
            }
            else {
              Fluttertoast.showToast(msg: "You are not signed in");
            }
          },
          child: const Icon(Icons.post_add)
        ),
        endDrawer: AuthHelper.checkAuth() ? const NavigationDrawerWidget() : const GuestHamburger(),
        bottomNavigationBar: const Navbar(currentIndex: 0),
      ),
    );
  }

  Widget showAllEvent(Future<List<Event>> dataList) {
    return Column(
      children: <Widget>[

        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
          child: const Text("Event", 
            style: TextStyle(
              fontSize: 40, 
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ),
        /*
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  onChanged: (value) {
                      setState((){
                        searchString = value; 
                      });
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search Here...",
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
        */
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  onChanged: (value) {
                      setState((){
                        searchString = value; 
                      });
                  },
                  // controller: searchController,
                  //style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Search Here...",
                    hintStyle: TextStyle(fontSize: 20.0),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.red),
                  ),
                ),
              ),
              DropdownButtonHideUnderline(
                child: Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton(
                    hint: const Text("Sort by..."),
                    icon: const Icon(Icons.arrow_drop_down),
                    items: sortList.map((value){
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: values,
                    onChanged: (value) {
                      setState(() {
                        this.values = value as String?;
                        if(value == "Ascending") {
                          isAscending = true;
                          isDescending = false;
                        }
                        else if(value == "Descending") {
                          isAscending = false;
                          isDescending = true;
                        }
                      });
                    }
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: FutureBuilder<List<Event>>(
            builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
              if (snapshot.hasData) {
                isAscending ? snapshot.data!.sort((b, a) => (b.name).compareTo((a.name))) : "";
                isDescending ? snapshot.data!.sort((b, a) => (a.name).compareTo((b.name))) : "";
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    var dt = DateTime.parse(snapshot.data![index].eventDate).toLocal();
                    String dateEvent = DateFormat('MMMM dd, yyyy').format(dt);
                    var contained = isContain(snapshot.data![index], searchString);
                    return contained ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        color: Colors.grey[50],
                        child: InkWell(
                          // padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            height: 100,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                          
                                AspectRatio(
                                  aspectRatio: 0.9,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                      ),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(snapshot.data![index].thumbnail) // Forum Image
                                      ),
                                    ),
                                  ),
                                ),
                          
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                                
                                        Text(snapshot.data![index].name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                                
                                        Text(dateEvent,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black,
                                          ),
                                        ),
                          
                                        Text(snapshot.data![index].location,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                                
                                        // Text(snapshot.data![index].author.name,
                                        //   style: const TextStyle(
                                        //     fontSize: 12.0,
                                        //     //color: Colors.black,
                                        //   ),
                                        // ),
                                                
                                        // Text(formattedDate,
                                        //   style: const TextStyle(
                                        //     fontSize: 12.0,
                                        //     //color: Colors.grey,
                                        //   ),
                                        // ),
                                      ],
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
                                builder: (context) => const EventDetailPage(),
                                settings: RouteSettings(
                                  arguments: snapshot.data![index],
                                ),
                              )
                            );
                          },
                        ),
                      ),
                    ) : Container();
                  },
                );
              }
              else {
                return const CircularProgressIndicator();
              }
            }, future: dataList
          ),
        ),

        // Container(
        //   alignment: Alignment.centerLeft,
        //   padding: const EdgeInsets.only(left: 20),
        //   child: const Text("Trending Event", style: TextStyle(fontSize: 20)),
        // ),
        // Container(
        //   alignment: Alignment.centerLeft,
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: Row(
        //     children: [
        //       Expanded(
        //         child: TextFormField(
        //           onChanged: (text) {
        //               setState((){
        //                 searchString = text; 
        //               });
        //           },
        //           // controller: searchController,
        //           decoration: InputDecoration(
        //             hintText: "Search Here...",
        //             enabledBorder: OutlineInputBorder(
        //               borderSide: const BorderSide(
        //                 color: Colors.transparent,
        //               ),
        //               borderRadius: BorderRadius.circular(10),
        //             ),
        //             focusedBorder: OutlineInputBorder(
        //               borderSide: const BorderSide(
        //                 color: Colors.transparent,
        //               ),
        //               borderRadius: BorderRadius.circular(10),
        //             ),
        //             prefixIcon: const Icon(Icons.search, color: Colors.red),
        //           ),
        //         ),
        //       ),
        //       DropdownButtonHideUnderline(
        //         child: Container(
        //           height: 30,
        //           padding: const EdgeInsets.symmetric(horizontal: 10),
        //           decoration: BoxDecoration(
        //             color: Colors.grey[300],
        //             borderRadius: BorderRadius.circular(10),
        //           ),
        //           child: DropdownButton(
        //             hint: const Text("Sort by..."),
        //             icon: const Icon(Icons.arrow_drop_down),
        //             items: sortList.map((value){
        //               return DropdownMenuItem(
        //                 value: value,
        //                 child: Text(value),
        //               );
        //             }).toList(),
        //             value: values,
        //             onChanged: (value) {
        //               setState(() {
        //                 values = value as String?;
        //               });
        //             }
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // const SizedBox(height: 10),
        // Expanded(
        //   child: FutureBuilder<List<Event>>(
        //     builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
        //       if (snapshot.hasData) {
        //         return ListView.builder(
        //           itemCount: snapshot.data?.length,
        //           itemBuilder: (context, index) {
        //             var dt = DateTime.parse(snapshot.data![index].eventDate).toLocal();
        //             String dateEvent = DateFormat('MMMM dd, yyyy').format(dt);
        //             var contained = isContain(snapshot.data![index], searchString);
        //             return contained ? InkWell(
        //               // padding: const EdgeInsets.all(20.0),
        //               child: 
        //                 Container(
        //                   margin: const EdgeInsets.all(10),
        //                   height: 90,
        //                   child: Row(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       AspectRatio(
        //                         aspectRatio: 1.0,
        //                         child: Container(
        //                             decoration: BoxDecoration(
        //                               borderRadius: const BorderRadius.only(
        //                                 topLeft: Radius.circular(10),
        //                                 topRight: Radius.circular(10),
        //                                 bottomLeft: Radius.circular(10),
        //                                 bottomRight: Radius.circular(10),
        //                               ),
        //                               image: DecorationImage(
        //                                 fit: BoxFit.fill,
        //                                 image: NetworkImage(snapshot.data![index].thumbnail) // Forum Image
        //                               ),
        //                             ),
        //                         ),
        //                       ),
        //                       Expanded(
        //                         child: Padding(
        //                           padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
        //                           child: Column(
        //                             crossAxisAlignment: CrossAxisAlignment.start,
        //                             children: [
        //                               Column(
        //                                 crossAxisAlignment: CrossAxisAlignment.start,
        //                                 children: [
        //                                   // const SizedBox(height: 20),
        //                                   Text(snapshot.data![index].name,
        //                                     overflow: TextOverflow.ellipsis,
        //                                     style: const TextStyle(
        //                                       fontWeight: FontWeight.bold,
        //                                     ),
        //                                   ),
        //                                   const Padding(padding: EdgeInsets.only(bottom: 2.0)),
        //                                   Text(
        //                                     dateEvent,
        //                                     overflow: TextOverflow.ellipsis,
        //                                     style: const TextStyle(
        //                                       fontSize: 12.0,
        //                                       color: Colors.black,
        //                                     ),
        //                                   ),
        //                                   const SizedBox(height: 5),
        //                                   Text(snapshot.data![index].location,
        //                                     style: const TextStyle(
        //                                       fontSize: 12.0,
        //                                       //color: Colors.black,
        //                                     ),
        //                                   ),
        //                                 ],
        //                               ),
        //                             ],
        //                           ),
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //                 onTap: () {
        //                   Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                       builder: (context) => const EventDetailPage(),
        //                       settings: RouteSettings(
        //                         arguments: snapshot.data![index],
        //                       ),
        //                     )
        //                   );
        //                 },
        //             ) : Container();
        //           },
        //         );
        //       }
        //       else {
        //         return const CircularProgressIndicator();
        //       }
        //     }, future: dataList
        //   ),
        // )      
      ],
    );
  }

  bool isContain(Event data, String search) {
    var isContain = false;

    if (data.name.toLowerCase().contains(search.toLowerCase())) {
      isContain = true;
    }

    return isContain;
  }
}