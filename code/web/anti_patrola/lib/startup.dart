import 'package:anti_patrola/logic/services/auth_service.dart';
import 'package:anti_patrola/logic/services/patrol_service.dart';
import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';

import 'data/network.dart';

class Startup {
  static Future runEssentialPass() async {
    var getIt = GetIt.instance;
    getIt.registerSingleton<Network>(Network());
    getIt.registerSingleton<AuthService>(AuthService());
    getIt.registerSingleton<PatrolService>(PatrolService());
    getIt.registerSingleton<EventBus>(EventBus());
  }
}
