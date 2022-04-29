import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class GuessTheWord extends StatefulWidget {
  final int timer;
  const GuessTheWord({Key? key, required this.timer}) : super(key: key);

  @override
  State<GuessTheWord> createState() => _GuessTheWordState();
}

class _GuessTheWordState extends State<GuessTheWord> {

  @override
  Widget build(BuildContext context) => Scaffold (
    appBar: AppBar (
      title: const Text('Guess the word'),
    ),
    body:
      Center(
        child: CircularCountDownTimer(
          duration: widget.timer,
          initialDuration: 0,
          controller: CountDownController(),
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
          ringColor: Colors.grey[300]!,
          ringGradient: null,
          fillColor: Colors.purpleAccent[100]!,
          fillGradient: null,
          backgroundColor: Colors.purple[500],
          backgroundGradient: null,
          strokeWidth: 20.0,
          strokeCap: StrokeCap.round,
          textStyle: const TextStyle(fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold),
          textFormat: CountdownTextFormat.S,
          isReverse: true,
          isReverseAnimation: true,
          isTimerTextShown: true,
          autoStart: true,
          onStart: () {
            debugPrint('Countdown Started');
          },
          onComplete: () {
            debugPrint('Countdown Ended');
          },
        ),
      )
  );
}
