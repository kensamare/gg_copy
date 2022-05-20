class SgNested {
  SgNested._();

  static SgNested instance = SgNested._();
  
  static int _id = 1; //some variables
  
  int get id => _id;

  set id(int newId) => _id = newId;
}