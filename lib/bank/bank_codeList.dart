class Bank_codeList {
  String bank_code = "", bank_name = "";

  Bank_codeList({required this.bank_name, required this.bank_code});

  String get getBank_code => bank_code;
  set setBank_code(bankCode) => bank_code = bankCode;
  String get getBank_name => bank_name;
  set setBank_name(bankName) => bank_name = bankName;
}
