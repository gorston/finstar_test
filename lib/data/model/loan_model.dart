import 'package:equatable/equatable.dart';

class LoanModel extends Equatable {
  final double loanAmount;
  final double interestRate;
  final int loanDurationInMonths;
  final InterestCalculationModel calculationModel;
  final DateTime loanIssuedDate;

  final int loanId;

  const LoanModel({
    required this.loanId,
    required this.loanAmount,
    required this.interestRate,
    required this.loanDurationInMonths,
    required this.calculationModel,
    required this.loanIssuedDate,
  });

  @override
  List<Object?> get props => [
        loanId,
        loanAmount,
        interestRate,
        loanDurationInMonths,
        calculationModel,
        loanIssuedDate,
      ];

  LoanModel copyWith({
    int? loanId,
    double? loanAmount,
    double? interestRate,
    int? loanDurationInMonths,
    InterestCalculationModel? calculationModel,
    DateTime? loanIssuedDate,
  }) {
    return LoanModel(
      loanId: loanId ?? this.loanId,
      loanAmount: loanAmount ?? this.loanAmount,
      interestRate: interestRate ?? this.interestRate,
      loanDurationInMonths: loanDurationInMonths ?? this.loanDurationInMonths,
      calculationModel: calculationModel ?? this.calculationModel,
      loanIssuedDate: loanIssuedDate ?? this.loanIssuedDate,
    );
  }

  @override
  int get hashCode => props.fold(0, (prev, element) => prev ^ element.hashCode);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LoanModel) return false;
    return other.hashCode == hashCode;
  }
}

enum InterestCalculationModel { differentiated, annuity }
