import 'package:finstar_test/finstar_test.dart';
import 'package:flutter/material.dart';

class TableView extends StatelessWidget {
  const TableView({
    super.key,
    required this.calculatedLoanEntity,
  });

  final CalculatedLoanEntity calculatedLoanEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Schedule'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Center(child: const Text('Month')),
              ),
              Expanded(
                child: Center(child: const Text('Payment')),
              ),
              Expanded(
                child: Center(child: const Text('Principal')),
              ),
              Expanded(
                child: Center(child: const Text('Interest')),
              ),
              Expanded(
                child: Center(child: const Text('Remainder')),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ...List.generate(
                            calculatedLoanEntity.loanSchedule.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(calculatedLoanEntity
                                .loanSchedule[index].payday),
                          );
                        }),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        ...List.generate(
                            calculatedLoanEntity.loanSchedule.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(calculatedLoanEntity
                                .loanSchedule[index].payment
                                .roundToCents()
                                .toString()),
                          );
                        }),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        ...List.generate(
                            calculatedLoanEntity.loanSchedule.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(calculatedLoanEntity
                                .loanSchedule[index].principal
                                .roundToCents()
                                .toString()),
                          );
                        }),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        ...List.generate(
                            calculatedLoanEntity.loanSchedule.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(calculatedLoanEntity
                                .loanSchedule[index].interest
                                .roundToCents()
                                .toString()),
                          );
                        }),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        ...List.generate(
                            calculatedLoanEntity.loanSchedule.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(calculatedLoanEntity
                                .loanSchedule[index].remainingBalance
                                .roundToCents()
                                .toString()),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
