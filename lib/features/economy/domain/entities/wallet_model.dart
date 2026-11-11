import 'package:equatable/equatable.dart';

class WalletTransaction extends Equatable {
  final String id;
  final String title;
  final int amountTokens;
  final DateTime timestamp;
  final String type; // credit, debit

  const WalletTransaction({
    required this.id,
    required this.title,
    required this.amountTokens,
    required this.timestamp,
    this.type = 'credit',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amountTokens': amountTokens,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
    };
  }

  factory WalletTransaction.fromMap(Map<String, dynamic> map) {
    return WalletTransaction(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? 'Arena Transaction',
      amountTokens: map['amountTokens'] as int? ?? 0,
      timestamp: map['timestamp'] != null ? DateTime.parse(map['timestamp'] as String) : DateTime.now(),
      type: map['type'] as String? ?? 'credit',
    );
  }

  @override
  List<Object?> get props => [id, title, amountTokens, timestamp];
}

class WalletModel extends Equatable {
  final String userId;
  final int tokenBalance;
  final int xpBalance;
  final int coins;
  final int referralBonus;
  final List<WalletTransaction> transactions;

  const WalletModel({
    required this.userId,
    this.tokenBalance = 2450,
    this.xpBalance = 14200,
    this.coins = 500,
    this.referralBonus = 150,
    this.transactions = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'tokenBalance': tokenBalance,
      'xpBalance': xpBalance,
      'coins': coins,
      'referralBonus': referralBonus,
      'transactions': transactions.map((e) => e.toMap()).toList(),
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      userId: map['userId'] as String? ?? '',
      tokenBalance: map['tokenBalance'] as int? ?? 2450,
      xpBalance: map['xpBalance'] as int? ?? 14200,
      coins: map['coins'] as int? ?? 500,
      referralBonus: map['referralBonus'] as int? ?? 150,
      transactions: (map['transactions'] as List<dynamic>?)
              ?.map((e) => WalletTransaction.fromMap(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  @override
  List<Object?> get props => [userId, tokenBalance, xpBalance, coins];
}
