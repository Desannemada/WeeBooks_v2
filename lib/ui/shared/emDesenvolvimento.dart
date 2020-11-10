import 'package:flutter/material.dart';

class EmDesenvolvimento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/desenvolvimento.png',
            scale: 5,
          ),
          SizedBox(height: 20),
          Text(
            'Funcionalidade em desenvolvimento',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
