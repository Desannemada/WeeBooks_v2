import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/home_view_model.dart';
import 'package:weebooks2/_view_models/login_model.dart';
import 'package:weebooks2/_view_models/sign_in_validation_model.dart';
import 'package:weebooks2/_view_models/sign_up_validation_model.dart';
import 'package:weebooks2/_view_models/user_view_model.dart';
import 'package:weebooks2/models/user.dart';
import 'package:weebooks2/services/auth.dart';
import 'package:weebooks2/ui/telas/splash/splash.dart';
import 'package:weebooks2/values/values.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginViewModel>(
          create: (_) => LoginViewModel(),
        ),
        ChangeNotifierProvider<SignInValidationModel>(
          create: (_) => SignInValidationModel(),
        ),
        ChangeNotifierProvider<SignUpValidationModel>(
          create: (_) => SignUpValidationModel(),
        ),
        ChangeNotifierProvider<UserViewModel>(
          create: (_) => UserViewModel(),
        ),
        ChangeNotifierProvider<HomeViewModel>(
          create: (_) => HomeViewModel(),
        ),
      ],
      child: StreamProvider<Usuario>.value(
        value: AuthService().usuario,
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeeBooks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryCyan,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Merriweather',
        textTheme: TextTheme(
          button: TextStyle(fontWeight: FontWeight.normal),
          headline6: TextStyle(color: Colors.white, fontSize: 17, height: 1.5),
        ),
        cursorColor: Colors.white,
        accentColor: Colors.white,
        textSelectionHandleColor: primaryCyan.withOpacity(0.5),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: primaryCyan,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: secondaryPink,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
