import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xculturetestapi/arguments.dart';
import 'package:http/http.dart' as http;
import 'package:xculturetestapi/helper/auth.dart';
import 'package:xculturetestapi/pages/community/private/seeanswer_page.dart';
import '../../data.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({ Key? key }) : super(key: key);

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> with TickerProviderStateMixin{

  Future<Community>? commuDetail;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    final commu = ModalRoute.of(context)!.settings.arguments as Community;
    commuDetail = getCommu(commu.id);

    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return false;
          },
          child: SingleChildScrollView(
            child: FutureBuilder<Community>(
              future: commuDetail,
              builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [           
                      
                      //Members text
                      Container(
                        margin: const EdgeInsets.only(right: 0, left: 0),
                        height: 190,
                        color: Colors.red,
                        child: const Center(
                          child: Text("Members", 
                            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
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
                              //Back
                              Navigator.pop(context);
                            },
                          ),
                        ),   
                      ),
                        
                      //White box(content)
                      Container(
                        margin: const EdgeInsets.only(top: 170, left: 0, right: 0, bottom: 0),
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            child: Column(
                              children: [
                                //Member list
                                SizedBox(
                                  height: 490,
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      //In group
                                      ListView.builder(
                                        itemCount: snapshot.data!.members.length,
                                        shrinkWrap: true,
                                        itemBuilder: (BuildContext context, index) {
                                          return snapshot.data!.members[index].type == "member" ? ListTile(
                                            leading: CircleAvatar(
                                              radius: 20,
                                              backgroundImage: snapshot.data!.members[index].member.profilePic == "" ? const AssetImage("assets/images/User_icon.jpg") : NetworkImage(snapshot.data!.members[index].member.profilePic) as ImageProvider,
                                            ),
                                            title: Text(snapshot.data!.members[index].member.name),
                                            //subtitle: Text("Score : 99"),
                                            // ignore: deprecated_member_use
                                            // trailing: FlatButton(
                                            //   onPressed: () {
                                            //     if (AuthHelper.checkAuth() && snapshot.data!.owner.id == AuthHelper.auth.currentUser!.uid) {
                                            //       showDialog(
                                            //         context: context,
                                            //         builder: (context) => AlertDialog(
                                            //           title: Text("Remove"),
                                            //           content: Text("Do you want to remove this member?"),
                                            //           actions: [
                                            //             FlatButton(
                                            //               onPressed: (){
                                            //                 Navigator.pop(context);
                                            //               }, 
                                            //               child: Text("No")
                                            //             ),
                                            //             FlatButton(
                                            //               onPressed: () {
                                            //                 //Remove
                                            //               }, 
                                            //               child: Text("Yes", style: TextStyle(color: Colors.red)),
                                            //             ),
                                            //           ],
                                            //           elevation: 24.0,
                                            //         ),
                                            //       );
                                            //     }
                                            //     else {
                                            //       Fluttertoast.showToast(msg: "Only the owner can remove members from community");
                                            //     }
                                                
                                            //   }, 
                                            //   child: const Text("Remove", style: TextStyle(color: Colors.white)),
                                            //   color: Colors.red,
                                            //   shape: RoundedRectangleBorder(
                                            //     borderRadius: BorderRadius.circular(20.0),
                                            //   ),
                                            // ),
                                          ) : 
                                          Container();
                                        }
                                      ),
                        
                                      //Pending
                                      ListView.builder(
                                        itemCount: snapshot.data!.members.length,
                                        shrinkWrap: true,
                                        itemBuilder: (BuildContext context, index) {
                                          return snapshot.data!.members[index].type == "pending" ? ListTile(
                                            leading: CircleAvatar(
                                              radius: 20,
                                              backgroundImage: snapshot.data!.members[index].member.profilePic == "" ? const AssetImage("assets/images/User_icon.jpg") : NetworkImage(snapshot.data!.members[index].member.profilePic) as ImageProvider,
                                            ),
                                            title: Text(snapshot.data!.members[index].member.name),
                                            //subtitle: Text("Score : 99"),
                                            // ignore: deprecated_member_use
                                            trailing: FlatButton(
                                              onPressed: () async {
                                                await Navigator.push(
                                                  context, 
                                                  MaterialPageRoute(
                                                    builder: (context) => const FilterPage(),
                                                    settings: RouteSettings(
                                                      arguments: FilterArguments(commu: snapshot.data!, member: index)
                                                    )
                                                  )
                                                );
                                                setState(() {
                                                  commuDetail = getCommu(snapshot.data!.id);
                                                });
                                              }, 
                                              child: const Text("See answer", style: TextStyle(color: Colors.white)),
                                              color: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20.0),
                                              ),
                                            ),
                                          ) : 
                                          Container();
                                        }
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                        
                      //Tabbar
                      Container(
                        height: 45,
                        width: 260,
                        margin: const EdgeInsets.only(top: 150, left: 75),
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
                            _individualTab("In group"),
                            const Tab(text: "Pending")
                          ],
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

  Future<Community> getCommu(commuID) async {
    final response =
        await http.get(Uri.parse('https://xculture-server.herokuapp.com/communities/$commuID'));

    if (response.statusCode == 200) {
      return Community.fromJson(jsonDecode(response.body));
    } else {
      Fluttertoast.showToast(msg: ServerResponse.fromJson(jsonDecode(response.body)).message);
      Navigator.pop(context);
      return Community(id: "", name: "", shortdesc: "", desc: "", thumbnail: "", memberAmount: 0, createDate: DateTime.now().toString(), updateDate: DateTime.now().toString(), 
      owner: User(id: "", name: "", profilePic: "", bio: "", email: "", lastBanned: "", userType: "", bannedAmount: 0, tags: []), members: [], type: "", questions: []);
    }
  }
}

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