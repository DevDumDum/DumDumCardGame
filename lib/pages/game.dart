import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:math';
import 'dart:async';

import 'package:dumdumcard/pages/components/timer.dart';
import 'package:dumdumcard/pages/common/bg_pannel.dart';


class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => GameState();
}

class GameState extends State<Game> {
  GlobalKey<PlayerTimerState> globalKey = GlobalKey();
  GlobalKey<DisplayCardState> board = GlobalKey();

  Map data = {};
  String? username = '';
  int bestMoves = 0;
  int totalPairs = 0;
  int bestTime = 0;
  int timeResult = 0;
  int cardRow = 0;
  int cardCol = 0;
  Offset loginOffset = Offset.zero;
  Offset menuOffset = Offset.zero;
  bool connection = false;
  bool reload = false;

  late void Function() method;

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map;
    loginOffset = data['loginOffset'];
    menuOffset = data['menuOffset'];
    cardRow = data['cardRow'];
    cardCol = data['cardCol'];
    connection = data['connection'];
    reload = data['reload'];
    username = data['username'];
    bestMoves = data['bestMoves'];
    totalPairs = data['totalPairs'];
    bestTime = data['bestTime'];

    List cards = [];
    int tempSolvedCards = 0;
    int solvedCards = 0;
    int totalMoves = 0;

    var cardId = <int, GlobalKey<FlipCardState>>{};
    
    List cardState = [];

    GlobalKey<FlipCardState>? card1;
    GlobalKey<FlipCardState>? card2;
    
    void exitGame(){
      Future.delayed(const Duration(milliseconds: 500), (){
        Navigator.pop(context, data);
      });
    }

    void generateCard(){
      int totalPair = ((cardRow*cardCol)/2).round();
      int temp;
      for(int x = 0; x < totalPair; x++){
        while(true){
          temp = (Random().nextInt(25) +1);
          if(!cards.contains(temp)) break;
        }
        cards.add(temp);
        cards.add(temp);

      }
      cards.shuffle();
    }

    Future <void> foldCard(cd1, cd2) async {
      Future.delayed(const Duration(milliseconds: 350), (){
        cd2?.currentState?.toggleCard();
        cd1?.currentState?.toggleCard();
        card1 = card2 = null;
      });
    }

    void timerRunZero(int timeResult){
      
      Future.delayed( const Duration(milliseconds: 400),(){
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return  Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: AlertDialog(
                  title: Text((data['bestMoves'] > totalMoves || (data['bestMoves'] == totalMoves))? 'New HighScore!' : 'Result'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pair solved: $solvedCards'),
                      Text('Number of moves: $totalMoves'),
                      Text('Time: ${timeResult!=0 ? (timeResult/1000).toStringAsFixed(2) : 0}sec'),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        if ( 
                          data['totalPairs'] == 0 || 
                          data['bestMoves'] > totalMoves || 
                          (data['bestMoves'] == totalMoves && data['bestTime'] > timeResult)){

                          data['bestMoves'] = totalMoves;
                          data['totalPairs'] = solvedCards;
                          data['bestTime'] = timeResult;
                        }
                        exitGame();
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      });
    }

    void playerWinCheck() {
      if(cardRow*cardCol == tempSolvedCards && globalKey.currentState!.playerTime < globalKey.currentState!.limit){
        for(int x = 0; x < cardState.length; x++){
          cardState[x] = true;
        }
        card1 = card2 = null;
        cards.clear();
        generateCard();

        board.currentState?.refreshBoard();
        globalKey.currentState?.toggleTimer();

        Future.delayed(const Duration(milliseconds: 500), (){
          for(int x = 0; x < cardState.length; x++){
            cardId[x]?.currentState?.toggleCard();
            board.currentState?.refreshBoard();
          }
        });
        
        Future.delayed(const Duration(milliseconds: 700), (){
          debugPrint('sad');
          globalKey.currentState?.toggleTimer();
        });
        tempSolvedCards = 0;
      }
    }

    void check() async {
      int curId = cardId.keys.firstWhere((k) => cardId[k] == card1);
      int lastId = cardId.keys.firstWhere((k) => cardId[k] == card2);
      if(cards[curId] != cards[lastId]){
        cardState[curId]=null;
        cardState[lastId]=null;
        await foldCard(card1, card2);
      } else {
        tempSolvedCards+=2;
        solvedCards+=2;
        cardState[curId]=false;
        cardState[lastId]=false;
        card1 = card2 = null;
      }
      playerWinCheck();
    }

    void cardPressed(dynamic thisCard){
      if(card1 == null || (card2 == null && card1 != null)){
        if(card1 == null){
          card1 = thisCard;
        } else if (card2 == null && card1 != null){
          card2 = thisCard;
          check();
        }
        thisCard?.currentState?.toggleCard();
        totalMoves+=1;
        globalKey.currentState?.incrementMove();
      }
    }

    generateCard();

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/bg.png'),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          )
        ),
        child: Stack(
          fit: StackFit.passthrough,
          clipBehavior: Clip.antiAlias,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 90, bottom: 20),
              child: BgPannel(
                height: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    PlayerTimer(key: globalKey, timerRunZero: timerRunZero),

                    DisplayCard(
                      key: board,
                      callback: cardPressed,
                      cardCol: cardCol,
                      cardRow: cardRow,
                      cardState: cardState,
                      cards: cards,
                      cardId: cardId,
                    )
                    
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(top:60, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: (){
                      setState(() {
                        cards.clear();
                        generateCard();
                      });
                    },
                    icon: Image.asset(
                      'assets/images/icon_btn/reset.png',
                      fit: BoxFit.fill,
                    ),
                    padding: EdgeInsets.zero,
                    iconSize: 50,
                  ),

                  const SizedBox(width: 10),

                  IconButton(
                    icon: Image.asset(
                      'assets/images/icon_btn/pause.png',
                      fit: BoxFit.fill,
                    ),
                    padding: EdgeInsets.zero,
                    iconSize: 50,
                    onPressed: () {
                      data['reload'] = true;
                      Navigator.pop(context, data);
                    },
                  ),
            
                  const SizedBox(width: 10,),
            
                  IconButton(
                    icon: Image.asset(
                      'assets/images/icon_btn/close.png',
                      fit: BoxFit.fill,
                    ),
                    padding: EdgeInsets.zero,
                    iconSize: 50,
                    onPressed: () {
                      Navigator.pop(context, data);
                    },
                  )
                ]
              ),
            )
          ]
        )
      ),
    );
  }
}

