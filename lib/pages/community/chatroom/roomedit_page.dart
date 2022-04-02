import 'package:flutter/material.dart';

class EditRoomPage extends StatefulWidget {
  const EditRoomPage({ Key? key }) : super(key: key);

  @override
  State<EditRoomPage> createState() => _EditRoomPageState();
}

class _EditRoomPageState extends State<EditRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [

            //Edit Room text
            Container(
              margin: const EdgeInsets.only(right: 0, left: 0),
              height: 180,
              color: Color.fromRGBO(220, 71, 47, 1),
              child: Center(
                child: Text("Edit Room", 
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
                child: Form(
                  //key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      
                        TextFormField(
                          //controller: _title,
                          decoration: const InputDecoration(
                            labelText: "Room name",
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter forum's title";
                            }
                            else {
                              return null;
                            }
                          },
                        ),

                        const SizedBox(height: 30),

                        ElevatedButton(
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Create"),
                                content: Text("Do you want to create this room?"),
                                actions: [
                                  FlatButton(
                                    onPressed: (){}, 
                                    child: Text("No")
                                  ),
                                  FlatButton(
                                    onPressed: (){}, 
                                    child: Text("Yes", style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                                elevation: 24.0,
                              ),
                            );
                          }, 
                          child: const SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Center(
                              child: Text("Create Room")
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
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