import 'package:anti_patrola/routes/routes.dart';
import 'package:anti_patrola/startup.dart';
//import 'package:atlas/atlas.dart';
import 'package:flutter/material.dart';
//import 'package:google_atlas/google_atlas.dart';

void main() {
  //AtlasProvider.instance = GoogleAtlas();
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
      initialRoute: Routes.HomeScreen,
      routes: {
        Routes.LoadingScreen: (context) => ScreenFactory.createLoadingScreen(),
        Routes.HomeScreen: (context) => ScreenFactory.createHomeScreen(),
      },
    );
  }
}
