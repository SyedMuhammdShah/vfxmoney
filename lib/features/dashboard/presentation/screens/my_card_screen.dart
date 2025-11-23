import 'package:flutter/material.dart';
import 'package:vfxmoney/shared/widgets/custom_appbar.dart';

class MyCardScreen extends StatefulWidget {
  const MyCardScreen({super.key});

  @override
  State<MyCardScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Cards', implyLeading: true),
      body: Center(child: Text('My Cards Screen')),
    );
  }
}
