import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flip_card/flip_card.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  bool loadStatus = true; //flipping logo animation on
  bool dataStatus = false; //if all data loaded
  bool connection = false; //if connected to the internet / database was established, then true

  void checkUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? dumdataTemp = prefs.getString('DumDumCard'); // [0][username, password, bestMoves, totalPairs, bestTime]
    final String? username;
    final int? bestMoves;
    final int? totalPairs;
    final int? bestTime;

    Offset o1 = Offset.zero;
    Offset o2 = const Offset(1.0,0.0);
    dataStatus = true; //local user loaded

    //animation loop
    while(loadStatus){
      await Future.delayed(const Duration(seconds: 1), (){
        cardKey.currentState?.toggleCard();
      });

      if(dataStatus){
        Future.delayed(const Duration(seconds: 1), (){
          loadStatus = false;
        });
      }
    }

    if(dumdataTemp != null){
      List dumdata = jsonDecode(dumdataTemp);
      debugPrint('Detected: $dumdata');
      o1 = const Offset(-1.0,0.0);
      o2 = Offset.zero;
      username = dumdata[0][0];
      bestMoves = dumdata[0][2];
      totalPairs = dumdata[0][3];
      bestTime = dumdata[0][4];
    } else {
      username = '';
      bestMoves = 0;
      totalPairs = 0;
      bestTime = 0;
      debugPrint('No User:{ $dumdataTemp }');
    }

    if (!context.mounted) return;
    debugPrint("done loading");

    Navigator.pushReplacementNamed(context, './screen', 
      arguments: {
        'loginOffset': o1,
        'menuOffset': o2,
        'cardRow': 4,
        'cardCol': 4,
        'username': username,
        'bestMoves': bestMoves,
        'totalPairs': totalPairs,
        'bestTime': bestTime,
        'connection': connection,
        'reload': false,
    });
  }

  @override
  
  void initState(){
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(20,20,20,0.5),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(50),
        child: FlipCard(
          key: cardKey,
          direction: FlipDirection.HORIZONTAL,
          side: CardSide.FRONT,
          front: const Image(
              image: AssetImage('assets/images/logo.png'),
              height: 70,
            ),
          back: const Image(
            image: AssetImage('assets/images/logo.png'),
            height: 70,
          ),
        ),
      ),
    );
  }
}