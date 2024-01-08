import 'package:flutter/material.dart';
import 'package:flutter_bcsp7b/blocs/home_bloc.dart';


class HomeBlocProvider extends InheritedWidget {
  final HomeBloc homeBloc;
  final String uid;

  const HomeBlocProvider(
      {required Key key, required Widget child, required this.homeBloc, required this.uid})
      : super(key: key, child: child);

  static HomeBlocProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<HomeBlocProvider>() as HomeBlocProvider);
  }

  @override
  bool updateShouldNotify(HomeBlocProvider old) => homeBloc != old.homeBloc;
}