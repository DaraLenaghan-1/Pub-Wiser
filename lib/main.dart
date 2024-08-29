import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/features/app/splash_screen/splash_screen.dart';
import 'package:first_app/features/user_auth/UI/pages/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:first_app/features/app/pages/home_page.dart';
import 'package:first_app/features/app/pages/tabs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: Colors.black,
    //Color(0xFF14213D), // Dark blue, used for interactive elements
    onPrimary: Colors.white, // For legibility on primary color
    secondary: Color(0xFFFCA311), // Orange, used for secondary accents
    onSecondary: Colors.black, // For legibility on secondary color
    background: Color(0xFFFFFFFF), // White background for general app usage
    onBackground: Colors.black, // For legibility on background color
    surface: Color(0xFFE5E5E5), // Light gray for cards and UI surfaces
    onSurface: Colors.black, // For legibility on surface color
    error: Colors.redAccent, // Red for error states
    onError: Colors.white, // White on error states for legibility
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
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    const ProviderScope(
      // Wrapped app with ProviderScope
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pub Wiser',
      theme: theme,
      home: const SplashScreen(child: LoginPage()),
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        // '/categories': (context) => CategoriesScreen(onToggleFavourite: (pub) {}),
        '/tabs': (context) => const TabsPage(),
      },
    );
  }
}
