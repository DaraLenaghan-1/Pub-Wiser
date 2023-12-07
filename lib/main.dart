import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/features/app/splash_screen/splash_screen.dart';
import 'package:first_app/features/user_auth/UI/pages/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:first_app/features/user_auth/UI/pages/home_page.dart';
import 'package:first_app/features/app/pages/categories.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:first_app/data/firebase_store_implementation/firestore_pubData.dart';


final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 131, 57, 0),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);
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
      title: 'Pub Wiser',
      theme: ThemeData(useMaterial3: true),
      home: const SplashScreen(
        child: LoginPage(),
      ),
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/categories': (context) => const CategoriesScreen(),
      },
    );
  }
}
