import 'package:bcg_idea/model/item_state.dart';
import 'package:bcg_idea/model/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

AppBar getDefaultAppBar(
    {String title,
    BuildContext context,
    VoidCallback onRemoveClicked,
    Function onActionClicked}) {
  void handleClick(String value) {
    onActionClicked(value);
  }

  List<Widget> actionWidgetList = onRemoveClicked == null
      ? [
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Sort by Title', 'Newest', 'Sort by Id', 'Oldest', 'Default'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ]
      : title == null
          ? [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.delete),
                ),
                onTap: onRemoveClicked,
              ),
            ]
          : [];

  return AppBar(
    title: title == null ? Text(context.watch<ItemState>().title) : Text(title),
    bottom: context.watch<LoadingState>().isFinished == 0
        ? AppProgressIndicator()
        : null,
    actions: actionWidgetList,
    backgroundColor: Colors.black,
  );
}

class AppProgressIndicator extends LinearProgressIndicator
    implements PreferredSizeWidget {
  AppProgressIndicator(
      {Key key,
      double value,
      Color backgroundColor,
      Animation<Color> valueColor})
      : super(
            key: key,
            value: value,
            backgroundColor: backgroundColor,
            valueColor: valueColor);

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 6.0);
}
