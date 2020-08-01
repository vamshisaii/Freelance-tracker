import 'package:ui_practice/sign_in/validators.dart';

enum EmailSignInformType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators{
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInformType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  final String email;
  final String password;
  final EmailSignInformType formType;
  final bool isLoading;
  final bool submitted;

  String get primaryButtonText{
    return formType == EmailSignInformType.signIn
        ? 'Sign in'
        : 'Create Account';
  }
  String get secondaryButtonText{
    return formType == EmailSignInformType.signIn
        ? 'New User? Register'
        : 'Have account? Sign in';
  }
  bool get canSubmit{
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password);
  }
  String get passwordErrorText{
       bool emailValid = submitted && !emailValidator.isValid(password);
       return emailValid?invalidPasswordErrorText:null;

  }
  String get emailErrorText{
    bool passwordValid =
        submitted && !passwordValidator.isValid(email);
        return passwordValid?invalidEmailErrorText:null;
  }

  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSignInformType formType,
    bool isLoading,
    bool submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}
