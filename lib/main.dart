import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'Router.dart';
import 'bloc/auth/exports.dart';
import 'bloc/notifications/exports.dart';
import 'bloc/theme/exports.dart';
import 'pages/LandingPage.dart';
import 'models/contact.dart';


void main() async{
  final appDocumentDirectory =
  await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(ContactAdapter(), 0);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeData lightTheme = ThemeData(
    accentColor: Colors.lightBlue,
    appBarTheme: AppBarTheme(
      color: Colors.white.withOpacity(0.95),
      elevation: 0.15,
      textTheme: TextTheme(
        title: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    ),
    backgroundColor: Colors.white,
    bottomAppBarColor: Colors.lightBlue.shade600,
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
  );
  final ThemeData darkTheme = ThemeData(
    accentColor: Colors.lightBlue,
    appBarTheme: AppBarTheme(
      color: Colors.black,
      elevation: 0.15,
      textTheme: TextTheme(
        title: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    ),
    bottomAppBarColor: Colors.black,
    brightness: Brightness.dark,
    primarySwatch: Colors.red,
    textSelectionHandleColor: Colors.lightBlue,
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<Bloc<dynamic, dynamic>>>[
        BlocProvider<ThemeBloc>(
          builder: (BuildContext context) => ThemeBloc(),
        ),
        BlocProvider<NotifBloc>(
          builder: (BuildContext context) => NotifBloc(),
        ),
        BlocProvider<AuthBloc>(
          builder: (BuildContext context) => AuthBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (BuildContext context, ThemeState themeSate) {
          return MaterialApp(
            title: 'Grade++',
            theme: themeSate is LightTheme ? lightTheme : darkTheme,
            onGenerateRoute: Router.generateRoute,
            builder: (BuildContext context, Widget child) {
              return ScrollConfiguration(
                behavior: Scroller(),
                child: child,
              );
            },
            home: FutureBuilder(
              future: Hive.openBox(
                'contacts',
                compactionStrategy: (int total, int deleted) {
                  return deleted > 20;
                },
              ),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError)
                    return Text(snapshot.error.toString());
                  else
                    return LandingPage();
                } else
                  return Scaffold();
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    Hive.box('contacts').compact();
    Hive.close();
    super.dispose();
  }
}

class Scroller extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
