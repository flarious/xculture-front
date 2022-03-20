import 'package:intl/intl.dart';
import '../../helper/auth.dart';
import 'package:flutter/material.dart';
import 'package:xculturetestapi/data.dart';
import 'package:xculturetestapi/navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/pages/community/commupost_page.dart';
import 'package:xculturetestapi/pages/community/commudetail_page.dart';




class CommuAllPage extends StatefulWidget {
  const CommuAllPage({Key? key}) : super(key: key);

  @override
  _CommuAllPageState createState() => _CommuAllPageState();
}

class _CommuAllPageState extends State<CommuAllPage> {

  String? value;
  List sortList = [
    "Newest",
    "Oldest",
    "Most Viewed",
    "Most Favorited"
  ];

  String searchString = "";
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final commuList =
        ModalRoute.of(context)!.settings.arguments as Future<List<Community>>;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Community",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
        )
      ),
      body: showAllCommu(commuList),
      // bottomNavigationBar: BottomNavigationBar(const NavBar()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (AuthHelper.checkAuth()) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CommuPostPage(),
              )
            );
          }
          else {
            Fluttertoast.showToast(msg: "You are not signed in");
          }
        },
        child: const Icon(Icons.post_add)
      ),
      bottomNavigationBar: Navbar.navbar(context, 3),
    );
  }

  Widget showAllCommu(Future<List<Community>> dataList) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: const Text("Trending Community", style: TextStyle(fontSize: 20)),
        ),
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
                    prefixIcon: const Icon(Icons.search, color: Colors.red),
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
                    value: value,
                    onChanged: (value) {
                      setState(() {
                        this.value = value as String?;
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
          child: FutureBuilder<List<Community>>(
            builder: (BuildContext context, AsyncSnapshot<List<Community>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    var contained = isContain(snapshot.data![index], searchString);
                    return contained ? InkWell(
                      // padding: const EdgeInsets.all(20.0),
                      child: 
                        Container(
                          margin: const EdgeInsets.all(10),
                          height: 90,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 1.0,
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(snapshot.data![index].thumbnail) // Commu Image
                                      ),
                                    ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // const SizedBox(height: 20),
                                          Text(snapshot.data![index].name,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                                          Text(
                                            snapshot.data![index].shortdesc,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "Members : ${snapshot.data![index].memberAmount.toString()}",
                                            style: const TextStyle(fontSize: 15), // Community Subtitle
                                          ),
                                        ],
                                      ),
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
                              builder: (context) => const CommuDetailPage(),
                              settings: RouteSettings(
                                arguments: snapshot.data![index],
                              ),
                            )
                          );
                        },
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

  bool isContain(Community data, String search) {
    var isContain = false;

    if (data.name.toLowerCase().contains(search.toLowerCase())) {
      isContain = true;
    }

    return isContain;
  }
}
