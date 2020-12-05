import 'package:anti_patrola/logic/services/auth_service.dart';
import 'package:anti_patrola/logic/services/patrol_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(text),
            FlatButton(
              child: Text("Google Login"),
              onPressed: () => GetIt.instance<AuthService>().signInWithGoogle(),
            ),
            FlatButton(
              child: Text("Get Patrols"),
              onPressed: () => GetIt.instance<PatrolService>().getPatrols(),
            ),
            FlatButton(
              child: Text("Report Patrol"),
              onPressed: () => GetIt.instance<PatrolService>().reportNewPatrol(1.0, 0.0),
            ),
            FlatButton(
              child: Text("Confirm Patrol"),
              onPressed: () => GetIt.instance<PatrolService>().confirmPatrol("5fc2f392cb24960c50c19703", 1.0, 0.0, true),
            ),
            FlatButton(
              child: Text("Confirm Patrol"),
              onPressed: () => GetIt.instance<AuthService>().readToken().then((value) => setState((){text = value;})),
            ),
          ],
        ),
      ),
    );
  }
}