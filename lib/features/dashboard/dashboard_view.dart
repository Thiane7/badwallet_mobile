import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../services/api_service.dart';
import '../../../models/wallet_model.dart';
import '../transfers/transfer_view.dart';
import '../bills/bills_view.dart';
import '../history/history_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool _isBalanceHidden = false;
  String _currentState = 'Loading';
  Wallet? _wallet;
  List<dynamic> _recentTransactions = [];
  final _currencyFormat = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: 'XOF',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    const storage = FlutterSecureStorage();
    String phone = await storage.read(key: 'user_phone') ?? '+221770000003';

    setState(() => _currentState = 'Loading');
    try {
      final wallet = await apiService.getWallet(phone);
      final txs = await apiService.getTransactions(phone);
      if (wallet != null) {
        setState(() {
          _wallet = wallet;
          _recentTransactions = txs.take(5).toList();
          _currentState = 'Loaded(balance)';
        });
      } else {
        setState(() => _currentState = 'Error');
      }
    } catch (_) {
      setState(() => _currentState = 'Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentState == 'Loading') {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF1F4E78)),
        ),
      );
    }
    if (_currentState == 'Error') {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Erreur de chargement de l\'API REST',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BadWallet',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1F4E78),
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: const Color(0xFF1F4E78),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Solde disponible',
                          style: GoogleFonts.inter(color: Colors.white70),
                        ),
                        IconButton(
                          icon: Icon(
                            _isBalanceHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () => setState(
                            () => _isBalanceHidden = !_isBalanceHidden,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isBalanceHidden
                          ? '••••••• XOF'
                          : _currencyFormat.format(_wallet?.balance ?? 0),
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Code : ${_wallet?.code ?? 'N/A'}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _actionButton(
                  Icons.send,
                  'Transférer',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TransferView()),
                  ),
                ),
                _actionButton(
                  Icons.receipt,
                  'Payer',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BillsView()),
                  ),
                ),
                _actionButton(
                  Icons.history,
                  'Historique',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoryView()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              '5 Dernières Opérations',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F4E78),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _recentTransactions.isEmpty
                  ? const Center(child: Text('Aucune transaction récente.'))
                  : ListView.builder(
                      itemCount: _recentTransactions.length,
                      itemBuilder: (context, index) {
                        final tx = _recentTransactions[index];
                        final isDeposit = tx['type'] == 'DEPOSIT';
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Icon(
                              isDeposit
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: isDeposit ? Colors.green : Colors.red,
                            ),
                            title: Text(tx['description'] ?? 'Transaction'),
                            subtitle: Text(tx['createdAt'] ?? ''),
                            trailing: Text(
                              '${isDeposit ? "+" : "-"}${tx['amount']} XOF',
                              style: TextStyle(
                                color: isDeposit ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon, color: const Color(0xFF1F4E78), size: 30),
        ),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
