import 'package:flutter/material.dart';
import 'package:xculturetestapi/pages/search/search_page.dart';
import 'package:xculturetestapi/pages/event/event_page.dart';
import 'package:xculturetestapi/pages/forum/forum_home.dart';
import 'package:xculturetestapi/pages/community/commu_page.dart';


class Navbar extends StatefulWidget {
  const Navbar({ Key? key, required this.currentIndex }) : super(key: key);

  final int currentIndex;

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {


  late int _index;

  List pages = [
    const EventPage(),
    const SearchPage(),
    const ForumPage(),
    const CommuPage(),
  ];
  
  @override
  void initState() {
    super.initState();
    _index = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    
    return BottomNavigationBar(
      items: const [
          BottomNavigationBarItem(label: "Event", icon: Icon(Icons.room)),
          BottomNavigationBarItem(label: "Search", icon: Icon(Icons.search)),
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: "Community", icon: Icon(Icons.groups)),
          BottomNavigationBarItem(label: "Hamburger", icon: Icon(Icons.density_medium_rounded)),
      ],
      currentIndex: _index,
      onTap: (index) {
        if ( index == 4 ) {
          Scaffold.of(context).openEndDrawer();
        } else {
          _index = index;
          Navigator.push(context, MaterialPageRoute(builder: (context) => pages[_index]));
        } 
      },
        
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Color.fromARGB(255, 255, 183, 0),
      unselectedItemColor: Color.fromARGB(255, 129, 129, 129).withOpacity(0.4),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 0,
    ); 
  }
}

