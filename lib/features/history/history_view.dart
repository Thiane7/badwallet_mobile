import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/api_service.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  List<dynamic> _history = [];

  @override
  void initState() {
    super.initState();
    Provider.of<ApiService>(context, listen: false).getTransactions('+221770000003').then((data) {
      setState(() => _history = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historique Complet'), backgroundColor: const Color(0xFF1F4E78), foregroundColor: Colors.white),
      body: _history.isEmpty
          ? const Center(child: Text('Aucune transaction enregistrée.'))
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final tx = _history[index];
                final isDeposit = tx['type'] == 'DEPOSIT';
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Icon(isDeposit ? Icons.add_circle : Icons.remove_circle, color: isDeposit ? Colors.green : Colors.red),
                    title: Text(tx['description'] ?? 'Opération'),
                    subtitle: Text(tx['createdAt'] ?? ''),
                    trailing: Text(
                      '${isDeposit ? "+" : "-"}${tx['amount']} XOF',
                      style: TextStyle(color: isDeposit ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
    );
  }
}