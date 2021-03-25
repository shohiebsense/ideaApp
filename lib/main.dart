
import 'package:bcg_idea/model/idea.dart';
import 'package:bcg_idea/model/item_state.dart';
import 'package:bcg_idea/model/loading_state.dart';
import 'package:bcg_idea/service/idea_navigation.dart';
import 'package:bcg_idea/service/idea_repository.dart';
import 'package:bcg_idea/widget/default_appbar.dart';
import 'package:bcg_idea/widget/idea_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LoadingState()),
    ChangeNotifierProvider(create: (_) => ItemState()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Idea App',
      theme: ThemeData(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool isLoading = true;
  Future<List<Idea>> fetchIdeaFuture;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    fetchIdeaFuture = Future.delayed(Duration(seconds: 3), () {
      context.read<LoadingState>().toggleFinish(0);
      return fetchIdeas(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (context.watch<ItemState>().isCurrentlySelected()) {
          context.read<ItemState>().resetIndex();
          return Future.value(false);
        }
        Navigator.pop(context);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: getDefaultAppBar(
            context: context,
            onRemoveClicked: null,
            onActionClicked: (String sortBy) {
              switch (sortBy) {
                case 'Sort by Title':
                  setState(() {
                    sortByTitle();
                  });
                  break;
                case 'Newest':
                  setState(() {
                    sortByNewestDate();
                  });
                  break;
                case 'Sort by Id':
                  setState(() {
                    sortById();
                  });
                  break;
                case 'Oldest':
                  setState(() {
                    sortByDate();
                  });
                  break;
                case 'Default':
                  setState(() {
                    sortDefault();
                  });
                  break;
              }
            }),
        body: FutureBuilder<List<Idea>>(
            future: fetchIdeaFuture,
            builder:
                (BuildContext context, AsyncSnapshot<List<Idea>> snapshot) {
              if (snapshot.hasData) {
                return Scrollbar(
                  isAlwaysShown: false,

                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    key: listKey,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          columnCount: 2,
                          child: ScaleAnimation(
                              child: FadeInAnimation(
                                  child: IdeaWidget(
                            idea: snapshot.data[index],
                            index: index,
                            onDeleted: (int index) {
                              AnimatedListRemovedItemBuilder builder =
                                  (context, animation) {
                                // A method to build the Card widget.
                                return SizeTransition(
                                  sizeFactor: animation,
                                  child: Container(
                                      height: 150,
                                      width: 150,
                                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      padding: EdgeInsets.all(5)),
                                );
                              };
                              if (listKey.currentState != null) {
                                print("is there??");
                                listKey.currentState.removeItem(index, builder);
                              }
                            },
                          ))));
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('error ${snapshot.error.toString()}');
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  if (index < 3) {
                    return IdeaWidget(
                      idea: Idea.dummy(),
                      index: -1,
                      onDeleted: null,
                    );
                  }
                  return Container();
                },
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Idea idea = await getNewIdea(context);
            print("Clicked");
            // final isModified = await Navigator.push(context, navigateToDetailPage(idea));
            Navigator.of(context)
                .push(navigateToDetailPage(idea: idea, index: ideaList.length));
          },
          backgroundColor: Colors.black,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
