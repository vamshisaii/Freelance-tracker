import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:ui_practice/models/emailSignInModel.dart';
import 'package:ui_practice/services/auth.dart';

class SignInBloc {
  SignInBloc({@required this.auth});
  final AuthBase auth;

  //stream for loading in sign in
  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

// stream for email sign in and sign up

  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _isLoadingController.close();
    _modelController.close();
  }

  void setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      setIsLoading(false);
      rethrow;
    }
  }

  Future<User> signInByGoogle() async => await _signIn(auth.signInByGoogle);

//email sign in and up bloc

Future<void> submit() async {
  updateWith(submitted:true,isLoading:true);
    try {
      
      
      if (_model.formType == EmailSignInformType.signIn) {
        await auth.signInWithEmail(_model.email, _model.password);
      } else
        await auth.signUpWithEmail(_model.email, _model.password);
    } catch (e) {
      updateWith(submitted: false,isLoading:false);
      rethrow;
    } 

    
  }
void toggleFormType(){
  final formType= _model.formType == EmailSignInformType.signIn
          ? EmailSignInformType.register
          : EmailSignInformType.signIn;
   updateWith(
      email:'',
      password:'',
      submitted: false,
      formType:formType,
          isLoading: false,
    );
}
  void updateWith({
    String email,
    String password,
    EmailSignInformType formType,
    bool isLoading,
    bool submitted,
  }) {
    //update model

    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
    //add updated model to _modelController
    _modelController.add(_model); 
  }
}
