import 'package:album/provider/homeScreenProvider.dart';
import 'package:album/screens/homeScreen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Album Provider',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider<HomeScreenProvider>(
        create: (context) => HomeScreenProvider(),
        child: HomeScreen(),
      ),
    );
  }
}