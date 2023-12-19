import 'package:flutter/material.dart';
import 'dart:async';

class PlayerTimer extends StatefulWidget {
  // const PlayerTimer({super.key, required this.builder, this.methodFromParent});
  // final CustomBuilder builder;
  // final Function(int val)? methodFromParent;
  const PlayerTimer({super.key, required this.timerRunZero});
  final Function timerRunZero;

  @override
  State<PlayerTimer> createState() => PlayerTimerState();
}

class PlayerTimerState extends State<PlayerTimer> {
  int limit = 30000;
  int playerTime = 0;
  int pMove = 0;
  bool timerStatus = true;
  
  // void _localMethod() {
  //   timerStatus = false;
  //   final collectedString = playerTime;
  //   widget.methodFromParent?.call(collectedString);
  // }

  void startTimer() {
    Timer.periodic(const Duration(milliseconds: 1), (timer) {
      if(playerTime == limit){
        timer.cancel();
        widget.timerRunZero(playerTime);
      }
      if (timerStatus == false){
        timer.cancel();
      } else {
        setState(() {
          playerTime++;
        });
      }
    });
  }

  int toggleTimer() {
    timerStatus=!timerStatus;
    if(timerStatus){
      startTimer();
    }
    return playerTime;
  }

  void incrementMove(){
    pMove+=1;
  }

  void resetTimer(){
    limit = 60000;
    playerTime = 0;
    pMove = 0;
    timerStatus = true;
    if(!timerStatus) {
      startTimer();
    }
  }

  void clearMove(){
    pMove = 0;
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timerStatus = false;
    debugPrint("Timer Stopped");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // widget.builder.call(context, _localMethod);

    return Column(
      children: [Text(
        'Move: $pMove    Time: ${(playerTime/1000).toStringAsFixed(2)}',
        style: const TextStyle(fontSize: 17),
      ),
    ]);
  }
}