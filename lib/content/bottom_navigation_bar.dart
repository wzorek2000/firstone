import 'package:flutter/material.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationBarScreen(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  _BottomNavigationBarScreenState createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Stream',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Historia',
        ),
      ],
      selectedItemColor: Colors.purple,
    );
  }
}
