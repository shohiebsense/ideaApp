import 'dart:ui';

import 'package:bcg_idea/model/idea.dart';
import 'package:bcg_idea/model/item_state.dart';
import 'package:bcg_idea/model/loading_state.dart';
import 'package:bcg_idea/service/idea_navigation.dart';
import 'package:bcg_idea/service/idea_repository.dart';
import 'package:bcg_idea/widget/default_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class IdeaWidget extends StatefulWidget {
  Idea idea;
  int index;
  Function onDeleted;

  IdeaWidget({this.idea, this.index, this.onDeleted});

  @override
  _IdeaWidgetState createState() => _IdeaWidgetState();
}

class _IdeaWidgetState extends State<IdeaWidget> {

  bool _isBlurEnabled = false;
  double sigmaX = 0;
  double sigmaY = 0;

  void onDeleteStarted() {
    setState(() {
      bool _isBlurEnabled = true;
      sigmaY = 7;
      sigmaX = 7;
    });
    deleteIdea(context, this.widget.index);
    if (this.widget.onDeleted != null) {
      this.widget.onDeleted(this.widget.index);
    }
    setState(() {
      bool _isBlurEnabled = false;
      sigmaY = 0;
      sigmaX = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      color: Colors.black87,
      enabled: _isBlurEnabled || this.widget.index == -1,
      child: InkWell(
        onLongPress: () {
          Provider.of<ItemState>(context, listen: false)
              .updateSelectedIndex(this.widget.index);
          print(
              "on long pressed ${Provider.of<ItemState>(context, listen: false).currentIndex}");
        },
        onTap: () {
          if (Provider.of<ItemState>(context, listen: false)
              .isCurrentlySelected()) {
            Provider.of<ItemState>(context, listen: false).resetIndex();
            return;
          }
          setState(() {
            _isBlurEnabled = true;
            sigmaX = 7;
            sigmaY = 7;
          });
          Provider.of<LoadingState>(context, listen: false).toggleFinish(0);
          Future.delayed(Duration(milliseconds: 1500), () {
            setState(() {
              _isBlurEnabled = false;
              sigmaY = 0;
              sigmaX = 0;
            });
            Provider.of<LoadingState>(context, listen: false).toggleFinish(1);
            Navigator.of(context).push(
                navigateToDetailPage(idea: widget.idea, index: widget.index));
          });
        },
        child: ClipRRect(
          child: Container(
            height: 150,
            width: 150,
            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              '${widget.idea.title}',
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: sigmaX > 0 ? FontWeight.w200 : FontWeight.w500,
                                fontSize: 18,
                                //fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Provider.of<ItemState>(context, listen: false)
                                  .isItemSelected(this.widget.index)
                              ? InkWell(
                                  onTap: () {
                                    showDeleteConfirmationDialog(context,
                                        this.widget.index, onDeleteStarted);
                                  },
                                  child: Icon(Icons.delete_outline))
                              : Container(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2, top: 4),
                        child: Text(
                          '${widget.idea.body}',
                          maxLines: 9,
                          style: TextStyle(fontSize: 14,
                            fontWeight:  sigmaX > 0 ? FontWeight.w200 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(this.widget.idea.id == -1 ? '' :
                    'id: ${widget.idea.id}',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      this.widget.idea.date,
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                //Image.asset('assets/images/bell-small.png'),
              ],
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: Provider.of<ItemState>(context, listen: false)
                    .isItemSelected(this.widget.index)
                    ? [0.5, 0.5] : [0.015, 0.015],
                colors: Provider.of<ItemState>(context, listen: false)
                        .isItemSelected(this.widget.index)
                    ? [Colors.grey[400], Colors.grey[400]]
                    : [sideColorList[this.widget.index % 5], Colors.white],
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 1.0,
                  spreadRadius: 1.0,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
