class SgFollows {
  SgFollows._();

  static SgFollows instance = SgFollows._();
  
  static List<String> _follows = []; //some variables
  
  List<String> get follows => _follows;

  set follows(List<String> lst) => _follows = lst;

  static List<String> _unfollows = []; //some variables

  List<String> get unfollows => _unfollows;

  set unfollows(List<String> lst) => _unfollows = lst;
}