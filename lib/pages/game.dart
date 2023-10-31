import 'package:dumdumcard/pages/common/bg_pannel.dart';
import 'package:dumdumcard/pages/components/timer.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';


class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

// class cardController extends StatelessElement{
//   final cardId;

//   cardController(super.widget, this.cardId);
//   bool cardIsFlipped = false;

//   void updateCardIsFlipped() => cardIsFlipped = !cardIsFlipped;

//   Future<void> nextQuestion() async {
//     if (cardIsFlipped) {
//       cardId.currentState?.toggleCard();
//     }
//   }  
// }



class _GameState extends State<Game> {

  Map data = {};
  int hs = 0;
  
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map;
    hs = data['highscore'];
    int row = data['row']?? 4;
    int col = data['col']?? 4;

    int solvedCards = 0;
    List cards = [];
    var cardId = <int, GlobalKey<FlipCardState>>{};
    
    Map cardState = {};

    void generateCard(){
      int totalPair = ((row*col)/2).round();
      int temp;
      for(int x = 0; x < totalPair; x++){
        while(true){
          temp = (Random().nextInt(25) +1);
          if(!cards.contains(temp)) break;
        }
        
        //adding 2 cards to the list of cards
        cards.add(temp);
        cards.add(temp);

      }
      // print('Set: $cards');
      // print('Pair: $totalPair');

      cards.shuffle();
      // print('Shuffled: $cards');
      // Future.delayed(Duration(milliseconds: 800),(){
      //   startTime();
      // });
    }

    generateCard();

    GlobalKey<FlipCardState>? card1;
    GlobalKey<FlipCardState>? card2;

    Future <void> foldCard(cd1, cd2) async {
      Future.delayed(const Duration(milliseconds: 500), (){
        cd2?.currentState?.toggleCard();
        cd1?.currentState?.toggleCard();
        // print('++++++++++++++++++++');
        // print(card2);
        // print(card1);
        // print('++++++++++++++++++++');
      });
    }

    int loadScore(){
      hs = data['highscore'] = solvedCards;
      return hs;
    }

