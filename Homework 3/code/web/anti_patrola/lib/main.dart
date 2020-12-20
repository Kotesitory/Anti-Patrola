import 'package:anti_patrola/routes/routes.dart';
import 'package:anti_patrola/startup.dart';
import 'package:flutter/material.dart';

void main() {
  // TODO: Remove this for the mobile app, and enable LoadingScreen as an initial route in the build method
  Startup.runEssentialPass().then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anti Patrola',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Ubuntu',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Routes.LoginScreen,
      routes: {
        Routes.LoadingScreen: (context) => ScreenFactory.createLoadingScreen(),
        Routes.LoginScreen: (context) => ScreenFactory.createLoginScreen(),
        Routes.HomeScreen: (context) => ScreenFactory.createHomeScreen(),
      },
    );
  }
}
