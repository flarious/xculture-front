import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadProfilePicWidget extends StatefulWidget{
final String imagePath;
final bool isEdit;
final VoidCallback onclicked;
  
  const UploadProfilePicWidget({
    Key? key,
     required this.imagePath,
    this.isEdit = false,
    required this.onclicked,
  }) : super(key: key);


  @override 
  _UploadProfilePicState createState() =>_UploadProfilePicState();
  
}


class _UploadProfilePicState extends State<UploadProfilePicWidget>{
  File? pickedImage;
  late String imagePath;
  @override
  void initState(){
    super.initState(); 
    imagePath=widget.imagePath;
  }
  
void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Color.fromARGB(255, 255, 255, 255),
            height: 130,
           // width: 110,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0,horizontal: 40 ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                      },
                    
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey.shade200,
                      //elevation: 3,
                    ),
                    icon: const Icon(
                      Icons.camera_alt_outlined, 
                      color: Colors.black54, 
                      size: 30),
                    label: const Text(
                      "Open Camera",
                      style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey.shade200,
                    ),
                    icon: const Icon(
                      Icons.image_outlined, 
                      color: Colors.black54, 
                      size: 30),
                    label: const Text(
                      "Select from gallary",
                      style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }
    
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
      child: IconButton(
        onPressed: imagePickerOption,
        icon: const Icon(
        
        Icons.edit,
        color: Color.fromARGB(255, 255, 255, 255),
        size: 50,
      ),
    ),
       //child: InkWell(onTap:onclicked{}),
      ),
    )
    );
  }

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
  