import 'package:application/pages/login.dart';
import 'package:application/pages/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:application/pages/home_page.dart';
import 'package:application/pages/product_detail.dart';
import 'package:application/pages/add_product_page.dart';
import 'package:application/widgets/cart_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: FutureBuilder(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasData) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: '/home',
              routes: {
                '/login': (context) => const LoginPage(),
                '/register': (context) => const RegisterPage(),
                '/home': (context) => const HomePage(),
                '/detail': (context) => ProductDetail(
                      product:
                          ModalRoute.of(context)!.settings.arguments as dynamic,
                    ),
                '/add_product': (context) => AddProductPage(),
              },
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: '/login',
              routes: {
                '/login': (context) => const LoginPage(),
                '/home': (context) => const HomePage(),
                '/detail': (context) => ProductDetail(
                      product:
                          ModalRoute.of(context)!.settings.arguments as dynamic,
                    ),
                '/add_product': (context) => AddProductPage(),
              },
            );
          }
        },
      ),
    );
  }
}
