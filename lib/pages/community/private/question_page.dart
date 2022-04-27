import 'package:flutter/material.dart';
import 'package:xculturetestapi/constants.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({ Key? key }) : super(key: key);

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [

              //Question text
              Container(
                margin: const EdgeInsets.only(right: 0, left: 0),
                height: 180,
                color: Color.fromRGBO(220, 71, 47, 1),
                child: const Center(
                  child: Text("Question", 
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

              //White box(content)
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
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [

                          //Question
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),

                          //Answer
                          TextFormField(
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: "Answer there",
                              hintStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter event's description";
                              }
                              else {
                                return null;
                              }
                            },
                          ),

                          const SizedBox(height: 40),

                          //Question
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),

                          //Answer
                          TextFormField(
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: "Answer there",
                              hintStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter event's description";
                              }
                              else {
                                return null;
                              }
                            },
                          ),

                          const SizedBox(height: 40),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(350, 50),
                            ),
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Answer"),
                                  content: Text("Are you sure to send this answer?"),
                                  actions: [
                                    FlatButton(
                                      onPressed: (){}, 
                                      child: Text("No")
                                    ),
                                    FlatButton(
                                      onPressed: (){
                                        //yes
                                      }, 
                                      child: Text("Yes", style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                  elevation: 24.0,
                                ),
                              );
                            }, 
                            child: const Text("Send Answer")
                          ),
                          
                          const SizedBox(height: 30),
                        ]
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}