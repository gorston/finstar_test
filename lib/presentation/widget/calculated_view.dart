import 'package:finstar_test/finstar_test.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CalculatedView extends StatelessWidget {
  const CalculatedView({
    super.key,
    required this.calculatedLoanEntity,
  });

  final CalculatedLoanEntity calculatedLoanEntity;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
              'Monthly Payment: ${calculatedLoanEntity.monthlyPayment.roundToCents()}'),
          Text(
              'Total Amount: ${calculatedLoanEntity.totalAmount.roundToCents()}'),
          Text(
              'Total Interest: ${calculatedLoanEntity.totalInterest.roundToCents()}'),
          Text('Total Months: ${calculatedLoanEntity.totalMonths}'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TableView(
                            calculatedLoanEntity: calculatedLoanEntity)));
                  },
                  child: Text(
                    'Table View',
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GraphView(
                            calculatedLoanEntity: calculatedLoanEntity)));
                  },
                  child: Text('Graph View'),
                ),
              ],
            ),
          ),
          Expanded(
            child: SfCircularChart(
              series: <DoughnutSeries<(String, double), String>>[
                DoughnutSeries<(String, double), String>(
                  radius: '100%',
                  innerRadius: '30%',
                  dataSource: <(String, double)>[
                    (
                      'Total interest',
                      calculatedLoanEntity.totalInterest.roundToCents()
                    ),
                    (
                      'Total principal',
                      (calculatedLoanEntity.totalAmount -
                              calculatedLoanEntity.totalInterest)
                          .roundToCents()
                    )
                  ],
                  xValueMapper: (data, _) => data.$1,
                  yValueMapper: (data, _) => data.$2,
                  dataLabelMapper: (data, _) =>
                      '${(data.$2 / calculatedLoanEntity.totalAmount * 100).roundToCents()}%',
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                )
              ],
              legend: Legend(isVisible: true),
            ),
          )
        ],
      ),
    );
  }
}
