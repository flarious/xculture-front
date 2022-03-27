import 'package:flutter/material.dart';

class YourEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DefaultTabController(
     length: 2,
     child: Scaffold(
        appBar: AppBar(
          title: Text('Event'),
          centerTitle: true,
          backgroundColor: Colors.red,
           bottom: const TabBar(
              tabs: [
                Tab(text:'ss',icon: Icon(Icons.move_down)),
                Tab(text:'ss',icon: Icon(Icons.directions_transit)),
                //Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
        ),
     ),
    );
}