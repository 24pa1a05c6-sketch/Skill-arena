import 'package:skill_arena/core/payments/payment_gateway_contract.dart';
import 'package:skill_arena/features/economy/data/datasources/firestore_economy_datasource.dart';
import 'package:skill_arena/features/economy/domain/entities/marketplace_item.dart';
import 'package:skill_arena/features/economy/domain/entities/wallet_model.dart';
import 'package:skill_arena/features/economy/domain/repositories/economy_repository.dart';

/// Implementation of [EconomyRepository].
class EconomyRepositoryImpl implements EconomyRepository {
  final FirestoreEconomyDatasource _datasource;

  EconomyRepositoryImpl(this._datasource);

  @override
  Future<WalletModel> getWallet(String userId) {
    return _datasource.getWallet(userId);
  }

  @override
  Future<PaymentResult> topUpTokens({
    required String userId,
    required double amountUsd,
    required int tokenAmount,
    required PaymentProviderType provider,
  }) {
    return _datasource.topUpTokens(
      userId: userId,
      amountUsd: amountUsd,
      tokenAmount: tokenAmount,
      provider: provider,
    );
  }

  @override
  Future<List<MarketplaceItem>> getMarketplaceCatalog() {
    return _datasource.getMarketplaceCatalog();
  }

  @override
  Future<bool> purchaseItem(String userId, MarketplaceItem item) {
    return _datasource.purchaseItem(userId, item);
  }

  @override
  Future<void> setItemEquipped(String userId, String itemId, bool isEquipped) {
    return _datasource.setItemEquipped(userId, itemId, isEquipped);
  }
}
