class DeptList {
  String div = "", divname = "";

  DeptList({required this.divname, required this.div});

  String get getDiv => div;
  set setDiv(div) => this.div = div;
  String get getDivname => divname;
  set setDivname(divname) => this.divname = divname;
}
