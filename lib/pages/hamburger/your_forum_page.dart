import 'package:flutter/material.dart';

class YourForumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DefaultTabController(
     length: 2,
     child: Scaffold(
        appBar: AppBar(
          title: Text('Forum'),
          centerTitle: true,
          backgroundColor: Colors.red,
           bottom: const TabBar(
             indicatorColor: Color.fromARGB(255, 255, 255, 255),
             indicatorWeight: 4.5,
              tabs: [
                Tab(text:'Your forum',icon: Icon(Icons.comment)),
                Tab(text:'Liked',icon: Icon(Icons.favorite)),
              ],
            ),
        ),
     ),
    );
}