
import 'package:bcg_idea/idea_detail_page.dart';
import 'package:bcg_idea/model/idea.dart';
import 'package:flutter/material.dart';



Route navigateToDetailPage({Idea idea, int index}){
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => IdeaDetailPage(idea: idea, index: index),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;

      var curve = Curves.ease;
      var curveTween = CurveTween(curve: curve);

      var tween = Tween(begin: begin, end: end).chain(curveTween);
      var offsetAnimation = animation.drive(tween);

      return  SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

