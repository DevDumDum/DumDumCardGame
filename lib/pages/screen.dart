import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dumdumcard/pages/common/bg_pannel.dart';
import 'package:dumdumcard/pages/common/flip_btn.dart';


class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  Map data = {};
  String? username = '';
  int bestMoves = 0;
  int totalPairs = 0;
  int bestTime = 0;
  int cardRow = 0;
  int cardCol = 0;
  Offset loginOffset = Offset.zero;
  Offset menuOffset = Offset.zero;
  bool connection = false;
  bool reload = false;

  final controllerText = TextEditingController();
  FocusNode textStatus = FocusNode();

  @override
  void dispose() {
    controllerText.dispose();
    super.dispose();
  }

  void saveUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', controllerText.text);
    await prefs.setInt('bestMoves', bestMoves);
    await prefs.setInt('bestTime', bestTime);
    await prefs.setInt('totalPairs', totalPairs);
    
    final String? tempname= prefs.getString('username');
    final int? tempM = prefs.getInt('bestMoves');
    final int? tempT = prefs.getInt('bestTime');
    final int? tempP = prefs.getInt('totalPairs');
    username = data['username'] = tempname;
    bestMoves = data['bestMoves'] = tempM ?? 0;
    bestTime = data['bestTime'] = tempT ?? 0;
    totalPairs = data['totalPairs'] = tempP ?? 0;
    // debugPrint('Data Created: $username | $totalPairs | $bestMoves | $bestTime');
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('bestMoves');
    await prefs.remove('bestTime');
    await prefs.remove('totalPairs');
    username = data['username'] = "";
    bestMoves = data['bestMoves'] = 0;
    bestTime = data['bestTime'] = 0;
    totalPairs = data['totalPairs'] = 0;
    // final String? username= prefs.getString('username');
    // debugPrint('Data Removed');
    
  }

  Future <void> saveData() async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', '$username');
      await prefs.setInt('bestMoves', bestMoves);
      await prefs.setInt('bestTime', bestTime);
      await prefs.setInt('totalPairs', totalPairs);
      // debugPrint('Data Updated: $username | $totalPairs | $bestMoves | $bestTime');
    }


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

    //change online scoreboard button icon depending if the device is connected to the internet.
    AssetImage scoreboardAccess(){
      if(data['connection'] == true){
        return const AssetImage('assets/images/main_btn/scoreboard.png');
      } else {
        return const AssetImage('assets/images/main_btn/scoreboard-disable.png');
      }
    }

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
            //================= Login Pannel =================
            AnimatedSlide(
              offset: loginOffset,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: BgPannel(
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 450,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/labels/title1.png', fit: BoxFit.fitWidth,),
                      Image.asset('assets/images/labels/title2.png', width: 150),
                      
                      const SizedBox(height: 100,),
                            
                      Container(
                        padding: const EdgeInsets.only(left: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                
                            Expanded(
                              child: TextField(
                                controller: controllerText,
                                focusNode: textStatus,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  filled: true,
                                  //enabled: textStatus,
                                  fillColor: Color.fromRGBO(27, 4, 49, 1),
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  isDense: true,
                                  label: Text('USERNAME:', style: TextStyle(color: Colors.white70, letterSpacing: 1, fontSize: 12),),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Colors.black)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Colors.white)
                                  ),
                                  
                                  contentPadding: EdgeInsets.all(10),
                                ),
                                autocorrect: false,
                              ),
                            ),
                            
                            const SizedBox(width: 10,),

                            GestureDetector(
                              onTap: (){
                                if(controllerText.text != ''){
                                  setState(() {
                                    textStatus.unfocus();
                                    saveUser();
                                  });
                          
                                  Future.delayed( const Duration(milliseconds: 200), (){
                                    setState(() {
                                      data['loginOffset'] = loginOffset = const Offset(-1.0, 0.0);
                                      data['menuOffset'] = menuOffset = Offset.zero;
                                    });
                                  });
                                } else {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Please 🥺'),
                                        content: const Text('Enter a unique username'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: RotatedBox(quarterTurns: 2, child: Image.asset('assets/images/icon_btn/back.png', fit: BoxFit.fill, height: 50, width: 50,)),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //================= Menu Pannel =================
            AnimatedSlide(
              offset: menuOffset,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: BgPannel(
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 450,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40,),
                      Image.asset('assets/images/labels/title1.png', fit: BoxFit.fitWidth,),
                      Image.asset('assets/images/labels/title2.png', width: 150),
                      
                      const SizedBox(height: 10,),
                      Text('Hello $username'),
                      Text('Best Score: $totalPairs pairs | $bestMoves moves'),
                      // Text('Best Score: $totalPairs pairs | $bestMoves moves | ${bestTime!=0 ? (bestTime/1000).toStringAsFixed(2) : 0}sec'),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlipBtn(
                              imageFile: const AssetImage('assets/images/main_btn/play.png'),
                              onFlip: (){
                                Future.delayed( const Duration(milliseconds: 200),(){
                                  startgame(context);
                                });
                              },
                            ),
                            
                            const SizedBox(height: 5,),
                            
                            FlipBtn(
                              imageFile: scoreboardAccess(),
                              onFlip: (){
                                if (data['internetStatus'] == false) {
                                  Future.delayed( const Duration(milliseconds: 200),(){
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('No connection 🥹'),
                                          content: const Text('Restart the app with internet on...'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  });
                                } else {
                                  Future.delayed( const Duration(milliseconds: 200),(){
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Future feature 😱'),
                                          content: const Text('Comming Soon...'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  });
                                  //Navigator.pushNamed(context, './leaderboard');
                                }
                              },
                            ),
                        
                            const SizedBox(height: 5,),
            
                            FlipBtn(
                              imageFile: const AssetImage('assets/images/main_btn/exit.png'),
                              onFlip: (){
                                Future.delayed( const Duration(milliseconds: 200),() {
                                  setState(() {
                                    data['loginOffset'] = loginOffset = Offset.zero;
                                    data['menuOffset'] = menuOffset = const Offset(1.0, 0.0);
                                  });
                                  removeUser();
                                });
                              }
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30,),
                    ],
                  ),
                ),
              ),
            ),
          ]
        )
      )
    );
  }

  Future<void> startgame(BuildContext context) async{
    final result = await Navigator.pushNamed(context, './game', 
      arguments: {
        'loginOffset': loginOffset,
        'menuOffset': menuOffset,
        'cardRow': cardRow,
        'cardCol': cardCol,
        'username': username,
        'bestMoves': bestMoves,
        'totalPairs': totalPairs,
        'bestTime': bestTime,
        'connection': connection,
        'reload': false,
      }
    ) as Map;
    
    if (!mounted) return;
    
    if (result['reload']){
      startgame(context);
    } else {
      setState(() {
        loginOffset = data['loginOffset'] = result['loginOffset'];
        menuOffset = data['menuOffset'] = result['menuOffset'];
        cardRow = data['cardRow'] = result['cardRow'];
        cardCol = data['cardCol'] = result['cardCol'];
        connection = data['connection'] = result['connection'];
        reload = data['reload'] = result['reload'];
        username = data['username'] = result['username'];
        bestMoves = data['bestMoves'] = result['bestMoves'];
        totalPairs = data['totalPairs'] = result['totalPairs'];
        bestTime = data['bestTime'] = result['bestTime'];
        
        saveData();
      });
    }

    // ScaffoldMessenger.of(context)
    // ..removeCurrentSnackBar()
    // ..showSnackBar(SnackBar(content: Text('$result')));
  }
}