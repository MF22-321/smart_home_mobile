class EnergyData {
  final double power;
  final double energy;
  final double cost;
  final DateTime time;

  EnergyData({
    required this.power,
    required this.energy,
    required this.cost,
    required this.time,
  });

  factory EnergyData.fromJson(Map<String, dynamic> json) {
    return EnergyData(
      power: (json['powerAvg'] ?? 0).toDouble(),

      /// 🔥 gunakan raw energy dulu
      energy: ((json['energy'] ?? 0) / 1000).toDouble(),

      cost: (json['costRp'] ?? 0).toDouble(),

      time: DateTime.parse(json['t']),
    );
  }
}
