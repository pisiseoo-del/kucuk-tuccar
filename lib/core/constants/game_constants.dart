import 'package:flutter/material.dart';

enum HarvestType { treeShake, truckLoad, bladeCut }

enum Region { blackSea, mediterranean, aegean, marmara, southeast, central }

class ProduceItem {
  final String id;
  final String emoji;
  final String nameTr;
  final String originTr;
  final Region region;
  final HarvestType harvestType;
  final int basePrice;
  final List<Color> bgGradient;
  final String particleEmoji;

  const ProduceItem({
    required this.id, required this.emoji, required this.nameTr,
    required this.originTr, required this.region, required this.harvestType,
    required this.basePrice, required this.bgGradient, required this.particleEmoji,
  });
}

class GameConstants {
  GameConstants._();
  static const int harvestDurationSeconds = 30;
  static const double goldenFruitChance   = 0.05;
  static const double rottenFruitChance   = 0.10;
  static const int    rottenPenalty       = 3;
  static const int    goldenMultiplier    = 5;
  static const double basketWidth         = 100.0;
  static const double basketWidthUpgraded = 140.0;
  static const double basketSpeed         = 200.0;
  static const double truckSpeed          = 180.0;
  static const double truckSpeedUpgraded  = 110.0;
  static const double bladeSpeed          = 160.0;
  static const int    maxStorageKg        = 200;
  static const double repeatSellPenalty   = 0.15;
  static const double idleBonus           = 0.25;
  static const int    maxIdleDays         = 4;
  static const int    steelScissorsPrice  = 800;
  static const int    rotMedicinePrice    = 600;
  static const int    modifiedTractorPrice= 1000;
  static const int    goldenBasketPrice   = 1200;
  static const int    startingMoney       = 200;

  static const List<ProduceItem> allProduce = [
    ProduceItem(id:'hazelnut', emoji:'🌰', nameTr:'Giresun Fındığı', originTr:'Giresun, Karadeniz',
      region:Region.blackSea, harvestType:HarvestType.treeShake, basePrice:4500,
      bgGradient:[Color(0xFF1B4332),Color(0xFF40916C),Color(0xFFB7E4C7)], particleEmoji:'🍃'),
    ProduceItem(id:'tea', emoji:'🍵', nameTr:'Rize Çayı', originTr:'Rize, Karadeniz',
      region:Region.blackSea, harvestType:HarvestType.bladeCut, basePrice:2000,
      bgGradient:[Color(0xFF0D3B2E),Color(0xFF1B4332),Color(0xFFD8F3DC)], particleEmoji:'🌿'),
    ProduceItem(id:'watermelon_a', emoji:'🍉', nameTr:'Adana Karpuzu', originTr:'Adana, Akdeniz',
      region:Region.mediterranean, harvestType:HarvestType.truckLoad, basePrice:900,
      bgGradient:[Color(0xFFFF6B35),Color(0xFFFF3838),Color(0xFFFFD700)], particleEmoji:'☀️'),
    ProduceItem(id:'banana', emoji:'🍌', nameTr:'Anamur Muzu', originTr:'Anamur, Akdeniz',
      region:Region.mediterranean, harvestType:HarvestType.treeShake, basePrice:1800,
      bgGradient:[Color(0xFFFF8C00),Color(0xFFFFD700),Color(0xFFFFF9C4)], particleEmoji:'🌴'),
    ProduceItem(id:'fig', emoji:'🫐', nameTr:'Aydın İnciri', originTr:'Aydın, Ege',
      region:Region.aegean, harvestType:HarvestType.bladeCut, basePrice:3200,
      bgGradient:[Color(0xFF6A0572),Color(0xFF8B5CF6),Color(0xFFE9D5FF)], particleEmoji:'🌾'),
    ProduceItem(id:'apricot', emoji:'🍑', nameTr:'Malatya Kayısısı', originTr:'Malatya, Doğu Anadolu',
      region:Region.aegean, harvestType:HarvestType.treeShake, basePrice:2800,
      bgGradient:[Color(0xFFD97706),Color(0xFFF59E0B),Color(0xFFFDE68A)], particleEmoji:'✨'),
    ProduceItem(id:'apple', emoji:'🍎', nameTr:'Amasya Elması', originTr:'Amasya, Karadeniz',
      region:Region.marmara, harvestType:HarvestType.treeShake, basePrice:1500,
      bgGradient:[Color(0xFFDC2626),Color(0xFFEF4444),Color(0xFFFEE2E2)], particleEmoji:'🍂'),
    ProduceItem(id:'peach', emoji:'🍑', nameTr:'Bursa Şeftalisi', originTr:'Bursa, Marmara',
      region:Region.marmara, harvestType:HarvestType.treeShake, basePrice:2200,
      bgGradient:[Color(0xFFFF7F7F),Color(0xFFFFB347),Color(0xFFFFF0E0)], particleEmoji:'🌸'),
    ProduceItem(id:'watermelon_d', emoji:'🍉', nameTr:'Diyarbakır Karpuzu', originTr:'Diyarbakır, Güneydoğu',
      region:Region.southeast, harvestType:HarvestType.truckLoad, basePrice:1100,
      bgGradient:[Color(0xFF166534),Color(0xFF16A34A),Color(0xFFBBF7D0)], particleEmoji:'🌵'),
    ProduceItem(id:'pistachio', emoji:'🫘', nameTr:'Gaziantep Fıstığı', originTr:'Gaziantep, Güneydoğu',
      region:Region.southeast, harvestType:HarvestType.treeShake, basePrice:8000,
      bgGradient:[Color(0xFF92400E),Color(0xFFD97706),Color(0xFFFEF3C7)], particleEmoji:'🏺'),
    ProduceItem(id:'garlic', emoji:'🧄', nameTr:'Taşköprü Sarımsağı', originTr:'Kastamonu',
      region:Region.central, harvestType:HarvestType.bladeCut, basePrice:3500,
      bgGradient:[Color(0xFF78716C),Color(0xFFA8A29E),Color(0xFFF5F5F4)], particleEmoji:'💨'),
    ProduceItem(id:'potato', emoji:'🥔', nameTr:'Niğde Patatesi', originTr:'Niğde, İç Anadolu',
      region:Region.central, harvestType:HarvestType.truckLoad, basePrice:700,
      bgGradient:[Color(0xFF57534E),Color(0xFF78716C),Color(0xFFE7E5E4)], particleEmoji:'🌾'),
  ];
}
