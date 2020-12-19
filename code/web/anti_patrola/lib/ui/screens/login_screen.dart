import 'package:anti_patrola/logic/services/auth_service.dart';
import 'package:anti_patrola/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Login to Anti-patrola'),
          RaisedButton(
            onPressed: () {
              GetIt.instance<AuthService>()
                  .signInWithGoogle()
                  .then((isLoggedIn) {
                if (isLoggedIn) {
                  Navigator.pushReplacementNamed(context, Routes.HomeScreen);
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ScreenFactory.createHomeScreen()));
                } else {
                  // TODO: Make this more user-friendly, and log it in sentry
                  debugPrint("ERROR!CAN'T LOGIN WITH GOOGLE.");
                  throw new Error();
                }
              });
            },
            child: Row(
              children: [
                Text('Sign in with Google'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
