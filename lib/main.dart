import 'package:flutter/material.dart';
// import 'pages/event/eventpost_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:xculturetestapi/pages/community/commudetail_page.dart';
import 'package:xculturetestapi/pages/community/private/question_page.dart';
import 'package:xculturetestapi/pages/sign_in/sign_in_screen.dart';
// import 'package:xculturetestapi/pages/community/commu_page.dart';
// import 'package:xculturetestapi/pages/community/commudetail_page.dart';
// import 'package:xculturetestapi/pages/community/commuedit_page.dart';
// import 'package:xculturetestapi/pages/community/chatroom/chatroom_page.dart';
// import 'package:xculturetestapi/pages/community/chatroom/room_page.dart';
// import 'package:xculturetestapi/pages/community/chatroom/roomedit_page.dart';
// import 'package:xculturetestapi/pages/community/commupost_page.dart';
// import 'package:xculturetestapi/pages/community/member_page.dart';
// import 'package:xculturetestapi/pages/community/private/question_page.dart';
// import 'package:xculturetestapi/pages/event/event_edit.dart';
// import 'package:xculturetestapi/pages/event/eventpost_page.dart';
// import 'package:xculturetestapi/pages/forum/forum_home.dart';
// import 'package:xculturetestapi/pages/report/report_page.dart';
// import 'package:xculturetestapi/pages/forum/forum_home.dart';
// import 'package:xculturetestapi/pages/event/event_page.dart';
// import 'package:xculturetestapi/pages/report/report_page.dart';
import 'package:xculturetestapi/pages/splash/splash_screen.dart';
import 'package:xculturetestapi/widgets/guesthamburger_widget.dart';

import 'widgets/hamburger_widget.dart';
// import 'package:xculturetestapi/pages/event/eventdetail_page.dart';
//import 'package:xculturetestapi/routes.dart';
//import 'package:xculturetestapi/pages/Navbar.dart';
// import 'package:xculturetestapi/pages/forum_all.dart';
// import 'package:xculturetestapi/pages/forum_new.dart';
// import 'package:xculturetestapi/pages/reply_edit.dart';
// import 'package:xculturetestapi/pages/forum_edit.dart';
// import 'package:xculturetestapi/pages/comment_edit.dart';
// import 'package:xculturetestapi/pages/forum_detail.dart';
import 'package:xculturetestapi/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: "Poppins",
      ),
      // initialRoute: SplashScreen.routeName,
      // routes: routes,
      // home: MemberPage(),
      // home: const ForumPage(),
      //home: SplashScreen(),
      home: SplashScreen(),
      //home: GuestHamburger(),
      // home: ReportPage(),
      /*
      initialRoute: 'navbar', // Set first page
      routes: {
        // 'navbar': (context) => const NavBar(),
        'homePage': (context) => const ForumPage(),
        // 'forumAllPage': (context) => const ForumAllPage(),
        // 'forumDetailPage': (context) => const ForumDetailPage(),
        // 'newForumPage': (context) => const NewForumPage(),
        // 'editForumPage': (context) => const EditForumPage(), 
        // 'editCommentPage': (context) => const EditCommentPage(),
        // 'editReplyPage': (context) => const EditReplyPage(), // Change page by using only page's name
      },
      */
    );
  }
}





