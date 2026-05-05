class EnergyData {
  final double power;
  final double energy;
  final DateTime time;

  EnergyData({required this.power, required this.energy, required this.time});

  factory EnergyData.fromJson(Map<String, dynamic> json) {
    return EnergyData(
      power: json['power'].toDouble(),
      energy: json['energy'].toDouble(),
      time: DateTime.parse(json['created_at']),
    );
  }
}
