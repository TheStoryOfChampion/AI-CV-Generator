// internal
import 'package:ai_cv_generator/pages/elements/elements.dart';
import 'package:ai_cv_generator/dio/client/shareClient.dart';
import 'package:ai_cv_generator/pages/screens/register.dart';
import 'package:ai_cv_generator/pages/screens/about.dart';
import 'package:ai_cv_generator/pages/screens/help.dart';
import 'package:ai_cv_generator/pages/screens/home.dart';
import 'package:ai_cv_generator/pages/screens/login.dart';
import 'package:ai_cv_generator/pages/widgets/pdf_window.dart';
import 'package:ai_cv_generator/pages/screens/profile.dart';

// external
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  Uri myurl = Uri.base;
  if (myurl.path.contains("/share/")) {
    String uuid = myurl.pathSegments.last;
    PlatformFile? file = await ShareApi.retrieveFile(uuid: uuid);
    runApp(ShareCVApp(file: file));
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mainTheme,
      themeMode: ThemeMode.system,
      title: 'AI CV Generator',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/':(context) => const Login(),
        '/register':(context) => const RegisterPage(),
        '/home':(context) => const Home(),
        '/profile':(context) => const Profile(),
        '/about':(context) => const AboutPage(),
        '/help':(context) => const Help()
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/profile') {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context,animation, secondaryAnimation ) => const Profile(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {

              return FadeTransition(
                opacity: animation,
                child: child
              );
            },
            transitionDuration: Duration.zero,
            reverseTransitionDuration: const Duration(seconds: 2)
          );
        }
        return MaterialPageRoute(builder: (context)=> const Home());
      },
    );
  }
}

class ShareCVApp extends StatelessWidget {
  const ShareCVApp({super.key, required this.file});
  final PlatformFile? file;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI-CV-GENERATOR_DEMO1_build',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/':(context) => PdfWindow(file: file),
      },
    );
  }
}