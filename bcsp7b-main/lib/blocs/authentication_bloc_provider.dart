import 'package:flutter/material.dart';
import 'package:flutter_bcsp7b/blocs/authentication_bloc.dart';

class AuthenticationBlocProvider extends InheritedWidget {
  final AuthenticationBloc authenticationBloc;

  const AuthenticationBlocProvider(
      {required Key key, required Widget child, required this.authenticationBloc})
      : super(key: key, child: child);

  static AuthenticationBlocProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<AuthenticationBlocProvider>()
        as AuthenticationBlocProvider);
  }

  @override
  bool updateShouldNotify(AuthenticationBlocProvider old) => authenticationBloc != old.authenticationBloc;
}