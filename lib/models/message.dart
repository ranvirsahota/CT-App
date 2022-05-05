class Message {
  final String text;
  final String text_from;
  final String messageId;
  final dynamic created_at;

  const Message ({required this.text, required this.text_from, required this.messageId, required this.created_at});

  factory Message.fromJson(Map<String, dynamic> json){
    return Message(text: json["text"], text_from: json["text_from"], messageId: json["messageId"], created_at: json["created_at"]);
  }

  //converting Message to map
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["text"] = text;
    json["text_from"] = text_from;
    json['messageId'] = messageId;
    json["created_at"] = created_at;
    return json;
  }
}

