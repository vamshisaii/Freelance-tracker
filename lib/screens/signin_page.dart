import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_practice/models/emailSignInModel.dart';
import 'package:ui_practice/blocs/signin_bloc.dart';

import 'package:ui_practice/custom_widgets/custom_decorations.dart';
import 'package:ui_practice/custom_widgets/custom_raisedbutton.dart';

import 'package:ui_practice/services/auth.dart';


class Signin_page extends StatefulWidget  {
  Signin_page({@required this.bloc});
  final SignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Provider<SignInBloc>( 
      create: (_) => SignInBloc(auth: auth),
      dispose: (context, bloc) => bloc.dispose(),
      child: Consumer<SignInBloc>(
          builder: (context, bloc, _) => Signin_page(
                bloc: bloc,
              )),
    );
  }

  @override
  _Signin_pageState createState() => _Signin_pageState();
}

class _Signin_pageState extends State<Signin_page> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

 

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

 
  Future<void> _signinWithGoogle() async {
    try {
      widget.bloc.signInByGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> submit() async {
    try {
      await widget.bloc.submit();
    } catch (e) {
      print(e.toString());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Sign in failed'),
              content: Text(e.toString()),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ok'))
              ],
            );
          });
    }
  }

  void _toggleFormType() {
   widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data;
          return Scaffold(
              backgroundColor: Colors.white, body: _buildChildren(model));
        });
  }

  StreamBuilder<bool> _buildChildren(EmailSignInModel model) {
    return StreamBuilder<bool>(
        stream: widget.bloc.isLoadingStream,
        initialData: false,
        builder: (context, snapshot) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //  crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildHeader(snapshot.data),
                  SizedBox(
                    height: 50,
                  ),
                  _buildEmailTextField(model),
                  SizedBox(
                    height: 10,
                  ),
                  _buildPasswordTextField(model),
                  SizedBox(
                    height: 10,
                  ),
                  CustomRaisedButton(
                    text: model.primaryButtonText,
                    onPressed: model.canSubmit ? submit : null,
                    color: Colors.blueGrey[900],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            _toggleFormType();
                          },
                          child: Text(model.secondaryButtonText))
                    ],
                  ),
                  Text("or"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          icon: Image.asset('images/google.png'),
                          onPressed: () {
                            _signinWithGoogle();
                          }),
                      SizedBox(
                        width: 20,
                      ),
                      IconButton(
                          icon: Image.asset('images/facebook.png'),
                          onPressed: () {
                          }),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Center _buildHeader(bool isLoading) {
    if (isLoading) return Center(child: CircularProgressIndicator());
    return Center(
        child: Text("Sign-in",
            style: TextStyle(color: Colors.black87, fontSize: 35)));
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      decoration: textfielddecoration.copyWith(
          errorText: model.emailErrorText),
      controller: _emailController,
      focusNode: _emailFocusNode,
      onEditingComplete: _emailEditingComplete,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged:(email)=> widget.bloc.updateWith(email:email),
    );
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    
    return TextField(
      obscureText: true,
      focusNode: _passwordFocusNode,
      onEditingComplete: submit,
      onChanged: (password) =>widget.bloc.updateWith(password:password),
      controller: _passwordController,
      textInputAction: TextInputAction.done,
      decoration: textfielddecoration.copyWith(
          labelText: 'Enter password',
          errorText:model.passwordErrorText),
    );
  }
}
