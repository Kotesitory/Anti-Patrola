import 'package:anti_patrola/logic/services/auth_service.dart';
import 'package:anti_patrola/resources/app_images.dart';
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
    return Material(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppImages.Background), fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Spacer(),
            Image.asset(
              AppImages.Logo,
              scale: 3,
            ),
            SizedBox(height: 10),
            Text(
              'To start using Anti-patrola you must',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              color: Colors.white,
              elevation: 12,
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppImages.GoogleLogo,
                      scale: 15,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      'Sign in with Google',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
