import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:application/pages/home_page.dart';
import 'package:application/pages/product_detail.dart';
import 'package:application/pages/add_product_page.dart';
import 'package:application/widgets/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAWWmxb1oCzN4G9FdNGTbgawHn78qPfawQ",
        authDomain: "btl-flutter-186ad.firebaseapp.com",
        projectId: "btl-flutter-186ad",
        storageBucket: "btl-flutter-186ad.appspot.com",
        messagingSenderId: "623047614259",
        appId: "1:623047614259:web:c3a2d80c8ab383f92ce846",
        measurementId: "G-QMR067R4NM",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/detail': (context) => ProductDetail(
                product: ModalRoute.of(context)!.settings.arguments as dynamic,
              ),
          '/add_product': (context) => AddProductPage(),
        },
      ),
    );
  }
}
