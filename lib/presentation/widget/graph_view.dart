import 'package:finstar_test/finstar_test.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphView extends StatelessWidget {
  const GraphView({
    super.key,
    required this.calculatedLoanEntity,
  });

  final CalculatedLoanEntity? calculatedLoanEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Monthly payment",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <LineSeries<LoanSchedule, String>>[
                  LineSeries(
                      xValueMapper: (loan, _) => loan.payday,
                      yValueMapper: (loan, _) => loan.payment.roundToCents(),
                      dataSource: calculatedLoanEntity!.loanSchedule.sublist(1),
                      dataLabelSettings: DataLabelSettings(isVisible: true)),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Interest',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <LineSeries<LoanSchedule, String>>[
                  LineSeries<LoanSchedule, String>(
                    dataSource: calculatedLoanEntity!.loanSchedule.sublist(1),
                    xValueMapper: (loan, _) => loan.payday,
                    yValueMapper: (loan, _) => loan.interest.roundToCents(),
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Principal',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <LineSeries<LoanSchedule, String>>[
                  LineSeries(
                      xValueMapper: (loan, _) => loan.payday,
                      yValueMapper: (loan, _) => loan.principal.roundToCents(),
                      dataSource: calculatedLoanEntity!.loanSchedule.sublist(1),
                      dataLabelSettings: DataLabelSettings(isVisible: true)),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Remaining principal',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <LineSeries<LoanSchedule, String>>[
                  LineSeries(
                      xValueMapper: (loan, _) => loan.payday,
                      yValueMapper: (loan, _) =>
                          loan.remainingBalance.roundToCents(),
                      dataSource: calculatedLoanEntity!.loanSchedule.sublist(1),
                      dataLabelSettings: DataLabelSettings(isVisible: true)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
