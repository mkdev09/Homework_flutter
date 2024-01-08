// // ignore: avoid_web_libraries_in_flutter
// import 'dart:js_util';
// import 'package:flutter/material.dart';
// import 'package:flutter_bcsp7b/blocs/authentication_bloc.dart';
// import 'package:flutter_bcsp7b/blocs/authentication_bloc_provider.dart';
// import 'package:flutter_bcsp7b/blocs/home_bloc.dart';
// import 'package:flutter_bcsp7b/blocs/home_bloc_provider.dart';
// import 'package:flutter_bcsp7b/services/authentication.dart';
// import 'package:flutter_bcsp7b/services/db_firestore.dart';
// import 'package:flutter_bcsp7b/pages/home.dart';
// import 'package:flutter_bcsp7b/pages/login.dart';
// // import 'package:provider/provider.dart';  // Import the provider package

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final AuthenticationService _authenticationService = AuthenticationService();
//     final AuthenticationBloc _authenticationBloc = AuthenticationBloc(_authenticationService);

//     return AuthenticationBlocProvider(
//       authenticationBloc: _authenticationBloc,
//       key: not(null),
//       child: StreamBuilder(
//         initialData: null,
//         stream: _authenticationBloc.user,
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Container(
//               color: Colors.lightGreen,
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasData) {
//             return HomeBlocProvider(
//               homeBloc: HomeBloc(DbFirestoreService(), _authenticationService),
//               uid: snapshot.data,
//               key: not(null),
//               child: _buildMaterialApp(Home()),
//             );
//           } else {
//             return _buildMaterialApp(Login());
//           }
//         },
//       ),
//     );
//   }

//   MaterialApp _buildMaterialApp(Widget homePage) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Journal',
//       theme: ThemeData(
//         primarySwatch: Colors.lightGreen,
//         canvasColor: Colors.lightGreen.shade50,
//         bottomAppBarColor: Colors.lightGreen,
//       ),
//       home: homePage,
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bcsp7b/z_pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
// This widget is the root of your application. @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Journal',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        canvasColor: Colors.lightGreen.shade50,
        bottomAppBarTheme: BottomAppBarTheme( color: Colors.lightGreen),
        // primarySwatch: Colors.blue,
        // bottomAppBarTheme: BottomAppBarTheme(
        //   color: Colors.red, // Change the color of the bottom app bar
        // ),
      ),
      home: Home(),
    );
  }
}
