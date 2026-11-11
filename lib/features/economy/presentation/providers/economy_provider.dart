import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/core/payments/payment_gateway_contract.dart';
import 'package:skill_arena/features/economy/data/datasources/firestore_economy_datasource.dart';
import 'package:skill_arena/features/economy/data/repositories/economy_repository_impl.dart';
import 'package:skill_arena/features/economy/domain/entities/marketplace_item.dart';
import 'package:skill_arena/features/economy/domain/entities/wallet_model.dart';
import 'package:skill_arena/features/economy/domain/repositories/economy_repository.dart';

class EconomyState {
  final WalletModel wallet;
  final List<MarketplaceItem> catalog;
  final bool isLoading;
  final bool isPurchasing;
  final String? statusMessage;

  const EconomyState({
    this.wallet = const WalletModel(userId: 'vanguard_2030'),
    this.catalog = const [],
    this.isLoading = false,
    this.isPurchasing = false,
    this.statusMessage,
  });

  EconomyState copyWith({
    WalletModel? wallet,
    List<MarketplaceItem>? catalog,
    bool? isLoading,
    bool? isPurchasing,
    String? statusMessage,
  }) {
    return EconomyState(
      wallet: wallet ?? this.wallet,
      catalog: catalog ?? this.catalog,
      isLoading: isLoading ?? this.isLoading,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }
}

final firestoreEconomyDatasourceProvider = Provider<FirestoreEconomyDatasource>((ref) {
  return FirestoreEconomyDatasource();
});

final economyRepositoryProvider = Provider<EconomyRepository>((ref) {
  final ds = ref.watch(firestoreEconomyDatasourceProvider);
  return EconomyRepositoryImpl(ds);
});

final economyProvider = StateNotifierProvider<EconomyNotifier, EconomyState>((ref) {
  final repo = ref.watch(economyRepositoryProvider);
  return EconomyNotifier(repo);
});

class EconomyNotifier extends StateNotifier<EconomyState> {
  final EconomyRepository _repository;

  EconomyNotifier(this._repository) : super(const EconomyState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    final wallet = await _repository.getWallet('vanguard_2030');
    final catalog = await _repository.getMarketplaceCatalog();

    state = state.copyWith(
      wallet: wallet,
      catalog: catalog,
      isLoading: false,
    );
  }

  Future<void> purchaseItem(MarketplaceItem item) async {
    if (state.wallet.tokenBalance < item.priceTokens) {
      state = state.copyWith(statusMessage: 'Insufficient \$ARENA Token balance');
      return;
    }

    state = state.copyWith(isPurchasing: true);
    final success = await _repository.purchaseItem('vanguard_2030', item);

    if (success) {
      final updatedCatalog = state.catalog.map((i) {
        if (i.id == item.id) return i.copyWith(isOwned: true);
        return i;
      }).toList();

      final updatedWallet = WalletModel(
        userId: 'vanguard_2030',
        tokenBalance: state.wallet.tokenBalance - item.priceTokens,
        xpBalance: state.wallet.xpBalance,
        coins: state.wallet.coins,
      );

      state = state.copyWith(
        catalog: updatedCatalog,
        wallet: updatedWallet,
        isPurchasing: false,
        statusMessage: 'Successfully unlocked ${item.title}!',
      );
    }
  }

  Future<void> topUpTokens(double usdAmount, int tokenAmount) async {
    state = state.copyWith(isPurchasing: true);
    final result = await _repository.topUpTokens(
      userId: 'vanguard_2030',
      amountUsd: usdAmount,
      tokenAmount: tokenAmount,
      provider: PaymentProviderType.stripe,
    );

    if (result.isSuccess) {
      final updatedWallet = WalletModel(
        userId: 'vanguard_2030',
        tokenBalance: state.wallet.tokenBalance + tokenAmount,
        xpBalance: state.wallet.xpBalance,
        coins: state.wallet.coins,
      );

      state = state.copyWith(
        wallet: updatedWallet,
        isPurchasing: false,
        statusMessage: result.message,
      );
    }
  }
}
