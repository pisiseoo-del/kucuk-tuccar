import 'dart:math';
import 'package:flutter/material.dart';
import '../core/constants/game_constants.dart';
import '../core/utils/audio_manager.dart';
import '../data/models/game_state.dart';
import '../data/repositories/game_repository.dart';

class GameProvider extends ChangeNotifier {
  final GameRepository _repo = GameRepository();
  final Random _rng = Random();
  GameState _state = const GameState();
  bool _loading = true;
  ProduceItem? _todayProduce;

  GameState get state => _state;
  bool get loading => _loading;
  ProduceItem? get todayProduce => _todayProduce;

  Future<void> init() async {
    _state = await _repo.load();
    _pickToday();
    _loading = false;
    notifyListeners();
  }

  void _pickToday() {
    _todayProduce = GameConstants.allProduce[_rng.nextInt(GameConstants.allProduce.length)];
  }

  Future<void> applyHarvestResult(HarvestResult r) async {
    final newStorage = List<StorageEntry>.from(_state.storage);
    final idx = newStorage.indexWhere((s) => s.produceId == r.produceId);
    if (idx < 0) {
      newStorage.add(StorageEntry(produceId: r.produceId, amountKg: r.totalKg));
    } else {
      newStorage[idx] = newStorage[idx].copyWith(
          amountKg: (newStorage[idx].amountKg + r.totalKg).clamp(0, GameConstants.maxStorageKg));
    }
    _state = _state.copyWith(storage: newStorage, lastHarvestProduceId: r.produceId);
    await _repo.save(_state);
    notifyListeners();
  }

  Future<int> sellProduce(String id, int amountKg) async {
    final stored = _state.storedAmount(id);
    final toSell = amountKg.clamp(0, stored);
    if (toSell == 0) return 0;

    int earned = toSell * _state.effectivePrice(id);
    if (_state.hasGoldenBasket) earned = (earned * 1.1).round();

    final newStorage = List<StorageEntry>.from(_state.storage);
    final si = newStorage.indexWhere((s) => s.produceId == id);
    if (si >= 0) {
      final rem = newStorage[si].amountKg - toSell;
      if (rem <= 0) newStorage.removeAt(si);
      else newStorage[si] = newStorage[si].copyWith(amountKg: rem);
    }

    final newMarket = List<ProduceMarketData>.from(_state.marketData);
    final mi = newMarket.indexWhere((m) => m.produceId == id);
    if (mi >= 0) newMarket[mi] = newMarket[mi].soldToday();
    else newMarket.add(ProduceMarketData(produceId: id, consecutiveSoldDays: 1));

    _state = _state.copyWith(
      moneyKurus: _state.moneyKurus + earned,
      totalEarnedKurus: _state.totalEarnedKurus + earned,
      storage: newStorage, marketData: newMarket,
    );
    await _repo.save(_state);
    AudioManager.instance.playSell();
    notifyListeners();
    return earned;
  }

  bool buyItem(ShopItemId itemId) {
    final price = _price(itemId) * 100;
    if (_state.moneyKurus < price) return false;
    if (_state.shopItems.any((s) => s.id == itemId && s.owned)) return false;
    final newItems = _state.shopItems.map((s) => s.id == itemId ? s.copyWith(owned: true) : s).toList();
    _state = _state.copyWith(moneyKurus: _state.moneyKurus - price, shopItems: newItems);
    _repo.save(_state);
    AudioManager.instance.playBuy();
    notifyListeners();
    return true;
  }

  int _price(ShopItemId id) => switch (id) {
    ShopItemId.steelScissors    => GameConstants.steelScissorsPrice,
    ShopItemId.rotMedicine      => GameConstants.rotMedicinePrice,
    ShopItemId.modifiedTractor  => GameConstants.modifiedTractorPrice,
    ShopItemId.goldenBasket     => GameConstants.goldenBasketPrice,
  };

  int itemPriceLira(ShopItemId id) => _price(id);

  Future<void> advanceDay() async {
    final newMarket = <ProduceMarketData>[];
    for (final p in GameConstants.allProduce) {
      final md = _state.marketDataFor(p.id);
      newMarket.add(p.id == _state.lastHarvestProduceId ? md : md.idleDay());
    }
    final newStorage = _state.storage.map((s) => s.copyWith(daysStored: s.daysStored + 1)).toList();
    _state = _state.copyWith(day: _state.day + 1, storage: newStorage, marketData: newMarket, lastHarvestProduceId: null);
    _pickToday();
    await _repo.save(_state);
    notifyListeners();
  }

  Future<void> resetGame() async {
    await _repo.reset();
    _state = const GameState();
    _pickToday();
    notifyListeners();
  }
}
