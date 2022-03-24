// import 'package:flutter/material.dart';

// class CardListWidget extends StatelessWidget {
//   @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(7.0),
  //     child: Card(
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 14.0),
  //         child: Row(
  //           children: <Widget>[
  //             IconButton(
  //               onPressed: (){},
  //               icon: Icon(Icons.article_outlined),
  //               iconSize: 40,
  //               color: Colors.grey.shade600,
  //               ),
  //             SizedBox(width: 26),
  //             //buildCardlistItem(text: 'text', icon: Icons.book),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize:MainAxisSize.min ,
  //               children: <Widget>[
  //                 Text("Forum",style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 22
  //                  ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
// }
import 'package:flutter/material.dart';

class CardListWidget extends StatelessWidget {
  const CardListWidget({
     Key? key,
  }) : super(key: key);

  @override
    Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 14.0),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.article_outlined),
                iconSize: 40,
                color: Colors.red.shade600,
                ),
              SizedBox(width: 20),
              //buildCardlistItem(text: 'text', icon: Icons.book),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:MainAxisSize.min ,
                children: <Widget>[
                  Text("Forum",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22
                   ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Padding(
  //    // padding: const EdgeInsets.all(7.0),
  //     padding: EdgeInsets.symmetric(horizontal: 18.0),
  //     child: Card(
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(
  //           horizontal: 15.0,
  //           vertical: 14.0,
  //         ),
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: <Widget>[
  //             IconButton(
  //               onPressed: () {},
  //               icon: Icon(
  //                 Icons.article,
  //                 size: 40.0,
  //                 color: Colors.red,
  //               ),
  //             ),
  //             SizedBox(width: 25.0),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Text(
  //                   "Forum",
  //                   style: TextStyle(
  //                     fontSize: 22.0,
  //                     fontWeight: FontWeight.bold
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
  // Widget buildCardlistItem({
  //   required String text,
  //   required IconData icon,
  //   VoidCallback? onClicked,
  // }) {
  //   final color = Colors.red;
  //   final hoverColor = Colors.red;
  
  //   return ListTile(
  //     leading: Icon(icon, color: color,size: 35),
  //     title: Text(text, style: TextStyle(fontSize:22, color: Colors.red)),
  //     hoverColor: hoverColor,
  //     onTap: onClicked,
  //   );
