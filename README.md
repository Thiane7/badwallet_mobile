# BadWallet Mobile 📱

Application mobile de gestion de portefeuille électronique développée avec **Flutter** (Dart) dans le cadre de l'examen de Design Pattern & Architectures Mobiles (L3 S2).

## 🚀 Architecture & Pattern (Feature-First)
L'application est structurée selon l'architecture **Feature-First** pour une meilleure modularité et séparation des responsabilités. Chaque dossier dans `lib/features/` représente une fonctionnalité complète du sujet :

* **`auth/`** : Écran d'accueil et d'authentification avec persistance des données.
* **`dashboard/`** : Vue principale affichant le solde du portefeuille. Intègre l'icône **Œil** permettant de masquer/afficher dynamiquement le solde, et liste les 5 dernières transactions.
* **`transfers/`** : Formulaire d'envoi d'argent avec intégration d'un **pavé numérique personnalisé**.
* **`bills/`** : Fonctionnalité de paiement de factures avec système de **sélection groupée** (cocher plusieurs factures).
* **`history/`** : Historique global de toutes les transactions avec code couleur strict : **Vert** pour les dépôts/crédits, **Rouge** pour les retraits/débits.

## 🛠️ Design Patterns & Technologies
* **State Management** : Utilisation du package `Provider` pour injecter proprement les dépendances et notifier les changements d'état.
* **Consommation API REST** : Centralisation des appels HTTP (GET/POST) dans un `ApiService` asynchrone pour piloter le backend Spring Boot.
* **Stockage Sécurisé** : Utilisation de `flutter_secure_storage` pour sauvegarder et lire de manière sécurisée les données de session utilisateur (comme le numéro de téléphone).
* **UI/UX Design** : Intégration des typographies `GoogleFonts` (Poppins et Inter) et formatage monétaire automatisé en **XOF** via le package `intl`.

## 📦 Dépendances principales utilisées
* `provider`
* `google_fonts`
* `intl`
* `flutter_secure_storage`

## ⚙️ Installation et Exécution

1. **Récupérer les dépendances du projet :**
   ```bash
   flutter pub get


*** Lancer l'application en mode Debug : flutter run

