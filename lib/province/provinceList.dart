class ProvinceList {
  String prov_code = "", prov_name = "";

  ProvinceList({required this.prov_name, required this.prov_code});

  String get getProv_code => prov_code;
  set setProv_code(provCode) => prov_code = provCode;
  String get getProv_name => prov_name;
  set setProv_name(provName) => prov_name = provName;
}
