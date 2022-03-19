import 'package:flutter/widgets.dart';
import 'package:xculturetestapi/pages/forum/forum_home.dart';
import 'package:xculturetestapi/pages/profile/profile_screen.dart';
import 'package:xculturetestapi/pages/sign_up/sign_up_screen.dart';
import 'package:xculturetestapi/pages/sign_in/sign_in_screen.dart';
import 'package:xculturetestapi/pages/splash/splash_screen.dart';
// import 'package:shop_app/screens/forgot_password/forgot_password_screen.dart';
// import 'package:shop_app/screens/home/home_screen.dart';
// import 'package:shop_app/screens/profile/profile_screen.dart';
// import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
// import 'package:shop_app/screens/splash/splash_screen.dart';

// import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  //ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  //HomeScreen.routeName: (context) => HomeScreen(),
  //HomePage.routeName: (context) => HomePage(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
};
