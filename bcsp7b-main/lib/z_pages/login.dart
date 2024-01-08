import 'package:flutter/material.dart';
import 'package:flutter_bcsp7b/blocs/login_bloc.dart';
import 'package:flutter_bcsp7b/services/authentication.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(AuthenticationService());
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          child: Icon(
            Icons.account_circle,
            size: 88.0,
            color: Colors.white,
          ),
          preferredSize: Size.fromHeight(40.0),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBuilder(
                stream: _loginBloc.email,
                builder: (BuildContext context, AsyncSnapshot snapshot) =>
                    TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    icon: Icon(Icons.mail_outline),
                    errorText: snapshot.error?.toString(),
                  ),
                  onChanged: _loginBloc.emailChanged.add,
                ),
              ),
              StreamBuilder(
                stream: _loginBloc.password,
                builder: (BuildContext context, AsyncSnapshot snapshot) =>
                    TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.security),
                    errorText: snapshot.error?.toString(),
                  ),
                  onChanged: _loginBloc.passwordChanged.add,
                ),
              ),
              SizedBox(height: 48.0),
              _buildLoginAndCreateButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginAndCreateButtons() {
    return StreamBuilder(
      initialData: 'Login',
      stream: _loginBloc.loginOrCreateButton,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == 'Login') {
          return _buttonsLogin();
        } else if (snapshot.data == 'Create Account') {
          return _buttonsCreateAccount();
        }

        // Add a return statement to handle the case when snapshot.data is neither 'Login' nor 'Create Account'.
        return Container(); // You can replace this with any Widget or null based on your logic.
      },
    );
  }

  Column _buttonsLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StreamBuilder(
          initialData: false,
          stream: _loginBloc.enableLoginCreateButton,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.lightGreen.shade200, elevation: 16.0,
                  // disabledPrimary: Colors.grey.shade100,
                ),
                child: Text('Login'),
                onPressed: snapshot.data
                    ? () => _loginBloc.loginOrCreateChanged.add('Login')
                    : null,
              ),
        ),
        TextButton(
          child: Text('Create Account'),
          onPressed: () {
            _loginBloc.loginOrCreateButtonChanged.add('Create Account');
          },
        ),
      ],
    );
  }

  Column _buttonsCreateAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StreamBuilder(
          initialData: false,
          stream: _loginBloc.enableLoginCreateButton,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.lightGreen.shade200, elevation: 16.0,
                  // disabledPrimary: Colors.grey.shade100,
                ),
                child: Text('Create Account'),
                onPressed: snapshot.data
                    ? () =>
                        _loginBloc.loginOrCreateChanged.add('Create Account')
                    : null,
              ),
        ),
        TextButton(
          child: Text('Login'),
          onPressed: () {
            _loginBloc.loginOrCreateButtonChanged.add('Login');
          },
        ),
      ],
    );
  }
}
