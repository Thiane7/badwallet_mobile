class Wallet {
  final String phoneNumber;
  final String email;
  final double balance;
  final String code;
  final String currency;

  Wallet({
    required this.phoneNumber,
    required this.email,
    required this.balance,
    required this.code,
    required this.currency,
  });

  // Convertit le JSON reçu de Spring Boot en objet Wallet
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      code: json['code'] ?? '',
      currency: json['currency'] ?? 'XOF',
    );
  }
}