import 'package:flutter/material.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({ Key? key }) : super(key: key);

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> with TickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [           
              
              //Members text
              Container(
                margin: const EdgeInsets.only(right: 0, left: 0),
                height: 190,
                color: Color.fromRGBO(220, 71, 47, 1),
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
                                itemCount: 5,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, index) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: ExactAssetImage("assets/images/tomoe.jpg"),
                                    ),
                                    title: Text("John Doe"),
                                    //subtitle: Text("Score : 99"),
                                    // ignore: deprecated_member_use
                                    trailing: FlatButton(
                                      onPressed: (){
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("Remove"),
                                            content: Text("Do you want to remove this member?"),
                                            actions: [
                                              FlatButton(
                                                onPressed: (){}, 
                                                child: Text("No")
                                              ),
                                              FlatButton(
                                                onPressed: () {
                                                  //Remove
                                                }, 
                                                child: Text("Yes", style: TextStyle(color: Colors.red)),
                                              ),
                                            ],
                                            elevation: 24.0,
                                          ),
                                        );
                                      }, 
                                      child: const Text("Remove", style: TextStyle(color: Colors.white)),
                                      color: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  );
                                }
                              ),

                              //Pending
                              ListView.builder(
                                itemCount: 10,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, index) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: ExactAssetImage("assets/images/tomoe.jpg"),
                                    ),
                                    title: Text("John Doe"),
                                    // ignore: deprecated_member_use
                                    trailing: FlatButton(
                                      onPressed: (){}, 
                                      child: const Text("See answer", style: TextStyle(color: Colors.white)),
                                      color: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0)
                                      ),
                                    ),
                                  );
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
          ),
        ),
      ),
    );
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