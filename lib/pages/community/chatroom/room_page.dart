import 'dart:ui';

import 'package:flutter/material.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({ Key? key }) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {

  bool isPost = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [

            //Post Forum text
            Container(
              margin: const EdgeInsets.only(right: 0, left: 0),
              height: 180,
              color: Color.fromRGBO(220, 71, 47, 1),
              child: Center(
                child: Text("Rooms", 
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
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

            // Iconbutton menu
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 40, right: 20),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text("Edit"),
                      onTap: (){
                        
                      },
                    ),
                    PopupMenuItem(
                      child: const Text("Delete"),
                      onTap: (){
                        //delete
                      },
                    ),
                    PopupMenuItem(
                      child: const Text("Report"),
                      onTap: (){
                        //report
                      },
                    ),
                    PopupMenuItem(
                      child: const Text("Member"),
                      onTap: (){
                        //report
                      },
                    ),
                  ],
                  child: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 30,
                  ), 
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 150, left: 0, right: 0, bottom: 0),
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
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    
                      InkWell(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              height: 70,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.lightBlue.withOpacity(0.2),
                                  Colors.lightBlue.withOpacity(0.05),
                                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 30),
                                  Text("# ",
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  Text("Lorem Ipsum",
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                    ),
                                  ),
                                ]
                              ),
                            ),
                          ),
                        ),
                        onTap: (){},
                      ),

                      const SizedBox(height: 20),

                      Visibility(
                        visible: isPost,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(left: 30),
                                        hintText: "Enter room name",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.white,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isPost = !isPost;
                                    });
                                  }, 
                                  icon: Icon(Icons.close),
                                  color: Colors.red,
                                  splashRadius: 20,
                                ),
                              ),
                              Material(
                                color: Colors.white,
                                child: IconButton(
                                  onPressed: () {}, 
                                  icon: Icon(Icons.done),
                                  color: Colors.green,
                                  splashRadius: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      InkWell(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(220, 71, 47, 1),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Icon(
                                Icons.add_circle,
                                color: Colors.white,
                                size: 37,
                              ),
                            ),
                          ),
                        ),
                        onTap: (){
                          setState(() {
                            isPost = !isPost;
                          });
                        },
                      ),

                      // const SizedBox(height: 20),

                      // ElevatedButton(
                      //   onPressed: (){
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) => AlertDialog(
                      //         title: Text("Post"),
                      //         content: Text("Do you want to post this forum?"),
                      //         actions: [
                      //           FlatButton(
                      //             onPressed: (){}, 
                      //             child: Text("No")
                      //           ),
                      //           FlatButton(
                      //             onPressed: () async {
                      //               // if (_formKey.currentState!.validate()) {
                      //               //   var success =  await sendForumDetail(_title.text, _subtitle.text, _thumbnail.text, _content.text, incognito, arr);
                      //               //   if(success) {
                      //               //     Fluttertoast.showToast(msg: "Your post has been created.");
                      //               //     Navigator.pop(context);
                      //               //   }
                      //               // }
                      //             }, 
                      //             child: Text("Yes", style: TextStyle(color: Colors.red)),
                      //           ),
                      //         ],
                      //         elevation: 24.0,
                      //       ),
                      //     );
                      //   }, 
                      //   child: const SizedBox(
                      //     width: double.infinity,
                      //     height: 50,
                      //     child: Center(
                      //       child: Text("Post Now")
                      //     ),
                      //   ),
                      // ),

                      // const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}