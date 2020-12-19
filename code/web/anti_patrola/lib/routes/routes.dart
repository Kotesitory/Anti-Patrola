import 'package:anti_patrola/logic/bloc/map_screen_bloc.dart';
import 'package:anti_patrola/ui/screens/home_screen.dart';
import 'package:anti_patrola/ui/screens/loading_screen.dart';
import 'package:anti_patrola/ui/screens/login_screen.dart';
import 'package:anti_patrola/ui/widgets/mapbox_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Routes {
  static const String HomeScreen = "homeScreen";
  static const String LoadingScreen = "loadingScreen";
  static const String LoginScreen = "loginScreen";
}

class ScreenFactory {
  static Widget createLoadingScreen() {
    return LoadingScreen();
  }

  static Widget createHomeScreen() {
    return HomeScreen();
  }

  static Widget createLoginScreen() {
    return LoginScreen();
  }

  static Widget createMapBoxScreen() {
    return BlocProvider(
      create: (BuildContext context) {
        return MapScreenBloc();
      },
      child: MapBoxScreenWidget(),
    );
  }
}
