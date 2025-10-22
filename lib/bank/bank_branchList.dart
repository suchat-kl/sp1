class Bank_branchList {
  String bank_brch = "", name = "";

  Bank_branchList({required this.name, required this.bank_brch});

  String get getBank_brch => bank_brch;
  set setBank_brch(bankBrch) => bank_brch = bankBrch;
  String get getBank_name => name;
  set setBank_name(name) => this.name = name;
}
