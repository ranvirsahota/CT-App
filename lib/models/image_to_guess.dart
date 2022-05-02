class ImageToGuess {

  String? noun;
  String? url;

  ImageToGuess({required this.noun, required this.url});

  factory ImageToGuess.fromJson(Map<String, dynamic> json){
    return ImageToGuess(noun: json["noun"], url: json["url"]);
  }

  //converting ImageToGuess to map
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["noun"] = noun;
    json["url"] = url;
    return json;
  }}