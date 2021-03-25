import 'dart:math';

import 'package:bcg_idea/model/idea.dart';
import 'package:bcg_idea/model/loading_state.dart';
import 'package:bcg_idea/service/idea_repository.dart';
import 'package:bcg_idea/widget/default_appbar.dart';
import 'package:bcg_idea/widget/default_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IdeaDetailPage extends StatefulWidget {
  int index = -1;
  Idea idea;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  IdeaDetailPage({this.idea, this.index});

  @override
  _IdeaDetailPageState createState() => _IdeaDetailPageState();
}

class _IdeaDetailPageState extends State<IdeaDetailPage> {
  TextEditingController bodyTextController;
  TextEditingController titleTextController;
  String currentCountHelperBodyText = "";
  String currentCountTitleText = "";
  int currentBodyTextLength = 0;
  int randomColorIndex = Random().nextInt(5);

  @override
  void initState() {
    super.initState();
    bodyTextController = TextEditingController(text: widget.idea.body);
    titleTextController = TextEditingController(text: widget.idea.title);
  }

  void onLoaded() {}

  final Stream<Idea> _idea = (() async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield Idea();
    await Future<void>.delayed(const Duration(seconds: 1));
  })();

  _onTitleTextChanged(String value) {
    setState(() {
      if (value.length > 20) {
        currentCountTitleText = "${value.length}/35";
      } else {
        currentCountTitleText = "";
      }
    });
  }

  _onBodyTextChanged(String value) {
    setState(() {
      if (value.length > 125) {
        currentCountHelperBodyText = "${value.length}/150";
      } else {
        currentCountHelperBodyText = "";
      }
    });
  }

  bool isValid() {
    if(titleTextController.text.trim().isEmpty){
      showNotification(context, "Fill the title");
      return false;
    }
    if(bodyTextController.text.trim().isEmpty){
      showNotification(context, "Fill the body");
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    titleTextController.dispose();
    bodyTextController.dispose();
    super.dispose();
  }

  void onDeleteStarted() {
    setState(() {
      deleteIdea(context, this.widget.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: this.widget._scaffoldKey,
      appBar: getDefaultAppBar(
          title: this.widget.idea.title == null ? "New Idea" : null,
          context: context,
          onRemoveClicked: () {
            showDeleteConfirmationDialog(
                this.widget._scaffoldKey.currentContext,
                this.widget.index,
                onDeleteStarted,
                isFromDetail: true);
          }),
      body: StreamBuilder<Idea>(
          stream: _idea,
          builder: (context, snapshot) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: [0.015, 0.015],
                  colors: [sideColorList[randomColorIndex], Colors.white],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    autofocus: true,
                    controller: titleTextController,
                    cursorColor: Colors.black,
                    maxLength: 35,
                    onChanged: _onTitleTextChanged,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lightbulb),
                      labelText: 'Title',
                      labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                      ),
                      helperText: currentCountTitleText,
                      helperStyle: TextStyle(color: Colors.red),
                      counterText: "",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Divider(),
                  TextFormField(
                    controller: bodyTextController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Describe your idea!',
                      counterText: "",
                      helperText: currentCountHelperBodyText,
                      helperStyle: TextStyle(color: Colors.red),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLength: 150,
                    minLines: 2,
                    maxLines: 5,
                    onChanged: _onBodyTextChanged,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("ID: ${this.widget.idea.id}"),
                      Text("Date: ${this.widget.idea.date}"),
                    ],
                  )
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isValid()) {
            context.read<LoadingState>().toggleFinish(0);
            Future.delayed(Duration(seconds: 2), () {
              this.widget.idea.title = titleTextController.text;
              this.widget.idea.body = bodyTextController.text;
              updateIdea(this.widget.index, this.widget.idea);
              context.read<LoadingState>().toggleFinish(1);
              showNotification(this.widget._scaffoldKey.currentContext, "Idea Added/Updated");
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(this.widget._scaffoldKey.currentContext);
              });
            });
          }
        },
        backgroundColor: Colors.black,
        tooltip: 'Save',
        child: Icon(Icons.check),
      ), // This trailing comma makes auto-f,
    );
  }
}
