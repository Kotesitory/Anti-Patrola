import 'package:anti_patrola/resources/app_images.dart';
import 'package:anti_patrola/resources/app_strings.dart';
import 'package:anti_patrola/ui/widgets/google_sign_in_button.dart';
import 'package:flutter/material.dart';

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
              AppStrings.LoginScreenSubtitle,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(
              height: 20,
            ),
            SignInWithGoogleButton(),
            Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
