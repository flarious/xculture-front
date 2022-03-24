import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({ Key? key }) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  List<String> arr = [ 
    "Nudity",
    "Violence",
    "Harassment",
    "Spam",
    "Hate Speech",
    "Terrorism",
    "Suicide or Self-Injury",
    "Unauthorized Sales",
    "Others"
  ];

  List<String> arrSelected = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepOrange,
        body: SingleChildScrollView(
          child: Stack(
            children: [

              //Report text
              Container(
                margin: const EdgeInsets.only(right: 0, left: 0),
                height: 180,
                color: const Color.fromRGBO(220, 71, 47, 1),
                child: const Center(
                  child: Text("Report", 
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //Choose your report reason
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Text("Choose your report reason",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23, color: Colors.red)
                        ),
                      ),

                      //FilterChip
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: arr.map((e) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: FilterChip(
                              label: Text(e),
                              selected: arrSelected.contains(e),
                              selectedColor: const Color.fromRGBO(220, 71, 47, 1),
                              onSelected: (bool selected){
                                setState(() {
                                  if (selected) {
                                    arrSelected.add(e);
                                  } else {
                                    arrSelected.removeWhere((String name) {
                                      return name == e;
                                    });
                                  }
                                });
                              },
                            ),
                          )).toList(),
                        ),
                      ),

                      //Tell us more about this
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text("Please tell us more about this",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      
                      //Textformfield
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            hintText: "Text here...",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      //Button
                      ElevatedButton(
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Report"),
                              content: const Text("Are you sure to report?"),
                              actions: [
                                // ignore: deprecated_member_use
                                FlatButton(
                                  onPressed: (){
                                    //Back
                                  }, 
                                  child: const Text("No")
                                ),
                                // ignore: deprecated_member_use
                                FlatButton(
                                  onPressed: (){
                                    //Join
                                  }, 
                                  child: const Text("Yes", 
                                    style: TextStyle(color: Colors.red),
                                  ),
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
                            child: Text("Report"),
                          ),
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
      ),
    );
  }
}