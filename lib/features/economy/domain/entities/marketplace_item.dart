import 'package:equatable/equatable.dart';

enum ItemRarity { common, rare, epic, legendary }

class MarketplaceItem extends Equatable {
  final String id;
  final String title;
  final String category;
  final String description;
  final int priceTokens;
  final ItemRarity rarity;
  final bool isOwned;
  final bool isEquipped;

  const MarketplaceItem({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.priceTokens,
    this.rarity = ItemRarity.rare,
    this.isOwned = false,
    this.isEquipped = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
      'priceTokens': priceTokens,
      'rarity': rarity.name,
      'isOwned': isOwned,
      'isEquipped': isEquipped,
    };
  }

  factory MarketplaceItem.fromMap(Map<String, dynamic> map) {
    return MarketplaceItem(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? 'Cyber Item',
      category: map['category'] as String? ?? 'Skins',
      description: map['description'] as String? ?? 'SADL Design Asset',
      priceTokens: map['priceTokens'] as int? ?? 100,
      rarity: ItemRarity.values.firstWhere((e) => e.name == map['rarity'], orElse: () => ItemRarity.rare),
      isOwned: map['isOwned'] as bool? ?? false,
      isEquipped: map['isEquipped'] as bool? ?? false,
    );
  }

  MarketplaceItem copyWith({bool? isOwned, bool? isEquipped}) {
    return MarketplaceItem(
      id: id,
      title: title,
      category: category,
      description: description,
      priceTokens: priceTokens,
      rarity: rarity,
      isOwned: isOwned ?? this.isOwned,
      isEquipped: isEquipped ?? this.isEquipped,
    );
  }

  @override
  List<Object?> get props => [id, title, priceTokens, rarity, isOwned, isEquipped];
}
