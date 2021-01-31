import 'package:anti_patrola/logic/services/auth_service.dart';
import 'package:anti_patrola/resources/app_images.dart';
import 'package:anti_patrola/resources/app_strings.dart';
import 'package:anti_patrola/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SignInWithGoogleButton extends StatelessWidget {
  const SignInWithGoogleButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.white,
      elevation: 12,
      onPressed: () {
        GetIt.instance<AuthService>()
            .signInWithGoogle()
            .then((isLoggedIn) {
          if (isLoggedIn) {
            Navigator.pushReplacementNamed(context, Routes.HomeScreen);
          } else {
            debugPrint("ERROR! CAN'T LOGIN WITH GOOGLE.");
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
              AppStrings.LoginScreenSignInWithGoogleButtonText,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}