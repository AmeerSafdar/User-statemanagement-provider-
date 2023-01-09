// ignore_for_file: prefer_const_constructors

import 'package:apploginfirebase/providers/user_provider.dart';
import 'package:apploginfirebase/views/home_screen.dart';
import 'package:apploginfirebase/views/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Future.delayed(Duration(seconds: 3)).then((value) {
    FlutterNativeSplash.remove();
  });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var user;
    @override
  void initState() {
    super.initState();
    user= FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
        create: (_) => UserProvider(),
      ),
      ],
      child: MaterialApp(
        title: 'Flutter ',
        theme: ThemeData(
         
          primarySwatch: Colors.blue,
        ),
        home:StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          if (user==null ||user=='' ) {
                          return  LoginScreen();
                          }
                          else{
                           return HomeScreen();
                          }

                        } else if (snapshot.hasError) {
                          return Center(child: Text('${snapshot.error}'));
                        }
                      } else if (snapshot.connectionState ==ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue
                          ),
                        );
                      }
                      return (user==null ||user=='' ) ? LoginScreen() : HomeScreen();
                    })
                    ));
          
      
    
  }
}
