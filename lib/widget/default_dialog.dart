import 'package:bcg_idea/model/item_state.dart';
import 'package:bcg_idea/model/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showDeleteConfirmationDialog(BuildContext currentContext, int index, VoidCallback onDeleteStarted, {bool isFromDetail = false}) async {
  return showDialog<void>(
    context: currentContext,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Delete this Idea?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
              currentContext.read<LoadingState>().toggleFinish(0);
              Future.delayed(Duration(seconds: 2), () {
                onDeleteStarted();
                currentContext.read<LoadingState>().toggleFinish(1);
                currentContext.read<ItemState>().resetIndex();
                showNotification(currentContext, "Idea deleted");
                if(!isFromDetail) return;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pop(currentContext);
                });
              });
            },
          ),
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


void showNotification(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
