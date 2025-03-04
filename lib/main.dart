import 'package:darzi/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/l10n.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // static void setLocale(BuildContext context, Locale newLocale) {
  //   _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
  //   state?.setLocale(newLocale);
  // }
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en');

  @override
  void initState() {
    super.initState();
    _loadSavedLocale(); // Load saved locale during initialization
  }

  void _loadSavedLocale() async {
    Locale savedLocale = await getSavedLocale();
    setState(() {
      _locale = savedLocale;
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  Future<Locale> getSavedLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('selectedLanguage');
    print("My Language Code is:$languageCode");
    return languageCode != null ? Locale(languageCode) : Locale('en');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        locale: _locale,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L10n.all,
        home: SplashScreen(onChangeLanguage: setLocale)
    );
        // home: AnimatedSplashScreen(
        //     duration: 800,
        //     splash: 'assets/images/darjiLogo.png',
        //     splashIconSize: 220,
        //     nextScreen: userType=="tailor"? TailorDashboardNew():userType== "customer"? CustomerDashboardNew():HomePage(),
        //     // nextScreen: userType == "tailor"?TailorDashboardNew():HomePage(),
        //     splashTransition: SplashTransition.sizeTransition,
        //     backgroundColor: Colors.white));
      //
  }
}

