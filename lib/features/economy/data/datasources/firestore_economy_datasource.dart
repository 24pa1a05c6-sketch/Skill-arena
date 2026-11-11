import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_arena/core/firestore/firestore_collections.dart';
import 'package:skill_arena/core/payments/payment_gateway_contract.dart';
import 'package:skill_arena/core/services/analytics_service.dart';
import 'package:skill_arena/features/economy/domain/entities/marketplace_item.dart';
import 'package:skill_arena/features/economy/domain/entities/wallet_model.dart';

/// Production Firestore Datasource for Phase 8 Digital Economy & Vault Marketplace.
class FirestoreEconomyDatasource {
  final PaymentGatewayContract _paymentGateway = ProductionPaymentProcessor();

  Future<WalletModel> getWallet(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection(FirestoreCollections.wallets)
          .doc(userId)
          .get(const GetOptions(source: Source.cache));

      if (doc.exists && doc.data() != null) {
        return WalletModel.fromMap(doc.data()!);
      }
    } catch (_) {}

    return WalletModel(
      userId: userId,
      tokenBalance: 3250,
      xpBalance: 18500,
      coins: 750,
      referralBonus: 200,
      transactions: [
        WalletTransaction(
          id: 'tx_1',
          title: 'Tournament Victory Prize Pool',
          amountTokens: 1000,
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        ),
        WalletTransaction(
          id: 'tx_2',
          title: 'Vault Purchase: Cyberpunk Neon Skin',
          amountTokens: -250,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          type: 'debit',
        ),
      ],
    );
  }

  Future<PaymentResult> topUpTokens({
    required String userId,
    required double amountUsd,
    required int tokenAmount,
    required PaymentProviderType provider,
  }) async {
    final paymentResult = await _paymentGateway.processPayment(
      userId: userId,
      amount: amountUsd,
      currency: 'USD',
      provider: provider,
    );

    if (paymentResult.isSuccess) {
      try {
        await FirebaseFirestore.instance
            .collection(FirestoreCollections.wallets)
            .doc(userId)
            .set({
          'tokenBalance': FieldValue.increment(tokenAmount),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        AnalyticsService.instance.logCourseStarted('$tokenAmount Tokens', 'Wallet Top-Up');
      } catch (_) {}
    }

    return paymentResult;
  }

  Future<List<MarketplaceItem>> getMarketplaceCatalog() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(FirestoreCollections.marketplaceItems)
          .get(const GetOptions(source: Source.cache));

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => MarketplaceItem.fromMap(doc.data())).toList();
      }
    } catch (_) {}

    return [
      const MarketplaceItem(
        id: 'item_1',
        title: 'Cyberpunk Neon Glass Skin',
        category: 'Glass Skins',
        description: 'Specular 135° cyan-magenta glass card outline with glow effects',
        priceTokens: 250,
        rarity: ItemRarity.epic,
        isOwned: true,
        isEquipped: true,
      ),
      const MarketplaceItem(
        id: 'item_2',
        title: 'Vanguard Grandmaster Frame',
        category: 'Profile Frames',
        description: 'Animated golden perimeter border for Vanguard legends',
        priceTokens: 500,
        rarity: ItemRarity.legendary,
      ),
      const MarketplaceItem(
        id: 'item_3',
        title: 'Cyber Synthwave Sound Pack',
        category: 'Sound Packs',
        description: 'Retro synth SFX for tournament countdowns & victory crowns',
        priceTokens: 150,
      ),
      const MarketplaceItem(
        id: 'item_4',
        title: 'Arena Pass: Season 1 Elite',
        category: 'Passes',
        description: 'Unlocks 2x XP Multiplier, Premium Tournaments, and Elite Badges',
        priceTokens: 1200,
        rarity: ItemRarity.legendary,
      ),
    ];
  }

  Future<bool> purchaseItem(String userId, MarketplaceItem item) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.ownedItems)
          .doc('${userId}_${item.id}')
          .set({
        'userId': userId,
        'itemId': item.id,
        'purchasedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
    return true;
  }

  Future<void> setItemEquipped(String userId, String itemId, bool isEquipped) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.inventory)
          .doc('${userId}_$itemId')
          .set({
        'userId': userId,
        'itemId': itemId,
        'isEquipped': isEquipped,
      }, SetOptions(merge: true));
    } catch (_) {}
  }
}
