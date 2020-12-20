import 'package:anti_patrola/logic/bloc/map_screen_bloc.dart';
import 'package:anti_patrola/logic/services/auth_service.dart';
import 'package:anti_patrola/logic/services/geolocation_service.dart';
import 'package:anti_patrola/logic/services/patrol_service.dart';
import 'package:anti_patrola/resources/app_images.dart';
import 'package:anti_patrola/routes/routes.dart';
import 'package:anti_patrola/ui/widgets/mapbox_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String text = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              AppImages.Logo,
              scale: 12,
            ),
            RaisedButton(
              elevation: 0,
              color: Colors.transparent,
              onPressed: () {
                // TODO: Implement logout
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text('Are you sure you want to logout?'),
                        actions: [
                          RaisedButton(
                            onPressed: () {
                              GetIt.instance<AuthService>()
                                  .signOut()
                                  .then((isSignedOut) {
                                if (isSignedOut)
                                  Navigator.pushReplacementNamed(
                                      context, Routes.LoginScreen);
                              });
                              Navigator.pop(context);
                            },
                            color: Colors.greenAccent,
                            child: Text('YES'),
                          ),
                          RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.redAccent,
                            child: Text('NO'),
                          ),
                        ],
                      );
                    });
              },
              child: Text(
                'Logout',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: ScreenFactory.createMapBoxScreen(),
      ),
    );
  }
}
