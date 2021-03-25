import 'dart:ui';

import 'package:bcg_idea/model/idea.dart';
import 'package:bcg_idea/model/item_state.dart';
import 'package:bcg_idea/model/loading_state.dart';
import 'package:bcg_idea/service/idea_navigation.dart';
import 'package:bcg_idea/service/idea_repository.dart';
import 'package:bcg_idea/widget/default_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IdeaWidget extends StatefulWidget {
  Idea idea;
  int index;
  Function onDeleted;

  IdeaWidget({this.idea, this.index, this.onDeleted});

  @override
  _IdeaWidgetState createState() => _IdeaWidgetState();
}

class _IdeaWidgetState extends State<IdeaWidget> {



  double sigmaX = 0;
  double sigmaY = 0;

  void onDeleteStarted() {
    setState(() {
      sigmaY = 7;
      sigmaX = 7;
    });
    deleteIdea(context, this.widget.index);
    if (this.widget.onDeleted != null) {
      this.widget.onDeleted(this.widget.index);
    }
    setState(() {
      sigmaY = 0;
      sigmaX = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
          sigmaX = 7;
          sigmaY = 7;
        });
        Provider.of<LoadingState>(context, listen: false).toggleFinish(0);
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            sigmaY = 0;
            sigmaX = 0;
          });
          Provider.of<LoadingState>(context, listen: false).toggleFinish(1);
          Navigator.of(context).push(
              navigateToDetailPage(idea: widget.idea, index: widget.index));
        });
      },
      child: ClipRRect(
        child: BackdropFilter(
          filter: this.widget.idea.id == -1
              ? ImageFilter.blur(sigmaX: 5, sigmaY: 5)
              : ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
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
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
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
                        child: Expanded(
                          child: Text(
                            '${widget.idea.body}',
                            style: TextStyle(fontSize: 14,
                              fontWeight:  sigmaX > 0 ? FontWeight.w200 : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackdropFilter(
                      filter: this.widget.idea.id == -1
                          ? ImageFilter.blur(sigmaX: 5, sigmaY: 5)
                          : ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
                      child: Text(this.widget.idea.id == -1 ? '' :
                      'id: ${widget.idea.id}',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
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
