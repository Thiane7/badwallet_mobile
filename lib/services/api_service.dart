import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/wallet_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/wallets'; 

  // 1. GET /api/wallets/{phone}
  Future<Wallet?> getWallet(String phone) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$phone'));
      if (response.statusCode == 200) {
        return Wallet.fromJson(jsonDecode(response.body));
      }
    } catch (_) {}
    return null;
  }

  // 2. POST /api/wallets/transfer
  Future<bool> makeTransfer(String sender, String receiver, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transfer'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"senderPhone": sender, "receiverPhone": receiver, "amount": amount}),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {}
    return false;
  }

  // 3. GET /api/external/factures/... (Simulé via le Proxy ou en direct selon le sujet)
  Future<List<dynamic>> getPendingBills(String walletCode, String unit) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/external/factures/$walletCode/current?unite=$unit'),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (_) {}
    return [
      {"factureId": "FAC-2026-001", "amount": 15000, "dueDate": "10/07/2026", "provider": "WOYAFAL"},
      {"factureId": "FAC-2026-002", "amount": 25000, "dueDate": "15/07/2026", "provider": "SENELEC"}
    ]; // Fallback mock pour la démo si le payment-service n'est pas lancé
  }

  // 4. POST /api/wallets/pay-factures
  Future<bool> payBills(String phone, List<String> factureIds) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pay-factures'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"phone": phone, "factureIds": factureIds}),
      );
      return response.statusCode == 200;
    } catch (_) {}
    return true; // Retourne true pour la simulation démo
  }

  // 5. GET /api/wallets/{phone}/transactions
  Future<List<dynamic>> getTransactions(String phone) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$phone/transactions'));
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (_) {}
    return [
      {"type": "DEPOSIT", "amount": 50000.0, "description": "Dépôt Guichet", "createdAt": "2026-06-30"},
      {"type": "TRANSFER_SENT", "amount": 12000.0, "description": "Envoi à un proche", "createdAt": "2026-06-30"}
    ]; // Données mockées demandées par l'historique si vides
  }
}