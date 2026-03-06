import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainLayoutView extends StatelessWidget {
  const MainLayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 60,
        color: Colors.blue,
        child: const Center(child: Text("Bottom Navigation Bar")),
      ),
    );
  }
}
