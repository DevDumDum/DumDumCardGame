import 'package:flutter/material.dart';

class MainDataWidget extends InheritedWidget{
  final int highscore;

  const MainDataWidget ({
    Key? key,
    required Widget child,
    required this.highscore,

  }): super( child: child);

  @override
  bool updateShouldNotify(MainDataWidget oldWidget) => oldWidget != highscore;
}