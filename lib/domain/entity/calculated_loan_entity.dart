class CalculatedLoanEntity {
  final double totalAmount;
  final double totalInterest;
  final double monthlyPayment;
  final int totalMonths;
  final List<LoanSchedule> loanSchedule;

  CalculatedLoanEntity({
    required this.loanSchedule,
    required this.totalAmount,
    required this.totalInterest,
    required this.monthlyPayment,
    required this.totalMonths,
  });
}

class LoanSchedule {
  final String payday;
  final double payment;
  final double interest;
  final double principal;
  final double remainingBalance;

  LoanSchedule({
    required this.payday,
    required this.payment,
    required this.interest,
    required this.principal,
    required this.remainingBalance,
  });

  LoanSchedule copyWith({
    String? payday,
    double? payment,
    double? interest,
    double? principal,
    double? remainingBalance,
  }) {
    return LoanSchedule(
      payday: payday ?? this.payday,
      payment: payment ?? this.payment,
      interest: interest ?? this.interest,
      principal: principal ?? this.principal,
      remainingBalance: remainingBalance ?? this.remainingBalance,
    );
  }
}
