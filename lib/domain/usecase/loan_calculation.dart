import 'dart:math';

import 'package:finstar_test/finstar_test.dart';

abstract class LoanCalculation {
  CalculatedLoanEntity calculateLoan(LoanModel loanModel);
  List<DateTime> generateMonthlyPaymentDates(
      DateTime startDate, int numPayments) {
    List<DateTime> paymentDates = [];

    for (int i = 0; i < numPayments; i++) {
      DateTime paymentDate = DateTime(
        startDate.year,
        startDate.month + i,
        startDate.day,
      );

      if (paymentDate.month != (startDate.month + i) % 12 &&
          ((startDate.month + i) % 12 != 0)) {
        paymentDate = DateTime(
          paymentDate.year,
          paymentDate.month,
          0,
        );
      }

      paymentDates.add(paymentDate);
    }

    return paymentDates;
  }

  double calculateInterest(double principal, double rate, int days,
      DateTime currentDate, DateTime previousDate) {
    return principal *
        rate *
        days /
        (_isLeapYear(currentDate.year) ? 366 : 365) /
        100;
  }

  bool _isLeapYear(int year) {
    return (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
  }
}

class AnnuityCalculation extends LoanCalculation {
  @override
  CalculatedLoanEntity calculateLoan(LoanModel loanModel) {
    final loanSchedule = _calculateLoanSchedule(loanModel);
    final monthlyInterestRate = loanModel.interestRate;
    final monthlyPayment = calculateAnnuityPayment(loanModel.loanAmount,
        monthlyInterestRate, loanModel.loanDurationInMonths);
    final totalPayment =
        loanSchedule.map((e) => e.payment).reduce((a, b) => a + b);
    final totalInterest = totalPayment - loanModel.loanAmount;

    return CalculatedLoanEntity(
      monthlyPayment: monthlyPayment,
      totalAmount: totalPayment,
      totalInterest: totalInterest,
      totalMonths: loanModel.loanDurationInMonths,
      loanSchedule: loanSchedule,
    );
  }

  List<LoanSchedule> _calculateLoanSchedule(
    LoanModel loanModel,
  ) {
    List<DateTime> paymentDates = generateMonthlyPaymentDates(
        loanModel.loanIssuedDate, loanModel.loanDurationInMonths + 1);
    double fixedPayment = calculateAnnuityPayment(loanModel.loanAmount,
        loanModel.interestRate, loanModel.loanDurationInMonths);

    List<LoanSchedule> payments = [];
    double remainingPrincipal = loanModel.loanAmount.toDouble();

    payments.add(LoanSchedule(
      payday:
          "${loanModel.loanIssuedDate.year}-${loanModel.loanIssuedDate.month}",
      payment: 0,
      interest: 0,
      principal: 0,
      remainingBalance: remainingPrincipal,
    ));

    for (int i = 1; i <= loanModel.loanDurationInMonths; i++) {
      DateTime currentDate = paymentDates[i];
      double dailyRate = loanModel.interestRate;
      double payment = fixedPayment;
      DateTime previousDate =
          i > 0 ? paymentDates[i - 1] : loanModel.loanIssuedDate;

      int daysBetween = currentDate.difference(previousDate).inDays;
      double interest = calculateInterest(remainingPrincipal, dailyRate,
          daysBetween, currentDate, previousDate);
      double principalPayment = (fixedPayment - interest);

      remainingPrincipal = (remainingPrincipal - principalPayment);

      if (remainingPrincipal < 0) {
        principalPayment += remainingPrincipal;
        remainingPrincipal = 0;
        payment = principalPayment + interest;
      }

      payments.add(LoanSchedule(
        payday: "${currentDate.year}-${currentDate.month}",
        payment: payment,
        interest: interest,
        principal: principalPayment,
        remainingBalance: remainingPrincipal,
      ));

      if (remainingPrincipal <= 0) break;
    }
    if (payments.last.remainingBalance > 0) {
      payments.last = payments.last.copyWith(
        payment: (payments.last.payment + payments.last.remainingBalance),
        principal: (payments.last.principal + payments.last.remainingBalance),
        remainingBalance: 0,
      );
    }
    return payments;
  }

  double calculateAnnuityPayment(
      double principal, double annualRate, int months) {
    double monthlyRate = annualRate / 12 / 100;
    return principal *
        (monthlyRate * pow(1 + monthlyRate, months)) /
        (pow(1 + monthlyRate, months) - 1);
  }
}

class DifferentiatedCalculation extends LoanCalculation {
  @override
  CalculatedLoanEntity calculateLoan(LoanModel loanModel) {
    final loanSchedule = _calculateLoanSchedule(loanModel);

    final totalPayment =
        loanSchedule.map((e) => e.payment).reduce((a, b) => a + b);

    final firstMonthlyPayment = loanSchedule[1].payment;

    final totalInterest = totalPayment - loanModel.loanAmount;

    return CalculatedLoanEntity(
        monthlyPayment: firstMonthlyPayment,
        totalAmount: totalPayment,
        totalInterest: totalInterest,
        totalMonths: loanModel.loanDurationInMonths,
        loanSchedule: _calculateLoanSchedule(loanModel));
  }

  List<LoanSchedule> _calculateLoanSchedule(
    LoanModel loanModel,
  ) {
    List<DateTime> paymentDates = generateMonthlyPaymentDates(
        loanModel.loanIssuedDate, loanModel.loanDurationInMonths + 1);

    double remainingPrincipal = loanModel.loanAmount.toDouble();

    double basePrincipal =
        (loanModel.loanAmount / loanModel.loanDurationInMonths);

    List<LoanSchedule> payments = [];

    payments.add(LoanSchedule(
      payday:
          "${loanModel.loanIssuedDate.year}-${loanModel.loanIssuedDate.month}",
      payment: 0,
      interest: 0,
      principal: 0,
      remainingBalance: remainingPrincipal,
    ));

    for (int i = 1; i < paymentDates.length; i++) {
      DateTime currentDate = paymentDates[i];
      double dailyRate = loanModel.interestRate;
      DateTime previousDate =
          i > 0 ? paymentDates[i - 1] : loanModel.loanIssuedDate;

      int daysBetween = currentDate.difference(previousDate).inDays;
      double interest = calculateInterest(remainingPrincipal, dailyRate,
          daysBetween, currentDate, previousDate);

      double principalPayment = (basePrincipal);
      remainingPrincipal -= principalPayment;

      if (remainingPrincipal < 0) {
        principalPayment += remainingPrincipal;
        remainingPrincipal = 0;
      }

      payments.add(LoanSchedule(
        payday: "${currentDate.year}-${currentDate.month}",
        payment: principalPayment + interest,
        interest: interest,
        principal: principalPayment,
        remainingBalance: remainingPrincipal,
      ));
    }

    if (payments.last.remainingBalance > 0) {
      payments.last = payments.last.copyWith(
        payment: (payments.last.payment + payments.last.remainingBalance),
        principal: (payments.last.principal + payments.last.remainingBalance),
        remainingBalance: 0,
      );
    }

    return payments;
  }
}

extension RoundToCents on double {
  double roundToCents() {
    return (this * 100).round() / 100;
  }
}
