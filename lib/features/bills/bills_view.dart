import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/api_service.dart';

class BillsView extends StatefulWidget {
  const BillsView({super.key});

  @override
  State<BillsView> createState() => _BillsViewState();
}

class _BillsViewState extends State<BillsView> {
  List<dynamic> _bills = [];
  final List<String> _selectedFactureIds = [];

  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  void _loadBills() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    final data = await apiService.getPendingBills('WLT-TEST', 'WOYAFAL');
    setState(() => _bills = data);
  }

  void _payGrouped() async {
    if (_selectedFactureIds.isEmpty) return;
    final apiService = Provider.of<ApiService>(context, listen: false);
    bool done = await apiService.payBills('+221770000003', _selectedFactureIds);
    if (mounted && done) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paiement groupé effectué !'), backgroundColor: Colors.green));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Factures de services'), backgroundColor: const Color(0xFF1F4E78), foregroundColor: Colors.white),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _bills.length,
              itemBuilder: (context, index) {
                final item = _bills[index];
                final id = item['factureId'];
                return CheckboxListTile(
                  title: Text('${item['provider']} - N° $id'),
                  subtitle: Text('Échéance : ${item['dueDate']}'),
                  secondary: Text('${item['amount']} XOF', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  value: _selectedFactureIds.contains(id),
                  onChanged: (bool? checked) {
                    setState(() {
                      if (checked == true) {
                        _selectedFactureIds.add(id);
                      } else {
                        _selectedFactureIds.remove(id);
                      }
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1F4E78), foregroundColor: Colors.white),
                onPressed: _selectedFactureIds.isEmpty ? null : _payGrouped,
                child: Text('Payer les factures sélectionnées (${_selectedFactureIds.length})'),
              ),
            ),
          )
        ],
      ),
    );
  }
}