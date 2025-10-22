class Login {
  String id = "";
  String username = "";
  String email = "";
  // List<String> roles = [];
  String tokenType = "";
  String accessToken = "";
  String deptName = "";
  String div = "";
  
  // Login() {}
  
  // Login(
  //     {String? id,
  //     String? username,
  //     String? email,
  //     List<String>? roles,
  //     String? tokenType,
  //     String? accessToken,
  //     String? deptName,
  //     String? div}) {
  //   _id = id!;
  //   _username = username!;
  //   _email = email!;
  //   _roles = roles!;
  //   _tokenType = tokenType!;
  //   _accessToken = accessToken!;
  //   _deptName = deptName!;
  //   _div = div!;
  // }
/*
  String get id => _id;

  set id(String id) => _id = id;

  String get username => _username;

  set username(String username) => _username = username;

  String get email => _email;

  set email(String email) => _email = email;

  List<String> get roles => _roles;
  set roles(List<String> roles) => _roles = roles;

  String get tokenType => _tokenType;

  set tokenType(String tokenType) => _tokenType = tokenType;

  String get accessToken => _accessToken;

  set accessToken(String accessToken) => _accessToken = accessToken;

  String get deptName => _deptName;

  set deptName(String deptName) => _deptName = deptName;

  String get div => _div;

  set div(String div) => _div = div;

  Login.fromJson(Map<dynamic, dynamic> json) {
    // _id = json['id'] ?? "";
    // _username = json['username'] ?? "";
    // _email = json['email'] ?? "";
    // _roles = json['roles'].cast<String>() ?? [];
    _tokenType = json['tokenType'] ?? "";
    _accessToken = json['accessToken'] ?? "";
    // _deptName = json['deptName'] ?? "";
    // _div = json['div'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['username'] = _username;
    data['email'] = _email;
    data['roles'] = _roles;
    data['tokenType'] = _tokenType;
    data['accessToken'] = _accessToken;
    data['deptName'] = _deptName;
    data['div'] = div;
    return data;
  }
  */
}
