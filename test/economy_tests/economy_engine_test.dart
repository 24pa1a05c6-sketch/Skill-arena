import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_arena/core/payments/payment_gateway_contract.dart';
import 'package:skill_arena/features/economy/data/datasources/firestore_economy_datasource.dart';
import 'package:skill_arena/features/economy/domain/entities/marketplace_item.dart';
import 'package:skill_arena/features/economy/domain/entities/wallet_model.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Phase 8 Digital Economy & Wallet Engine Unit Tests', () {
    test('WalletModel serialization and initial balances', () {
      const wallet = WalletModel(
        userId: 'vanguard_2030',
        tokenBalance: 3000,
        xpBalance: 15000,
        coins: 800,
      );

      final map = wallet.toMap();
      final restored = WalletModel.fromMap(map);

      expect(restored.tokenBalance, equals(3000));
      expect(restored.coins, equals(800));
    });

    test('MarketplaceItem rarity mapping and copyWith', () {
      const item = MarketplaceItem(
        id: 'item_test',
        title: 'Cyber Frame',
        category: 'Frames',
        description: 'Test Asset',
        priceTokens: 200,
        rarity: ItemRarity.legendary,
      );

      expect(item.rarity, equals(ItemRarity.legendary));

      final purchased = item.copyWith(isOwned: true);
      expect(purchased.isOwned, isTrue);
    });

    test('ProductionPaymentProcessor processes token top-up successfully', () async {
      final gateway = ProductionPaymentProcessor();
      final result = await gateway.processPayment(
        userId: 'usr_test',
        amount: 20.0,
        currency: 'USD',
        provider: PaymentProviderType.stripe,
      );

      expect(result.isSuccess, isTrue);
      expect(result.transactionId, contains('tx_'));
      expect(result.receiptValidationSignature.isNotEmpty, isTrue);
    });

    test('FirestoreEconomyDatasource catalog and top-up operations', () async {
      final ds = FirestoreEconomyDatasource();
      final catalog = await ds.getMarketplaceCatalog();

      expect(catalog.length, greaterThanOrEqualTo(4));
      expect(catalog.first.title, contains('Glass Skin'));

      final payment = await ds.topUpTokens(
        userId: 'vanguard_2030',
        amountUsd: 19.99,
        tokenAmount: 2000,
        provider: PaymentProviderType.googlePlay,
      );

      expect(payment.isSuccess, isTrue);
    });
  });
}
