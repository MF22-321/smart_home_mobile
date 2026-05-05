import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_home_mobile/model/energy_model.dart';

Future<List<EnergyData>> fetchEnergy({
  required String deviceId,
  String range = "1h",
}) async {
  final url = Uri.parse(
    "http://YOUR_API/pzem?device_id=$deviceId&range=$range",
  );

  final res = await http.get(url);

  if (res.statusCode == 200) {
    final List data = jsonDecode(res.body);

    return data.map((e) => EnergyData.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load data");
  }
}
