import 'package:skill_arena/core/payments/payment_gateway_contract.dart';
import 'package:skill_arena/features/economy/domain/entities/marketplace_item.dart';
import 'package:skill_arena/features/economy/domain/entities/wallet_model.dart';

/// Repository contract for Phase 8 Digital Economy, Marketplace & Wallet Engine.
abstract class EconomyRepository {
  /// Fetches user wallet balance & transaction history.
  Future<WalletModel> getWallet(String userId);

  /// Top-up wallet tokens using designated payment provider.
  Future<PaymentResult> topUpTokens({
    required String userId,
    required double amountUsd,
    required int tokenAmount,
    required PaymentProviderType provider,
  });

  /// Fetches marketplace Vault items catalog.
  Future<List<MarketplaceItem>> getMarketplaceCatalog();

  /// Purchases a marketplace item.
  Future<bool> purchaseItem(String userId, MarketplaceItem item);

  /// Equips or unequips an inventory item.
  Future<void> setItemEquipped(String userId, String itemId, bool isEquipped);
}
