class GhbLoan {
  String loan_id_card = "",
      loan_id = "",
      loan_emp_type = "G",
      loan_year = "",
      loan_seq = "",
      loan_subseq = "",
      loan_ghb_acc = "",
      loan_amt = "",
      loan_name = "";
      int select_flagLoan=0;
  GhbLoan(
      this.loan_id_card,
      this.loan_id,
      this.loan_emp_type,
      this.loan_year,
      this.loan_seq,
      this.loan_subseq,
      this.loan_ghb_acc,
      this.loan_amt,
      this.loan_name,
      this.select_flagLoan);
  // @override
  // String toString() {
  //   return '{ ${this.name}, ${this.age} }';
  // }
}
