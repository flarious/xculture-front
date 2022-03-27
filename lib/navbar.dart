import 'package:flutter/material.dart';
import 'package:xculturetestapi/pages/menu/menu_page.dart';
import 'package:xculturetestapi/pages/profile/profile_screen.dart';
import 'package:xculturetestapi/pages/search/search_page.dart';
import 'package:xculturetestapi/pages/event/event_page.dart';
import 'package:xculturetestapi/pages/forum/forum_home.dart';
import 'package:xculturetestapi/pages/community/commu_page.dart';
import 'package:xculturetestapi/pages/hamburger/profile_page.dart';

class Navbar {
  static List pages = [
    const EventPage(),
    const SearchPage(),
    const ForumPage(),
    const CommuPage(),
    ProfilePage()
  ];

  static Widget navbar(context, int pageIndex) {
    int currentIndex = pageIndex; 

    return BottomNavigationBar(
      items: const [
          BottomNavigationBarItem(label: "Event", icon: Icon(Icons.room)),
          BottomNavigationBarItem(label: "Search", icon: Icon(Icons.search)),
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: "Community", icon: Icon(Icons.groups)),
          BottomNavigationBarItem(label: "Profile", icon: Icon(Icons.person)),
      ],
      onTap: (index) {
        currentIndex = index;
        Navigator.push(context, MaterialPageRoute(builder: (context) => pages[index]));
      },
      currentIndex: currentIndex,
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