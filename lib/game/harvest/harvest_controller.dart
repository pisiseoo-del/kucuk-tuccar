import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/game_constants.dart';
import '../../data/models/game_state.dart';

enum FruitType { normal, golden, rotten }

class FallingObject {
  final String emoji;
  final FruitType type;
  double x;
  double y;
  final double fallSpeed;
  bool get isRotten => type == FruitType.rotten;
  bool get isGolden => type == FruitType.golden;
  FallingObject({required this.emoji, required this.type, required this.x, required this.y, required this.fallSpeed});
}

class HarvestController extends ChangeNotifier {
  final ProduceItem produce;
  final GameState gameState;
  final Random _rng = Random();

  double _secondsLeft = GameConstants.harvestDurationSeconds.toDouble();
  double get secondsLeft => _secondsLeft;
  final List<FallingObject> objects = [];
  double catcherX = 0.5;
  double _catcherDir = 1.0;
  int normalCaught = 0;
  int goldenCaught = 0;
  int missed = 0;
  bool _finished = false;
  bool get finished => _finished;

  double get catcherWidth => gameState.hasScissors || gameState.hasGoldenBasket
      ? GameConstants.basketWidthUpgraded
      : GameConstants.basketWidth;

  HarvestController({required this.produce, required this.gameState});

  void tick(double dt, double screenWidth) {
    if (_finished) return;
    final speed = produce.harvestType == HarvestType.truckLoad
        ? (gameState.hasTractor ? GameConstants.truckSpeedUpgraded : GameConstants.truckSpeed)
        : produce.harvestType == HarvestType.bladeCut
            ? GameConstants.bladeSpeed
            : GameConstants.basketSpeed;
    catcherX += _catcherDir * speed * dt / screenWidth;
    if (catcherX >= 0.92) { catcherX = 0.92; _catcherDir = -1; }
    if (catcherX <= 0.08) { catcherX = 0.08; _catcherDir =  1; }
    if (_rng.nextDouble() < 0.04) _spawn();
    final toRemove = <FallingObject>[];
    for (final o in objects) {
      o.y += o.fallSpeed * dt;
      if (o.y > 1.1) { if (!o.isRotten) missed++; toRemove.add(o); }
    }
    for (final o in toRemove) objects.remove(o);
    _secondsLeft -= dt;
    if (_secondsLeft <= 0) { _secondsLeft = 0; _finish(); }
    notifyListeners();
  }

  void _spawn() {
    final roll = _rng.nextDouble();
    final rotChance = gameState.hasMedicine ? GameConstants.rottenFruitChance * 0.4 : GameConstants.rottenFruitChance;
    FruitType type;
    if (roll < rotChance) {
      type = FruitType.rotten;
    } else if (roll < rotChance + GameConstants.goldenFruitChance) {
      type = FruitType.golden;
    } else {
      type = FruitType.normal;
    }
    objects.add(FallingObject(
      x: 0.1 + _rng.nextDouble() * 0.8,
      y: -0.05,
      fallSpeed: 0.18 + _rng.nextDouble() * 0.22,
      type: type,
      emoji: type == FruitType.rotten ? '🤢' : type == FruitType.golden ? '⭐' : produce.emoji,
    ));
  }

  void onTap(double tapX, double screenWidth) {
    if (_finished) return;
    final norm = tapX / screenWidth;
    final half = catcherWidth / 2 / screenWidth;
    final toRemove = <FallingObject>[];
    for (final o in objects) {
      if ((o.x - norm).abs() < half && o.y > 0.45 && o.y < 0.95) {
        toRemove.add(o);
        if (o.type == FruitType.rotten) {
          normalCaught = (normalCaught - GameConstants.rottenPenalty).clamp(0, 9999);
        } else if (o.type == FruitType.golden) {
          goldenCaught++;
        } else {
          normalCaught++;
        }
      }
    }
    for (final o in toRemove) objects.remove(o);
    notifyListeners();
  }

  void _finish() { _finished = true; objects.clear(); notifyListeners(); }

  HarvestResult get result => HarvestResult(
    produceId: produce.id, normalCount: normalCaught,
    goldenCount: goldenCaught, missedCount: missed,
  );
}
