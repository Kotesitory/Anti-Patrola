import 'package:anti_patrola/ui/screens/home_screen.dart';
import 'package:anti_patrola/ui/screens/loading_screen.dart';
import 'package:flutter/cupertino.dart';

class Routes {
  static const String HomeScreen = "homeScreen";
  static const String LoadingScreen = "loadingScreen";
}

class ScreenFactory{
  static Widget createLoadingScreen(){
    return LoadingScreen();
  }

  static Widget createHomeScreen(){
    return HomeScreen();
  }
}