class GameSearch{
  String? username;
  String? game;

  GameSearch({required this.game, required this.username});

  factory GameSearch.fromJson(Map<String, dynamic> json){
    return GameSearch(username: json["username"], game: json["game"]);
  }

  //converting GameSearch to map
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["username"] = username;
    json["game"] = game;
    return json;
  }
}