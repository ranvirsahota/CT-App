import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_app/models/game_search.dart';
import 'package:ct_app/models/image_to_guess.dart';
import 'package:ct_app/models/message.dart';
import 'package:ct_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../../../shared/fixed_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  late ScrollController _controller;
  ImageToGuess? imageToGuess;
  String role = "empty";
  final formKey = GlobalKey<FormState>();
  var inputField = TextEditingController();
  @override
  void initState() {
    super.initState();
    //called upon when the widget has completed building
   // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      widget.databaseService?.removeUserFromQueue(widget.docRefs!, widget.username!, widget.games[0].game);
    //});
    _controller = ScrollController();
        //print(">>>>>>>>>>>>>>>>>>>>>>> ${widget.games[0].game}");
   setGuessedImage();
  }

  Future<void> setGuessedImage() async {

    String? uid = widget.databaseService?.uid;

   var userData = await widget.databaseService?.userCollection.doc(uid).get();
   var userMap = userData?.data() as Map<String, dynamic>;
   //print("*********************USER DATA GRAB IN Guess The Image${userData?.data() as Map<String, dynamic>}");

    await Future.delayed(const Duration(seconds: 2),() async =>{
    await widget.databaseService?.updateImageModelTo().then((value)=>{
      imageToGuess = value,
      role = userMap['role'],
    }),
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      widget.databaseService?.removeGame(role);
      return true;
      },
    child: Scaffold (
        appBar: AppBar (
          title: const Text('Guess the image'),
        ),
        body: SingleChildScrollView(
          child: Column (
            children: [
              Center(
                child: CircularCountDownTimer (
                  duration: widget.timer,
                  initialDuration: 0,
                  controller: CountDownController(),
                  width: 50,
                  height: 50,
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
               if (role == "describer")
                 imageToGuess==null? const SizedBox(): CachedNetworkImage(
                     imageUrl: imageToGuess!.url!, height: 300, width: 500,

              ),
              Container(
                height: 400,

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
                        controller: _controller,

                        itemBuilder: (BuildContext context, int index) {
                          if(role == "describer" && messages[index].text == imageToGuess!.noun){

                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your teamate has correctly guessed the image"),));
                          }
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

            ],
          ),
        ),
      bottomSheet:  Container(
        height:130,
        width: double.infinity,
        child: Column (
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Form (
                key: formKey,
                child: TextFormField (
                  decoration: textFormFieldDecoration.copyWith(hintText: "type something"),
                  controller: inputField,
                  validator: (val) {
                    if (val.toString().toLowerCase() == imageToGuess?.noun) {
                      if (role == "describer") {
                        //"cant input the noun must describe";
                      }
                    }
                  },
                  onChanged: (val) {
                    setState (() =>  message = Message(text: val, text_from: "user", messageId: "messageId", created_at: FieldValue.serverTimestamp()));
                  },
                )
            ),
            const SizedBox(width: 12,),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                //send message
                if (role == "guesser" && inputField.text == imageToGuess?.noun) {
                  //send value to game
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your teamate has correctly guessed the image"),));
                  Navigator.of(context).pop();
                }
                widget.databaseService?.sendMessage(message);
                scrollDown();
              },
            ),
          ],
        ),
      ),
    ),
  );


  void scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() async{
    //widget.databaseService?.removeGame();
    FirebaseFirestore.instance.clearPersistence();
    super.dispose();
  }
}
