import 'package:flutter/material.dart';

class MyBomb extends StatelessWidget {
  bool revealed;
  final function;

  MyBomb({required this.revealed, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          color: revealed ? Colors.grey[800] : Colors.grey[500],
        ),
      ),
    );
  }
}
