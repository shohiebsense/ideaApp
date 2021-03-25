import 'package:flutter/foundation.dart';

class LoadingState with ChangeNotifier {
  int _isFinished = 0;
  int get isFinished => _isFinished;

  void toggleFinish(int isFinished){
    _isFinished = isFinished;
    notifyListeners();
  }

}