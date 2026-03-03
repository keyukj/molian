import 'package:shared_preferences/shared_preferences.dart';

class MolianWalletService {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 60;

  static Future<int> getBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> setBalance(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> deductCoins(int amount) async {
    int currentBalance = await getBalance();
    int newBalance =
        (currentBalance - amount).clamp(0, double.infinity).toInt();
    await setBalance(newBalance);
  }

  static Future<void> addCoins(int amount) async {
    int currentBalance = await getBalance();
    await setBalance(currentBalance + amount);
  }
}
