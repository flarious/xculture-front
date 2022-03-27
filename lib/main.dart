import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:xculturetestapi/pages/event/event_edit.dart';
import 'package:xculturetestapi/pages/forum/forum_home.dart';
import 'package:xculturetestapi/pages/hamburger/change_pass.dart';
import 'package:xculturetestapi/pages/hamburger/setting.dart';
import 'package:xculturetestapi/pages/hamburger/edit_profile_page.dart';
import 'package:xculturetestapi/pages/hamburger/profile_page.dart';
//import 'package:xculturetestapi/pages/Navbar.dart';
//import 'package:xculturetestapi/routes.dart';
//import 'package:xculturetestapi/pages/forum/forum_home.dart';
import 'package:xculturetestapi/pages/splash/splash_screen.dart';
import 'package:xculturetestapi/firebase/firebase_options.dart';
//import 'package:xculturetestapi/widgets/uploadprofile_widget.dart';

// import 'package:xculturetestapi/pages/comment_edit.dart';
// import 'package:xculturetestapi/pages/forum_all.dart';
// import 'package:xculturetestapi/pages/forum_edit.dart';
// import 'package:xculturetestapi/pages/forum_detail.dart';
// import 'package:xculturetestapi/pages/forum_new.dart';
// import 'package:xculturetestapi/pages/reply_edit.dart';

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
     //home: const ForumPage(),
  home: ProfilePage(),
//home: ChangePasswordPage(),
//home: SettingsPage(),
//  home: EditProfilePage(),
  // home:UploadProfileImageWidget(),
     //home: const EditEventPage(),
      //home: SplashScreen(),
      /*
      initialRoute: 'navbar', // Set first page
      routes: {
        //'navbar': (context) => const NavBar(),
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









