class UserAll {
  String id="";
  String username="";
  String email="";
  String password="";
  String div="";
  String deptName="";
  List<Roles> roles=[];

  UserAll(
      {required this.id,
      required this.username,
      required this.email,
      required this.password,
      required this.div,
      required this.deptName,
      required this.roles});

  UserAll.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    div = json['div'];
    deptName = json['deptName'];
    if (json['roles'] != null) {
      // ignore: deprecated_member_use
     // roles =  List<Roles>;
      json['roles'].forEach((v) {
        roles.add(Roles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['div'] = div;
    data['deptName'] = deptName;
    data['roles'] = roles.map((v) => v.toJson()).toList();
    return data;
  }
}

class Roles {
  String id="";
  String name="";

  Roles({required this.id, required this.name});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
