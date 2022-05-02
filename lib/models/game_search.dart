class GameSearch{
  String? username;
  String? game;

  GameSearch(this.game, this.username);

  factory GameSearch.fromJson(Map<String, dynamic> json){
    return GameSearch(json["username"], json["game"]);
  }

  //converting GameSearch to map
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["username"] = username;
    json["game"] = game;
    return json;
  }

}