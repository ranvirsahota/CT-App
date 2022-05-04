import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_app/models/game_search.dart';
import 'package:ct_app/models/message.dart';
import 'package:ct_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

import '../../../shared/fixed_styles.dart';

class GuessTheWord extends StatefulWidget {
  final int timer;
  final List<GameSearch> games;
  final List<DocumentReference>? docRefs;
  final String? username;
  final DatabaseService? databaseService;

  const GuessTheWord(this.docRefs, this.username, this.databaseService,  {Key? key,
    required this.timer, required this.games}) : super(key: key);

  @override
  State<GuessTheWord> createState() => _GuessTheWordState();
}

class _GuessTheWordState extends State<GuessTheWord> {
  late Message message;

  @override
  void initState() {
    super.initState();
    //called upon when the widget has completed building
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      widget.databaseService?.removeUserFromQueue(widget.docRefs!, widget.username!, widget.games[0].game);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold (
      appBar: AppBar (
        title: const Text('Guess the image'),
      ),
      body: Column (
        children: [
          Center(
            child: CircularCountDownTimer (
              duration: widget.timer,
              initialDuration: 0,
              controller: CountDownController(),
              width: 30,
              height: 30,
              ringColor: Colors.grey[300]!,
              ringGradient: null,
              fillColor: Colors.purpleAccent[100]!,
              fillGradient: null,
              backgroundColor: Colors.purple[500],
              backgroundGradient: null,
              strokeWidth: 3.0,
              strokeCap: StrokeCap.round,
              textStyle: const TextStyle(
                  fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold
              ),
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
          ),
          Expanded(
            //listens to any changes made to the message
            child: StreamBuilder<List<Message>> (
              builder: (_, snapshot){
                if(!snapshot.hasData ||  snapshot.hasError) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if(snapshot.hasError) {
                  return Text("erro: ${snapshot.error}");
                }
                if(snapshot.requireData.isEmpty) {
                  return Text("No message at the momennt");
                }
                final messages = snapshot.requireData;
                return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card (
                        elevation: 8,
                        child: Padding (
                          padding: const EdgeInsets.all(12),
                          child: Text(messages[index].text),
                        ),
                      );
                    }
                );
              },
              stream: widget.databaseService!.fetchMessages(),
            ),
          ),
          Column (
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Form (
                  child: TextFormField (
                    decoration: textFormFieldDecoration.copyWith(hintText: "type something"),
                    validator: (val) => val!.isEmpty ? "Input something" : null,
                    onChanged: (val) {
                      setState (() =>  message = Message(text: val, text_from: "user", messageId: "messageId"));
                    },
                  )
              ),
              const SizedBox(width: 12,),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  //send message
                  widget.databaseService?.sendMessage(message);

                },
              ),
            ],
          ),
        ],
      )
  );

  @override
  void dispose() async{
    widget.databaseService?.removeGame();
    FirebaseFirestore.instance.clearPersistence();
    super.dispose();
  }
}
