import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/features/app/splash_screen/splash_screen.dart';
import 'package:first_app/features/user_auth/presentation/pages/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:first_app/features/user_auth/presentation/pages/home_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDKmPRno0oBdNLiXrvVnkpul4HwWoIr-FA",
            appId: "1:22358758973:web:5bff6f4b32bbe9ce95fc54",
            messagingSenderId: "22358758973",
            projectId: "loginpage-ad2ee"));
  }

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter First App',
      theme: ThemeData(useMaterial3: true),
      home: const SplashScreen(
        child: LoginPage(),
      ),
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
