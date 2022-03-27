import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DefaultTabController(
     length: 2,
     child: Scaffold(
        appBar: AppBar(
          title: Text('Community'),
          centerTitle: true,
          backgroundColor: Colors.red,
           bottom: const TabBar(
              tabs: [
                Tab(text:'ss',icon: Icon(Icons.comment)),
                Tab(text:'ss',icon: Icon(Icons.directions_transit)),
                //Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
        ),
     ),
    );
}

// void main() {
//   runApp(const CommunityPage());
// }

// class CommunityPage extends StatelessWidget {
//   const CommunityPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.red,
//             bottom: const TabBar(
//               tabs: [
//                 Tab(text:'ss',icon: Icon(Icons.comment)),
//                 Tab(text:'ss',icon: Icon(Icons.directions_transit)),
//                 //Tab(icon: Icon(Icons.directions_bike)),
//               ],
//             ),
//             title: const Text('Community'),
//             centerTitle: true,
//           ),
//           body: const TabBarView(
//             children: [
//               Icon(Icons.directions_car),
//               Icon(Icons.directions_transit),
//               //Icon(Icons.directions_bike),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }