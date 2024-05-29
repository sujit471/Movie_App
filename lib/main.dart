import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'homepage/homepage.dart';
import 'navigation_menu/navigation_bar.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:const FirebaseOptions( apiKey: 'AIzaSyAGgSG9DogZo3gVBvhPK1bz5KOJUUoGktE',
        appId: '1:391270518843:android:e42613dea5efb98c444c1e', messagingSenderId: 'messagingSenderId',
        projectId:'movieapp-2fe35'
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: NavigationMenu(),
    );
  }
}

