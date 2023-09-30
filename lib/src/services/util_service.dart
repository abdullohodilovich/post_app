sealed class Util{
  static bool validateSignUp(String username,String email, String password, String prePassword){
    return username.isNotEmpty && emailRegExp.hasMatch(email) && password.length >= 8 && prePassword == password;
  }

  static bool validateSignIn(String email,String password){
    return emailRegExp.hasMatch(email) && password.length >= 8;
  }
}

final RegExp emailRegExp =RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");