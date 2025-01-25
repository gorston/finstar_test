import 'package:finstar_test/finstar_test.dart';
import 'package:flutter/material.dart';

class LoanHistory extends StatelessWidget {
  const LoanHistory({
    super.key,
    required this.loans,
  });

  final List<LoanModel> loans;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: loans.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context, index);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Loan amount: ${loans[index].loanAmount}'),
                Text('Interest rate: ${loans[index].interestRate}'),
                Text('Loan duration: ${loans[index].loanDurationInMonths}'),
                Text(
                    'Loan issued date: ${loans[index].loanIssuedDate.toString().substring(0, 10)}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
