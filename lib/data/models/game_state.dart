import 'dart:convert';
import 'package:equatable/equatable.dart';
import '../../core/constants/game_constants.dart';

enum ShopItemId { steelScissors, rotMedicine, modifiedTractor, goldenBasket }

class ShopItem extends Equatable {
  final ShopItemId id;
  final bool owned;
  const ShopItem({required this.id, this.owned = false});
  ShopItem copyWith({bool? owned}) => ShopItem(id: id, owned: owned ?? this.owned);
  @override List<Object?> get props => [id, owned];
}

class StorageEntry extends Equatable {
  final String produceId;
  final int amountKg;
  final int daysStored;
  const StorageEntry({required this.produceId, required this.amountKg, this.daysStored = 0});
  StorageEntry copyWith({int? amountKg, int? daysStored}) =>
      StorageEntry(produceId: produceId, amountKg: amountKg ?? this.amountKg, daysStored: daysStored ?? this.daysStored);
  Map<String, dynamic> toJson() => {'id': produceId, 'kg': amountKg, 'days': daysStored};
  factory StorageEntry.fromJson(Map<String, dynamic> j) =>
      StorageEntry(produceId: j['id'] as String, amountKg: j['kg'] as int, daysStored: j['days'] as int);
  @override List<Object?> get props => [produceId, amountKg, daysStored];
}

enum PriceTrend { high, normal, low }

class ProduceMarketData extends Equatable {
  final String produceId;
  final int consecutiveSoldDays;
  final int idleDays;
  const ProduceMarketData({required this.produceId, this.consecutiveSoldDays = 0, this.idleDays = 0});

  double get priceMultiplier {
    final penalty = consecutiveSoldDays * GameConstants.repeatSellPenalty;
    final bonus   = idleDays.clamp(0, GameConstants.maxIdleDays) * GameConstants.idleBonus;
    return (1.0 - penalty + bonus).clamp(0.4, 2.5);
  }

  PriceTrend get trend {
    final m = priceMultiplier;
    if (m >= 1.3) return PriceTrend.high;
    if (m <= 0.75) return PriceTrend.low;
    return PriceTrend.normal;
  }

  ProduceMarketData soldToday() => ProduceMarketData(produceId: produceId, consecutiveSoldDays: consecutiveSoldDays + 1, idleDays: 0);
  ProduceMarketData idleDay()   => ProduceMarketData(produceId: produceId, consecutiveSoldDays: 0, idleDays: idleDays + 1);

  Map<String, dynamic> toJson() => {'id': produceId, 'sold': consecutiveSoldDays, 'idle': idleDays};
  factory ProduceMarketData.fromJson(Map<String, dynamic> j) =>
      ProduceMarketData(produceId: j['id'] as String, consecutiveSoldDays: j['sold'] as int, idleDays: j['idle'] as int);
  @override List<Object?> get props => [produceId, consecutiveSoldDays, idleDays];
}

class HarvestResult {
  final String produceId;
  final int normalCount;
  final int goldenCount;
  final int missedCount;
  const HarvestResult({required this.produceId, required this.normalCount, required this.goldenCount, required this.missedCount});
  int get totalKg => normalCount + goldenCount * GameConstants.goldenMultiplier;
}

class GameState extends Equatable {
  final int day;
  final int moneyKurus;
  final int totalEarnedKurus;
  final List<StorageEntry> storage;
  final List<ProduceMarketData> marketData;
  final List<ShopItem> shopItems;
  final String? lastHarvestProduceId;

  const GameState({
    this.day = 1,
    this.moneyKurus = GameConstants.startingMoney * 100,
    this.totalEarnedKurus = 0,
    this.storage = const [],
    this.marketData = const [],
    this.shopItems = const [
      ShopItem(id: ShopItemId.steelScissors),
      ShopItem(id: ShopItemId.rotMedicine),
      ShopItem(id: ShopItemId.modifiedTractor),
      ShopItem(id: ShopItemId.goldenBasket),
    ],
    this.lastHarvestProduceId,
  });

  bool get hasScissors    => shopItems.any((s) => s.id == ShopItemId.steelScissors   && s.owned);
  bool get hasMedicine    => shopItems.any((s) => s.id == ShopItemId.rotMedicine      && s.owned);
  bool get hasTractor     => shopItems.any((s) => s.id == ShopItemId.modifiedTractor  && s.owned);
  bool get hasGoldenBasket=> shopItems.any((s) => s.id == ShopItemId.goldenBasket     && s.owned);

  double get moneyLira   => moneyKurus / 100.0;
  String get moneyDisplay => moneyLira >= 10 ? moneyLira.toStringAsFixed(0) : moneyLira.toStringAsFixed(2);

  int storedAmount(String id) {
    final e = storage.where((s) => s.produceId == id);
    return e.isEmpty ? 0 : e.first.amountKg;
  }

  ProduceMarketData marketDataFor(String id) {
    final e = marketData.where((m) => m.produceId == id);
    return e.isEmpty ? ProduceMarketData(produceId: id) : e.first;
  }

  int effectivePrice(String id) {
    final p = GameConstants.allProduce.firstWhere((p) => p.id == id);
    return (p.basePrice * marketDataFor(id).priceMultiplier).round();
  }

  GameState copyWith({
    int? day, int? moneyKurus, int? totalEarnedKurus,
    List<StorageEntry>? storage, List<ProduceMarketData>? marketData,
    List<ShopItem>? shopItems, String? lastHarvestProduceId,
  }) => GameState(
    day: day ?? this.day, moneyKurus: moneyKurus ?? this.moneyKurus,
    totalEarnedKurus: totalEarnedKurus ?? this.totalEarnedKurus,
    storage: storage ?? this.storage, marketData: marketData ?? this.marketData,
    shopItems: shopItems ?? this.shopItems,
    lastHarvestProduceId: lastHarvestProduceId ?? this.lastHarvestProduceId,
  );

  Map<String, dynamic> toJson() => {
    'day': day, 'money': moneyKurus, 'total': totalEarnedKurus,
    'storage': storage.map((s) => s.toJson()).toList(),
    'market':  marketData.map((m) => m.toJson()).toList(),
    'shop':    shopItems.map((s) => {'id': s.id.index, 'owned': s.owned}).toList(),
    'lastProduce': lastHarvestProduceId,
  };

  factory GameState.fromJson(Map<String, dynamic> j) => GameState(
    day: j['day'] as int, moneyKurus: j['money'] as int, totalEarnedKurus: j['total'] as int,
    storage:    (j['storage'] as List).map((e) => StorageEntry.fromJson(e as Map<String, dynamic>)).toList(),
    marketData: (j['market']  as List).map((e) => ProduceMarketData.fromJson(e as Map<String, dynamic>)).toList(),
    shopItems:  (j['shop']    as List).map((e) => ShopItem(id: ShopItemId.values[e['id'] as int], owned: e['owned'] as bool)).toList(),
    lastHarvestProduceId: j['lastProduce'] as String?,
  );

  String toJsonString() => jsonEncode(toJson());
  factory GameState.fromJsonString(String s) => GameState.fromJson(jsonDecode(s) as Map<String, dynamic>);

  @override List<Object?> get props => [day, moneyKurus, totalEarnedKurus, storage, marketData, shopItems, lastHarvestProduceId];
}
