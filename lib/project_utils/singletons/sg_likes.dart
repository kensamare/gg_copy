class SgLikes {
  SgLikes._();

  static SgLikes instance = SgLikes._();

  static List<String> _likes = []; //some variables

  List<String> get likes => _likes;

  set likes(List<String> lst) => _likes = lst;

  static List<String> _unlikes = []; //some variables

  List<String> get unlikes => _unlikes;

  set unfollows(List<String> lst) => _unlikes = lst;
}