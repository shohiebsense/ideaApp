import 'package:bcg_idea/service/idea_repository.dart';
import 'package:flutter/foundation.dart';

class ItemState with ChangeNotifier {
  int _currentIndex = -1;
  String _title = "Idea App";
  int get currentIndex => _currentIndex;
  String get title => _title;

  void updateSelectedIndex(int index){
    _currentIndex = index;
    _title = "Selected ID: ${ideaList[index].id}";
    notifyListeners();
  }



  bool isCurrentlySelected(){
    return _currentIndex >= 0;
  }

  bool isItemSelected(int index){
    return isCurrentlySelected() && index == _currentIndex;
  }

  void updateTitle(String title){
    _title = title;
    notifyListeners();
  }

  void resetIndex(){
    _currentIndex = -1;
    _title = "Idea App";
    notifyListeners();
  }

}