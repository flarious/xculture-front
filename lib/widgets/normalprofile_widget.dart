import 'package:flutter/material.dart';

class NormalProfileWidget extends StatelessWidget{
  final String imagePath;
  //final bool isEdit;
 // final VoidCallback onclicked;
  
  const NormalProfileWidget({
    Key? key,
    required this.imagePath,
    //this.isEdit = false,
    //required this.onclicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    //final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children:[
          buildImage(),
          // Positioned(
          //   bottom:0,
          //   right: 4,
            //child:buildEditIcon(color), 
          // )
        ],
      ),
    );
  }

  Widget buildImage(){
    final image = NetworkImage(imagePath);
    return ClipOval(
      child: Material(
      color: Colors.transparent,
       child: Ink.image(
       image: image,
       fit: BoxFit.cover,
       width: 130,
       height: 130,
       
       //child: InkWell(onTap:onclicked),
      ),
    )
    );
  }

  // Widget buildEditIcon(Color color) => buildCircle(
  //   color: Colors.white,
  //   all:3,
  //   child: buildCircle(
  //     color: color,
  //     all:8,
  //     child:Icon(
  //       isEdit ? Icons.edit:Icons.edit,
  //       color: Colors.yellow.shade100,
  //       size:25,
  //     )
  //   ),
  // );
  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
    ClipOval(
      child:Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
}