class SgComments {
  SgComments._();

  static SgComments instance = SgComments._();
  static int _idReply = -1;
  static int _indexReply = -1;
  static String _nicknameReply = '';

  int get getIdReply => _idReply;
  int get getIndexReply => _indexReply;
  String get getNicknameReply => _nicknameReply;

  set setIdReply(int id) => _idReply = id;
  set setIndexReply(int index) => _indexReply = index;
  set setNicknameReply(String nickname) => _nicknameReply = nickname;


  void reset () {
    _idReply = -1;
    _indexReply = -1;
    _nicknameReply = '';
  }
}