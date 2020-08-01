abstract class StringValidator{
  bool isValid(String value);
}

class NonEmptyStringvalidator implements StringValidator{
  bool isValid(String value){
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidators{
  final StringValidator emailValidator =NonEmptyStringvalidator();
    final StringValidator passwordValidator =NonEmptyStringvalidator();

    final String invalidEmailErrorText='Email can\'t be empty';
    final String invalidPasswordErrorText='Password can\'t be empty'; 

}