import 'package:flutter/material.dart';
import 'package:weebooks2/ui/shared/logo.dart';

class EmailValidacao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Logo(
                  fontSize: 20,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Valide seu e-mail',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
