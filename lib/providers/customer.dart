class Customer {
  final String name;
  final String phoneNumber;
  final String pinCode;
  final String locality;
  final String address;
  final String cityOrTown;
  final String landmark;

  Customer({
    required this.name,
    required this.phoneNumber,
    required this.pinCode,
    required this.locality,
    required this.address,
    required this.cityOrTown,
    required this.landmark,
  });

  static Customer fromJson(Map<String, dynamic> json) {
    return Customer(
        name: json['name'],
        phoneNumber: json['phoneNumber'],
        pinCode: json['pinCode'],
        locality: json['locality'],
        address: json['address'],
        cityOrTown: json['cityOrTown'],
        landmark: json['landmark']);
  }
}