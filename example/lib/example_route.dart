// GENERATED CODE - DO NOT MODIFY MANUALLY
// **************************************************************************
// Auto generated by https://github.com/fluttercandies/ff_annotation_route
// **************************************************************************
// ignore_for_file: prefer_const_literals_to_create_immutables,unused_local_variable,unused_import
import 'package:example/pages/CodeTriggerTapFunctionDemo.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/widgets.dart';

import 'pages/like_button_demo.dart';
import 'pages/main_page.dart';

FFRouteSettings getRouteSettings({
  required String name,
  Map<String, dynamic>? arguments,
  PageBuilder? notFoundPageBuilder,
}) {
  final Map<String, dynamic> safeArguments =
      arguments ?? const <String, dynamic>{};
  switch (name) {
    case 'fluttercandies://CodeTriggerTapFunctionDemo':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        builder: () => const CodeTriggerTapFunctionDemo(),
        routeName: 'CodeTriggerTapFunctionDemo',
        description: 'show how to trigger Tap by code',
      );
    case 'fluttercandies://LikeButtonDemo':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        builder: () => LikeButtonDemo(),
        routeName: 'like button',
        description: 'show how to build like button',
      );
    case 'fluttercandies://mainpage':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        builder: () => MainPage(),
        routeName: 'MainPage',
      );
    default:
      return FFRouteSettings(
        name: FFRoute.notFoundName,
        routeName: FFRoute.notFoundRouteName,
        builder: notFoundPageBuilder ?? () => Container(),
      );
  }
}
