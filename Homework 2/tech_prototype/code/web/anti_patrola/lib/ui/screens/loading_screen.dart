import 'package:anti_patrola/routes/routes.dart';
import 'package:anti_patrola/startup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  void _initAsync() async {
    await Startup.runEssentialPass();
    Navigator.pushReplacementNamed(context, Routes.HomeScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Text('Loading Screen'),
      ),
    );
  }
}