class UsrList {
  String userName = "", deptName = "";

  UsrList({required this.deptName, required this.userName});

  String get getUserName => userName;
  set setUserName(userName) => this.userName = userName;
  String get getDeptName => deptName;
  set setToken(deptName) => this.deptName = deptName;
}
