import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:xculturetestapi/data.dart';
import 'package:xculturetestapi/navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/pages/forum/forum_new.dart';
import 'package:xculturetestapi/pages/forum/forum_detail.dart';


import '../../helper/auth.dart';
import '../../widgets/hamburger_widget.dart';



class ForumAllPage extends StatefulWidget {
  // const ForumAllPage({Key? key}) : super(key: key);

  String value;
  ForumAllPage({Key? key, required this.value}) : super(key: key);

  @override
  _ForumAllPageState createState() => _ForumAllPageState(value);
}

class _ForumAllPageState extends State<ForumAllPage> {

  String? values;
  String searchString;
  _ForumAllPageState(this.searchString);

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
    final forumList =
        ModalRoute.of(context)!.settings.arguments as Future<List<Forum>>;

    return Scaffold(
      backgroundColor: Colors.white,
      body: showAllForum(forumList),
      // bottomNavigationBar: BottomNavigationBar(const NavBar()),
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
      endDrawer: const NavigationDrawerWidget(),
      bottomNavigationBar: const Navbar(currentIndex: 2),
    );
  }

  Widget showAllForum(Future<List<Forum>> dataList) {
    return Column(
      children: <Widget>[

        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
          child: const Text("Forum", 
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
          child: FutureBuilder<List<Forum>>(
            builder: (BuildContext context, AsyncSnapshot<List<Forum>> snapshot) {
              if (snapshot.hasData) {
                isAscending ? snapshot.data!.sort((b, a) => (b.title).compareTo((a.title))) : "";
                isDescending ? snapshot.data!.sort((b, a) => (a.title).compareTo((b.title))) : "";
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    var dt = DateTime.parse(snapshot.data![index].updateDate).toLocal();
                    String formattedDate = DateFormat('dd/MM/yyyy – HH:mm a').format(dt);
                    var contained = isContain(snapshot.data![index], searchString);
                    return contained ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: InkWell(
                          // padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            height: 150,
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
                                                
                                        Text(snapshot.data![index].title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                                
                                        Text(snapshot.data![index].subtitle,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black,
                                          ),
                                        ),
                          
                                        SizedBox(
                                          height: 30,
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: snapshot.data![index].tags.map((tag) => Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Chip(
                                                  label: Text(tag.name),
                                                ),
                                              )).toList(),
                                            ),
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
                                builder: (context) => const ForumDetailPage(),
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
        )      
      ],
    );
  }

  bool isContain(Forum data, String search) {
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
