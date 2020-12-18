import 'package:anti_patrola/logic/bloc/map_screen_bloc.dart';
import 'package:anti_patrola/logic/services/auth_service.dart';
import 'package:anti_patrola/logic/services/patrol_service.dart';
import 'package:anti_patrola/ui/widgets/mapbox_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

/// The current user streams the location on every 5 seconds (on 5s => check for patrols). When the backend receives the location, a calculation is run (if there's a patrol in radius of 500m, a notification is sent)
/// If the user's location is in radius of 20m from the police patrol, show confirmation dialog
/// {patrol_id, distance}

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
      body: Center(
        child: Stack(
          children: [
            BlocProvider(
              create: (BuildContext context) {
                return MapScreenBloc();
              },
              child: MapBoxScreenWidget(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(text),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    child: Container(
                        color: Colors.greenAccent,
                        padding: const EdgeInsets.all(8),
                        child: Text("Google Login")),
                    onPressed: () =>
                        GetIt.instance<AuthService>().signInWithGoogle(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    child: Container(
                        color: Colors.greenAccent,
                        padding: const EdgeInsets.all(8),
                        child: Text("Get Patrols")),
                    onPressed: () => GetIt.instance<PatrolService>()
                        .getPatrols(), // Once on the start, then on every 30s. Used only for UI representation.
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    child: Container(
                        color: Colors.greenAccent,
                        padding: const EdgeInsets.all(8),
                        child: Text("Report Patrol")),
                    onPressed: () => GetIt.instance<PatrolService>()
                        .reportNewPatrol(LatLng(1.0, 0.0)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    child: Container(
                        color: Colors.greenAccent,
                        padding: const EdgeInsets.all(8),
                        child: Text("Get Rediused Patrol")),
                    onPressed: () => GetIt.instance<PatrolService>()
                        .getPatrolsNearUser(LatLng(1.0, 0.0)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    child: Container(
                        color: Colors.greenAccent,
                        padding: const EdgeInsets.all(8),
                        child: Text("Confirm Patrol")),
                    onPressed: () => GetIt.instance<AuthService>()
                        .readToken()
                        .then((value) => setState(() {
                              text = value;
                            })),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
