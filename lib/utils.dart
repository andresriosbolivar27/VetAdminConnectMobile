class Utils{

  static bool isEmail(String email) {
    String stringRegex = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(stringRegex);
    return regExp.hasMatch(email);
  }


  static bool isSizePasswordValid(String password){
    return password.length>5;
  }

}