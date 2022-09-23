import 'dart:convert';
import '../model/Instrument.dart';
import 'base_api_service.dart';

class InstrumentService extends BaseApiService {
  final _getInstrumentsUrl = 'instruments';

  @override
  Future<List<Instrument>> getAllInstruments() async {
    List<Instrument> instruments = [];
    var response = await get(_getInstrumentsUrl);
    if (BaseApiService.isSuccessful(response)) {
      var decoded = json.decode(utf8.decode(response.bodyBytes));

      for (var instrument in decoded){
        instruments.add(Instrument.fromJson(instrument));
      }
      return instruments;
    }
    return [];
  }
}
