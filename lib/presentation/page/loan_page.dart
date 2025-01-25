import 'package:finstar_test/finstar_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanPage extends StatefulWidget {
  const LoanPage({super.key});

  @override
  State<LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  final issueDateController = TextEditingController()
    ..text = DateTime.now().toString().substring(0, 10);

  CalculatedLoanEntity? calculatedLoanEntity;

  final loanAmountController = TextEditingController();
  final interestRateController = TextEditingController();
  final loanDurationInMonthsController = TextEditingController();

  InterestCalculationModel calculationModel = InterestCalculationModel.annuity;
  DateTime loanIssuedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  late final LoanPageController controller;
  @override
  void initState() {
    controller = Get.put(LoanPageController(
      localDatasource: SQLLocalDatasource(),
      annuityCalculation: AnnuityCalculation(),
      differentiatedCalculation: DifferentiatedCalculation(),
    ));
    loanAmountController.text =
        controller.loanModel.value.loanAmount.toString();
    interestRateController.text =
        controller.loanModel.value.interestRate.toString();
    loanDurationInMonthsController.text =
        controller.loanModel.value.loanDurationInMonths.toString();
    calculationModel = controller.loanModel.value.calculationModel;
    loanIssuedDate = controller.loanModel.value.loanIssuedDate;
    issueDateController.text = loanIssuedDate.toString().substring(0, 10);
    super.initState();
  }

  String? validate(String? value) {
    if (value == null || value.isEmpty || (double.tryParse(value) ?? -1) <= 0) {
      return 'Please enter a positive number';
    }
    return null;
  }

  String? validateMonths(String? value) {
    if (value == null ||
        value.isEmpty ||
        ((double.tryParse(value) ?? -1) % 1) != 0 ||
        (double.tryParse(value) ?? -1) <= 0) {
      return 'Please enter a positive, non decimal number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Loan Page'),
          actions: [
            IconButton(
              onPressed: () async {
                final loans = (await controller.getLoans()).reversed.toList();

                if (mounted) {
                  showModalBottomSheet(
                          context: context,
                          builder: (context) => LoanHistory(loans: loans))
                      .then((index) {
                    if (index != null) {
                      setState(() {
                        controller.loadPageFromModel(loans[index]);
                        loanAmountController.text =
                            loans[index].loanAmount.toString();
                        interestRateController.text =
                            loans[index].interestRate.toString();
                        loanDurationInMonthsController.text =
                            loans[index].loanDurationInMonths.toString();
                        calculationModel = loans[index].calculationModel;
                        loanIssuedDate = loans[index].loanIssuedDate;
                        issueDateController.text =
                            loanIssuedDate.toString().substring(0, 10);
                      });
                    }
                  });
                }
              },
              icon: const Icon(Icons.history),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Loan Amount'),
                  controller: loanAmountController,
                  validator: validate,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Interest Rate'),
                  controller: interestRateController,
                  validator: validate,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Loan Duration In Months'),
                  controller: loanDurationInMonthsController,
                  validator: validateMonths,
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                ),
                Row(
                  children: [
                    Text('Calculation Model: '),
                    SizedBox(
                      width: 16,
                    ),
                    DropdownButton<InterestCalculationModel>(
                      value: calculationModel,
                      items: InterestCalculationModel.values
                          .map((model) => DropdownMenuItem(
                                value: model,
                                child: Text(model.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          calculationModel = value!;
                        });
                      },
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ).then((value) {
                      loanIssuedDate = value ?? DateTime.now();
                      issueDateController.text =
                          value.toString().substring(0, 10);
                    });
                  },
                  child: TextField(
                    decoration:
                        const InputDecoration(labelText: 'Loan Issued Date'),
                    enabled: false,
                    controller: issueDateController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        setState(() {
                          controller.updateModel(
                            loanAmount: double.parse(loanAmountController.text),
                            interestRate:
                                double.parse(interestRateController.text),
                            loanDurationInMonths:
                                int.parse(loanDurationInMonthsController.text),
                            calculationModel: calculationModel,
                            loanIssuedDate: loanIssuedDate,
                          );

                          calculatedLoanEntity =
                              controller.calculatedLoanEntity;
                        });
                        FocusScope.of(context).unfocus();
                      },
                      child: const Text('Calculate')),
                ),
                if (calculatedLoanEntity != null) ...[
                  CalculatedView(calculatedLoanEntity: calculatedLoanEntity!),
                  OutlinedButton(
                    onPressed: () {
                      controller.saveLoan();
                    },
                    child: const Text('Save Loan'),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