    void playerWinCheck(){
      if(row*col == solvedCards){
        Future.delayed( const Duration(milliseconds: 400),(){
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return  Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: AlertDialog(
                    title: const Text('Congraaaaats'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pair solved: $solvedCards'),
                        const Text('Time: comming soon...'),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
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
    }

    void check() async {
      int curId = cardId.keys.firstWhere((k) => cardId[k] == card1);
      int lastId = cardId.keys.firstWhere((k) => cardId[k] == card2);
      // print('===================');
      // print('${cards[curId]} == ${cards[lastId]}');
      if(cards[curId] != cards[lastId]){
        await foldCard(card1, card2);
        // print("$card1 | $card2");
      } else {
        solvedCards+=2;
        loadScore();
      }
      card1 = card2 = null;

      playerWinCheck();
    }


    // Future <void> removeCard() async {
    //   await Future.delayed(Duration(milliseconds: 400), (){
    //     cardPressed.removeAt(0);
    //     cardPressed.removeAt(0);
    //     print('>>> $cardPressed');
    //   });
    // }

    // Future <void> foldCard(card1, card2) async {
    //   await Future.delayed(Duration(milliseconds: 400), (){
    //     card2?.currentState?.toggleCard();
    //     card1?.currentState?.toggleCard();
    //     // print('++++++++++++++++++++');
    //     // print(card2);
    //     // print(card1);
    //     // print('++++++++++++++++++++');
    //   });
    // }

    // Future<void> flipper() async{
    
    //   bool rmCard = false;
    //   bool fdCard = false;

    //   if(cardPressed.length%2 == 0 || cardPressed.length > 2){
    //     // flipStatus = false;
    //     // await Future.delayed(Duration(milliseconds: 400), (){
    //       // if((cardPressed.length%2 == 0 || cardPressed.length == 3)){ //check pair (will check by 2)
    //     int curId = cardId.keys.firstWhere((k) => cardId[k] == cardPressed[0]);
    //     int lastId = cardId.keys.firstWhere((k) => cardId[k] == cardPressed[1]);
    //     print('===================');
    //     print('${cards[curId]} == ${cards[lastId]}');
    //     if(cards[curId] == cards[lastId]){
    //       hs = data['highscore']+=10;
    //       rmCard = true;
    //     }else{
    //       fdCard = true;
    //       rmCard = true;
    //     }
    //     print('===================');
    //       // }
    //     // });

    //     print("> cp: ${cardPressed}");

      
    //     if(fdCard){
    //       foldCard(cardPressed[0], cardPressed[1]);
    //       fdCard = false;
    //       print("Fold!"); 
    //     }

    //     if(rmCard){
    //       await removeCard();
    //       rmCard = false;
    //     }
    //     print(">> cp: ${cardPressed}");
    //     // flipStatus = true;
    //   }
    // }


    // Future<void> flipper() async {
    //   if(flipStatus){
    //     int curId = cardId.keys.firstWhere((k) => cardId[k] == cardPressed[0]);
    //     int? lastId;
    //     if(cardPressed.length > 1){
    //       lastId = cardId.keys.firstWhere((k) => cardId[k] == cardPressed[1]);
    //     }
    //     print("================");
    //     print(flipStatus);
    //     print(cardPressed);
    //     print(cards[curId]);
    //     print("================");
    //     if(cardState[curId] == true){
    //       var curC = cardId[curId];
    //       var lastC;

    //       curC?.currentState?.toggleCard();
    //       if(lastId != null){
    //         lastC = cardId[lastId];

    //         if(lastC == null){
    //           lastFlipped = curC;
    //         } else {
    //           flipStatus = false;

    //           if(cards[curId] == cards[lastId]){
    //             print('Match: ${cards[curId]} == ${cards[lastId]}');
    //             cardState[curId] = false;
    //             cardState[lastId] = false;
    //             cardPressed.removeRange(0,1);
    //             print("Current> $cardPressed");
    //             flipStatus = true;
    //           } else {
    //             await Future.delayed(Duration(milliseconds: 500), (){
    //               curC?.currentState?.toggleCard();
    //               lastC?.currentState?.toggleCard();
    //               cardPressed.removeRange(0,1);
    //               print("Current> $cardPressed");
    //               flipStatus = true;
    //             });
    //             print('Wrong: ${cards[curId]} == ${cards[lastId]}');
    //           }
    //         }
    //       }
    //     }
    //   }
    // }
    

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
                    const SizedBox(height: 20,),
                    const PlayerTimer(),
              
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                          for(int zz = 0; zz < cards.length; zz++)
                            for(int x = 0; x < col; x++)
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    for(int i = 0; i < row; i++, zz++)
                                    (){
                                      cardId.putIfAbsent(zz, () => GlobalKey<FlipCardState>());
                                      GlobalKey<FlipCardState>? thisCard = cardId[zz];
                                      cardState[zz] = true;
                                      // bool tempState = cardState[zz];
                                          
                                    return FlipCard(
                                      key: thisCard,
                                      //autoFlipDuration: const Duration(seconds: 1),
                                      flipOnTouch: false,
                                      speed: 400,
                                      direction: FlipDirection.HORIZONTAL,
                                      side: CardSide.FRONT,
                                      autoFlipDuration: const Duration(milliseconds: 800),
                                      front: Container(
                                        padding: const EdgeInsets.symmetric(vertical:10),
                                        // color: Colors.white,
                                        child: Image(
                                          image: AssetImage("assets/images/symbols/${cards[zz]}.png"),
                                          fit: BoxFit.fill,
                                          width: ((MediaQuery.of(context).size.width-50)/col)-20,
                                        ),
                                      ),
                                      back: 
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero
                                        ),
                                        child: Image.asset(
                                          "assets/images/backgrounds/backCard.png",
                                          fit: BoxFit.fill,
                                          height: ((MediaQuery.of(context).size.height-300)/col)-20,
                                          width: ((MediaQuery.of(context).size.width-40)/col)-20,
                                        ),
                                        
                                        onPressed: () {
                                          if(card1 == null){
                                            thisCard?.currentState?.toggleCard();
                                            card1 = thisCard;
                                          } else {
                                            thisCard?.currentState?.toggleCard();
                                            card2 = thisCard;
                                            check();
                                          }
                                          // if(!cardPressed.contains(thisCard)){
                                          //   cardPressed.add(thisCard);
                                          //   thisCard?.currentState?.toggleCard();
                                          //   print('>> $cardPressed');
                                          //   Future.delayed(Duration(milliseconds: 400),(){
                                          //     // if(flipStatus){
                                          //       flipper();
                                          //     // }
                                          //   });
                                          // }
                                        },
                                      )
                                      // Column(
                                      //   children: [
                                      //     Text('${zz}'),
                                      //     Image(
                                      //       image: const AssetImage("assets/images/backgrounds/backCard.png"),
                                      //       fit: BoxFit.cover,
                                      //       height: (MediaQuery.of(context).size.height-400)/col,
                                      //     ),
                                      //   ],
                                      // ),
                                      // onFlipDone:(isFront){
                                      //   if(lastFlipped !=null){
                                      //     if(cards[cardId.keys.firstWhere((k) => cardId[k] == lastFlipped)] != cards[cardId.keys.firstWhere((k) => cardId[k] == thisCard)]){
                                      //       thisCard?.currentState?.toggleCard();
                                          
                                      //       if(lastFlipped?.currentState?.isFront == true)
                                      //         lastFlipped?.currentState?.toggleCard();
                                      //       print("Wrong: ${cards[cardId.keys.firstWhere((k) => cardId[k] == lastFlipped)]} | ${cards[cardId.keys.firstWhere((k) => cardId[k] == thisCard)]}");
                                      //       lastFlipped = null;
                                      //     } else {
                                      //       cardState[cardId.keys.firstWhere((k) => cardId[k] == thisCard)] = false;
                                      //       cardState[cardId.keys.firstWhere((k) => cardId[k] == lastFlipped)] = false;
                                      //       print("Correct: ${cards[cardId.keys.firstWhere((k) => cardId[k] == lastFlipped)]} | ${cards[cardId.keys.firstWhere((k) => cardId[k] == thisCard)]}");
                                      //       print(lastFlipped);
                                      //     }
                                      //   } else {
                                      //     Future.delayed(Duration(milliseconds: 300), (){
                                      //       cardState[cardId.keys.firstWhere((k) => cardId[k] == thisCard)] = false;
                                      //       print('State: ${cardState}');
                                      //     });
                                      //     print("done");
                                      //     lastFlipped = thisCard;
                                      //   }
                                      // },
                                      // onFlip: (){
                                      //   // if(thisCard?.currentState?.isFront == true && lastFlipped == null){
                                      //   //   thisCard?.currentState?.toggleCardWithoutAnimation();
                                      //   //   print("clicked again");
                                      //   // }
                                      // },
                                    );
                                    }()
                                  ],
                                ),
                              ) 
                            // Text('${cards.length} : $row | $col'),
                            // Text(((MediaQuery.of(context).size.height)).toString()),
                            // Text((MediaQuery.of(context).size.width).toString()),
                            // Text((MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height)).toString()),
                            // Text((MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / row)).toString())
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
                  padding: const EdgeInsets.only(top:60, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // ElevatedButton(
                      //   onPressed: (){
                      //     // PlayerTimer(startTime());
                      //   },
                      //   child: const Text('Start timer'),
                      // ),
                      IconButton(
                        icon: Image.asset(
                          'assets/images/icon_btn/reset.png',
                          fit: BoxFit.fill,
                        ),
                        padding: EdgeInsets.zero,
                        iconSize: 50,
                        onPressed: () {
                          setState(() {
                            generateCard();
                          });
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
                          Navigator.pop(context, hs);
                        },
                      )
                    ]
                  ),
                ),

            // ElevatedButton(
            //   onPressed: (){
            //     setState(() {
            //       // hs = data['highscore']+=2;
            //       //hs = Random().nextInt(3);
            //       generateCard();
            //       //print(hs+1);
            //     });
            //   },
            //   child: const Text("Reset"),
            // ),
          ],
        ),
      ),
    );
  }
}