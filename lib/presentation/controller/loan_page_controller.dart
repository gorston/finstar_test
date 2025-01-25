import 'package:finstar_test/finstar_test.dart';
import 'package:get/get.dart';

class LoanPageController extends GetxController {
  final LocalDatasource localDatasource;
  final AnnuityCalculation annuityCalculation;
  final DifferentiatedCalculation differentiatedCalculation;

  LoanPageController({
    required this.localDatasource,
    required this.annuityCalculation,
    required this.differentiatedCalculation,
  });

  Rx<LoanModel> loanModel = LoanModel(
    loanAmount: 300000,
    interestRate: 21,
    loanDurationInMonths: 36,
    calculationModel: InterestCalculationModel.annuity,
    loanIssuedDate: DateTime.now(),
    loanId: 0,
  ).obs;

  CalculatedLoanEntity get calculatedLoanEntity {
    if (loanModel.value.calculationModel == InterestCalculationModel.annuity) {
      return annuityCalculation.calculateLoan(loanModel.value);
    } else {
      return differentiatedCalculation.calculateLoan(loanModel.value);
    }
  }

  void updateModel({
    double? loanAmount,
    double? interestRate,
    int? loanDurationInMonths,
    InterestCalculationModel? calculationModel,
    DateTime? loanIssuedDate,
  }) {
    loanModel.value = loanModel.value.copyWith(
      loanAmount: loanAmount,
      interestRate: interestRate,
      loanDurationInMonths: loanDurationInMonths,
      calculationModel: calculationModel,
      loanIssuedDate: loanIssuedDate,
    );
  }

  Future<void> saveLoan() async {
    await localDatasource.saveData(loanModel.value);
  }

  Future<List<LoanModel>> getLoans() async {
    return await localDatasource.getData();
  }

  Future<void> loadPageFromModel(LoanModel loanModel) async {
    this.loanModel.value = loanModel;
  }
}
