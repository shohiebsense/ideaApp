
class Idea {
  final int id;
  String _date = "";
  String title = "";
  String body = "";


  Idea.dummy() : id = -1;

  Idea({this.id, String date, this.title, this.body}) : _date = date;


  String get date  {
    String formattedDate = "";
    if(_date == null || _date.isEmpty){
      var now = new DateTime.now();
      formattedDate = now.toString().split(" ")[0];
    }
    else if(_date.contains("T")){
      formattedDate = _date.split("T")[0];
    }
    else if(_date.contains(" ")){
      formattedDate = _date.split(" ")[0];
    }
    return formattedDate;
  }

  factory Idea.fromJson(Map<String, dynamic> json){
    return Idea(
      id: json['id'] as int,
      date: json['created_date'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  toJSONEncodable() {
    Map<String, dynamic> map = new Map();

    map['id'] = id;
    map['created_date'] = date;
    map['title'] = title;
    map['body'] = body;

    return map;
  }

}