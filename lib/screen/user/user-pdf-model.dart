class Invoice {
  final Passenger passenger;
  const Invoice({
    required this.passenger,
  });
}

class Passenger {
  final String name;
  final String reg_no;
  final String reciept;
  final String payment_type;
  final String email;
  final String gender;
  final String amount;
  final String dates;
  final String status;

  const Passenger({
    required this.email,
    required this.status,
    required this.gender,
    required this.reg_no,
    required this.reciept,
    required this.payment_type,
    required this.name,
    required this.amount,
    required this.dates,
  });
}
