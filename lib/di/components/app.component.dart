import 'package:flutter_boilerplate/main.dart';
import 'package:inject/inject.dart';

import 'app.component.inject.dart' as g;


// Split this to multiple Components
@Injector()
abstract class AppComponent {
  @provide
  MyApp get app;

  static Future<AppComponent> create() async {
    return await g.AppComponent$Injector.create(
    );
  }
}