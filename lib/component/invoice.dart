class Invoice {
  final Passenger passenger;
  const Invoice({
    required this.passenger,
  });
}

class Passenger {
  final String name;
  final String car_type;
  final String departure;
  final String destination;
  final String n_name;
  final String n_phone;
  final String amount;
  final String dates;
  final String tran_id;

  const Passenger({
    required this.name,
    required this.car_type,
    required this.departure,
    required this.destination,
    required this.n_name,
    required this.n_phone,
    required this.amount,
    required this.dates,
    required this.tran_id,
  });
}
