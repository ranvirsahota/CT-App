class Message {
  final String text;
  final String text_from;
  final String messageId;


  const Message ({required this.text, required this.text_from,
    required this.messageId});

  factory Message.fromJson(Map<String, dynamic> json){
    return Message(text: json["text"], text_from: json["text_from"], messageId: json["messageId"]);
  }

  //converting Message to map
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["text"] = text;
    json["text_from"] = text_from;
    json['messageId'] = messageId;
    return json;
  }
}

