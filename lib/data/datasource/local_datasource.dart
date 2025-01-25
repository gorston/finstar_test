import 'package:sqflite/sqflite.dart';
import 'package:finstar_test/finstar_test.dart';

abstract class LocalDatasource {
  Future<void> saveData(LoanModel loanModel);
  Future<List<LoanModel>> getData();
  Future<void> deleteData(int loanId);
}

class SQLLocalDatasource extends LocalDatasource {
  @override
  Future<void> saveData(LoanModel loanModel) async {
    final db = await openDatabase('loan_database.db', version: 1,
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE loans(id INTEGER PRIMARY KEY,  loanAmount REAL, interestRate REAL, loanDurationInMonths INTEGER, calculationModel TEXT, loanIssuedDate TEXT, hashCode INTEGER)');
    });

    final currentValues = await db
        .query('loans', where: 'hashCode = ?', whereArgs: [loanModel.hashCode]);

    if (currentValues.isEmpty) {
      await db.transaction((trx) {
        return trx.rawInsert(
            'INSERT INTO loans( loanAmount, interestRate, loanDurationInMonths, calculationModel, loanIssuedDate, hashCode ) VALUES(?, ?, ?, ?, ?,?)',
            [
              loanModel.loanAmount,
              loanModel.interestRate,
              loanModel.loanDurationInMonths,
              loanModel.calculationModel.name,
              loanModel.loanIssuedDate.toIso8601String(),
              loanModel.hashCode
            ]);
      });
    }
  }

  @override
  Future<List<LoanModel>> getData() async {
    final db = await openDatabase('loan_database.db', version: 1,
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE loans(id INTEGER PRIMARY KEY,  loanAmount REAL, interestRate REAL, loanDurationInMonths INTEGER, calculationModel TEXT, loanIssuedDate TEXT, hashCode INTEGER)');
    });

    final List<Map<String, dynamic>> loans = await db.query('loans');

    return loans.map((loan) {
      return LoanModel(
        loanId: loan['id'],
        loanAmount: loan['loanAmount'],
        interestRate: loan['interestRate'],
        loanDurationInMonths: loan['loanDurationInMonths'],
        calculationModel: loan['calculationModel'] == 'differentiated'
            ? InterestCalculationModel.differentiated
            : InterestCalculationModel.annuity,
        loanIssuedDate: DateTime.parse(loan['loanIssuedDate']),
      );
    }).toList();
  }

  @override
  Future<void> deleteData(int loanId) async {
    final db = await openDatabase('loan_database.db', version: 1,
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE loans(id INTEGER PRIMARY KEY, name TEXT, loanAmount INTEGER, interestRate REAL, loanDurationInMonths INTEGER, calculationModel TEXT, loanIssuedDate TEXT, additionalPayment INTEGER)');
    });

    await db.transaction((trx) {
      return trx.rawDelete('DELETE FROM loans WHERE id = ?', [loanId]);
    });
  }
}