class DisplayCard extends StatefulWidget {
  const DisplayCard({super.key,
    required this.callback,
    required this.cardCol,
    required this.cardRow,
    required this.cardState,
    required this.cards,
    required this.cardId,
  });

  final Function callback;
  final int cardCol;
  final int cardRow;
  final List cardState;
  final List cards;
  final dynamic cardId;
  
  @override
  State<DisplayCard> createState() => DisplayCardState();
}

class DisplayCardState extends State<DisplayCard> {
  @override

  void refreshBoard(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
          for(int zz = 0; zz < widget.cards.length; zz++)
            for(int x = 0; x < widget.cardCol; x++)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for(int i = 0; i < widget.cardRow; i++, zz++)
                    (){
                      widget.cardState.add(true);
                      widget.cardId.putIfAbsent(zz, () => GlobalKey<FlipCardState>());
                      GlobalKey<FlipCardState>? thisCard = widget.cardId[zz];
                      return FlipCard(
                        key: thisCard,
                        flipOnTouch: false,
                        speed: 250,
                        direction: FlipDirection.HORIZONTAL,
                        side: CardSide.FRONT,
                        autoFlipDuration: const Duration(milliseconds: 800),
                        front: Container(
                          padding: const EdgeInsets.symmetric(vertical:10),
                          child: AnimatedOpacity(
                            opacity: widget.cardState[zz] == true || widget.cardState[zz] == null? 1.0: 0.0,
                            duration: const Duration(milliseconds: 500),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 60
                              ),
                              child: Image(
                                image: AssetImage("assets/images/symbols/${widget.cards[zz]}.png"),
                                fit: BoxFit.fill,
                                width: ((MediaQuery.of(context).size.width-50)/widget.cardCol)-20,
                              ),
                            ),
                          ),
                        ),
                        back: 
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 70,
                              maxWidth: 60
                            ),
                            child: Image.asset(
                              "assets/images/backgrounds/backCard.png",
                              fit: BoxFit.fill,
                              height: ((MediaQuery.of(context).size.height-300)/widget.cardCol)-20,
                              width: ((MediaQuery.of(context).size.width-40)/widget.cardCol)-20,
                            ),
                          ),
                          
                          onPressed: () {
                            setState(() {
                              widget.callback(thisCard);
                            });
                          },
                        )
                      );
                    }()
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}