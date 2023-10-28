import 'package:dumdumcard/pages/common/bg_pannel.dart';
import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map;
    int hs = data['highscore'];
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 100,bottom: 20),
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
            const BgPannel(
              height: double.infinity,
              child: Text("ne"),
            ),

            Container(
              child: IconButton(
                icon: Image.asset('assets/images/icon_btn/close.png'),
                onPressed: () {
                  hs = data['highscore']+=2;

                  Navigator.pop(context, hs);
                },
              )
            ),

          ],
        ),
      ),
    );
  }
}