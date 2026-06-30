import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:badwallet_mobile/main.dart';

void main() {
  testWidgets('Vérification du chargement de l\'écran d\'authentification', (WidgetTester tester) async {
    // 1. Initialise et charge l'application BadWalletApp
    await tester.pumpWidget(const BadWalletApp());

    // 2. Vérifie que le titre de l'application est bien présent à l'écran
    expect(find.text('BadWallet'), findsOneWidget);

    // 3. Vérifie que le bouton de connexion est bien visible
    expect(find.text('Se connecter'), findsOneWidget);
    
    // 4. Vérifie que l'ancien texte du compteur n'existe plus du tout
    expect(find.text('You have pushed the button this many times:'), findsNothing);
  });
}