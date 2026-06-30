import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../services/api_service.dart';

class TransferView extends StatefulWidget {
  const TransferView({super.key});

  @override
  State<TransferView> createState() => _TransferViewState();
}

class _TransferViewState extends State<TransferView> {
  final _destController = TextEditingController();
  String _amount = '';

  void _onKeyTap(String value) {
    setState(() {
      if (value == '⌫') {
        if (_amount.isNotEmpty) _amount = _amount.substring(0, _amount.length - 1);
      } else {
        _amount += value;
      }
    });
  }

  void _submitTransfer() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    const storage = FlutterSecureStorage();
    String sender = await storage.read(key: 'user_phone') ?? '+221770000003';

    if (_destController.text.isEmpty || _amount.isEmpty) return;

    bool success = await apiService.makeTransfer(sender, _destController.text.trim(), double.parse(_amount));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'Transfert effectué avec succès !' : 'Échec du transfert.'), backgroundColor: success ? Colors.green : Colors.red),
      );
      if (success) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau Transfert'), backgroundColor: const Color(0xFF1F4E78), foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _destController, decoration: const InputDecoration(labelText: 'Téléphone du destinataire', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
              child: Text(_amount.isEmpty ? '0 XOF' : '$_amount XOF', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            // Pavé numérique personnalisé requis
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.5),
                itemCount: 12,
                itemBuilder: (context, index) {
                  List<String> keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '00', '⌫'];
                  return InkWell(
                    onTap: () => _onKeyTap(keys[index]),
                    child: Center(child: Text(keys[index], style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold))),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1F4E78), foregroundColor: Colors.white),
                onPressed: _submitTransfer,
                child: const Text('Confirmer le transfert'),
              ),
            )
          ],
        ),
      ),
    );
  }
}