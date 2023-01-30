import 'package:orginone/dart/base/enumeration/enum_map.dart';
import 'package:orginone/dart/base/enumeration/system_scan_data_type.dart';

class ScanResults {
  final SystemScanDataType scanResultType;
  dynamic data;

  ScanResults(this.scanResultType, this.data);

  factory ScanResults.fromMap(Map<String, dynamic> map) {
    SystemScanDataType temp =
        EnumMap.enumFromString(SystemScanDataType.values, map["type"]) ??
            SystemScanDataType.unknown;
    return ScanResults(temp, map["data"]);
  }
}
