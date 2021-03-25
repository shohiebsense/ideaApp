import 'dart:convert';
import 'dart:math';

import 'package:bcg_idea/model/idea.dart';
import 'package:bcg_idea/model/loading_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';


var client = http.Client();
final LocalStorage storage = new LocalStorage(KEY_IDEA_LIST);
List<Idea> ideaList = [];
List<Idea> newIdeaList = [];
const String KEY_IDEA_LIST = 'idea_list';
const String KEY_NEW_IDEA_LIST = 'new_idea_list';
int newestId = 101;

List<Color> sideColorList = [
  Colors.blue,
  Colors.yellow,
  Colors.red,
  Colors.amber,
  Colors.lightBlueAccent
];


Future<List<Idea>> fetchIdeas(BuildContext context) async {
  var items = storage.getItem(KEY_IDEA_LIST);
  ideaList.clear();

  if (items != null) {
    return parseIdeas(context, items);
   /* ideaList.addAll(list.map((e) => Idea.fromJson(e)).toList());
    return ideaList;*/
  }

  final response = await client.get(Uri.parse('https://mockend.com/shohiebsense/fakeApi/ideas'));
  print("fetching ideas");

  if(response.statusCode == 200){
    saveToStorage(KEY_IDEA_LIST, response.body);
    return parseIdeas(context, response.body);
  }
  else{
    throw Exception("Failed to load");
  }

}

List<Idea> parseIdeas(BuildContext context, String responseBody) {
  //final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  print("parsed ideas $responseBody");
  final result = jsonDecode(responseBody);
  Iterable list = result;
  ideaList.addAll(list.map((e) => Idea.fromJson(e)).toList());
  context.read<LoadingState>().toggleFinish(1);
  return ideaList;
}

Future<Idea> getNewIdea(BuildContext context) async {
  context.read<LoadingState>().toggleFinish(0);
  //int lastId = new Random().nextInt(999) + ideaList.last.id;
  var now = DateTime.now();

  //backend
  if(true){
    Idea idea = Idea(id: newestId, date: now.toString());
    newestId++;
    ideaList.insert(0, idea);
    context.read<LoadingState>().toggleFinish(1);
    return idea;
  }

  //throw(Exception('failed to add new Idea, pls try again'));
}

 updateIdea(int index, Idea idea) {
  /*if(index == -1){
    saveNewIdea(idea);
  }*/
}

void saveNewIdea(Idea idea) {
  ideaList.insert(0, idea);
}

void saveToStorage(String key, String responseBody) {
  storage.setItem(key, responseBody);
}

void deleteIdea(BuildContext context, int index){
  context.read<LoadingState>().toggleFinish(0);
  ideaList.removeAt(index);
}

void sortByTitle(){
  print("Sorted By Title");
  ideaList.sort((idea1,idea2) => idea1.title.compareTo(idea2.title));
}

void sortById(){
  ideaList.sort((idea1,idea2) => idea2.id.compareTo(idea1.id));
}

void sortByDate(){
  ideaList.sort((idea1,idea2) => idea1.date.compareTo(idea2.date));
}

void sortByNewestDate(){
  ideaList.sort((idea1,idea2) => idea2.date.compareTo(idea1.date));
}

/*void saveToStorage(String key, List<Idea> ideaList) {
  storage.setItem(key, toJsonEncodable(ideaList));
}*/

/*toJsonEncodable(List<Idea> ideaList) {
  return ideaList.map((idea) => {idea.toJSONEncodable()}).toList();
}*/
