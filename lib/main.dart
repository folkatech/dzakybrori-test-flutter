import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './pages/home_page.dart';
import './providers/food_provider.dart';
import './shared/shared_value.dart';
import './shared/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Set Device Orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ChangeNotifierProvider(
      create: (_) => FoodProvider(),
      child: MaterialApp(
        title: 'Foodie',
        theme: kLightTheme,
        initialRoute: RouteName.homePage,
        debugShowCheckedModeBanner: false,
        routes: {
          RouteName.homePage: (ctx) => const HomePage(key: Key('home-page')),
        },
      ),
    );
  }
}
