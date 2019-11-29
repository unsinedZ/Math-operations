import 'package:flutter/material.dart';

class FunctionVariable extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;
  
  const FunctionVariable({
    this.name,
    this.onPressed
  });
  
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(name),
      onPressed: onPressed,
    );
  }
}