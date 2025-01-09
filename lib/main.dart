import 'package:e_commerce_grocery_application/Pages/onboardingpage.dart';
import 'package:e_commerce_grocery_application/provider/cart_provider.dart';
import 'package:e_commerce_grocery_application/provider/product_provider.dart';
import 'package:e_commerce_grocery_application/provider/userIdprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          home: SplashScreen()),
    );
  }
}
//image_path: "assets/app_logo.jpeg"
// dev_dependencies:
//   flutter_test:
//     sdk: flutter
//   flutter_launcher_icons: ^0.14.1
// flutter_icons:
//   android: true
//   ios: true
