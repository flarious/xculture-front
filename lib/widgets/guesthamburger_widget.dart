import 'package:flutter/material.dart';

class GuestHamburger extends StatefulWidget {
  const GuestHamburger({ Key? key }) : super(key: key);

  @override
  State<GuestHamburger> createState() => _GuestHamburgerState();
}

class _GuestHamburgerState extends State<GuestHamburger> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: const Color.fromRGBO(0, 0, 0, 0),
          child: ListView(
            children: <Widget>[
              // buildHeader(
              //   urlImage: snapshot.data!.profilePic,
              //   name: snapshot.data!.name,
              //   email: snapshot.data!.email!,
              //   onClicked: () => Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => UserPage(
              //       name: snapshot.data!.name,
              //       urlImage: snapshot.data!.profilePic,
              //     ),
              //   )),
              // ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                // color: Colors.amber,
                // padding: const EdgeInsets.symmetric(vertical: 40),
                child: Row(
                  children: const [
                    SizedBox(width: 25),
                    CircleAvatar(radius: 30),
                    SizedBox(width: 25),
                    Text(
                      "Guest",
                      style: TextStyle(fontSize: 25, color: Colors.red),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 15, thickness: 2),

                    const SizedBox(height: 24),

                    buildMenuItem(
                      text: 'Sign in',
                      icon: Icons.login,
                      onClicked: () => "",
                    ),

                    const SizedBox(height: 10),

                    buildMenuItem(
                      text: 'Sign up',
                      icon: Icons.app_registration,
                      onClicked: () => "",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}

Widget buildMenuItem({
  required String text,
  required IconData icon,
  VoidCallback? onClicked,
}) {
  final color = Colors.red;
  final hoverColor = Colors.red;
  
  return ListTile(
    leading: Icon(icon, color: color,size: 35),
    title: Text(text, style: const TextStyle(fontSize:22, color: Colors.red)),
    hoverColor: hoverColor,
    onTap: onClicked,
  );
}