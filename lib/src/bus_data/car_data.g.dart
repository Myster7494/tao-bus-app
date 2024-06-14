// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarData _$CarDataFromJson(Map<String, dynamic> json) => CarData(
      plateNumb: json['PlateNumb'] as String,
      operatorNo: $enumDecode(_$OperatorNoEnumMap, json['OperatorNo']),
      vehicleClass: (json['VehicleClass'] as num).toInt(),
      vehicleType: (json['VehicleType'] as num).toInt(),
      cardReaderLayout: (json['CardReaderLayout'] as num).toInt(),
      isElectric: (json['IsElectric'] as num).toInt(),
      isHybrid: (json['IsHybrid'] as num).toInt(),
      isLowFloor: (json['IsLowFloor'] as num).toInt(),
      hasLiftOrRamp: (json['HasLiftOrRamp'] as num).toInt(),
      hasWifi: (json['HasWifi'] as num).toInt(),
    );

Map<String, dynamic> _$CarDataToJson(CarData instance) => <String, dynamic>{
      'PlateNumb': instance.plateNumb,
      'OperatorNo': _$OperatorNoEnumMap[instance.operatorNo]!,
      'VehicleClass': instance.vehicleClass,
      'VehicleType': instance.vehicleType,
      'CardReaderLayout': instance.cardReaderLayout,
      'IsElectric': instance.isElectric,
      'IsHybrid': instance.isHybrid,
      'IsLowFloor': instance.isLowFloor,
      'HasLiftOrRamp': instance.hasLiftOrRamp,
      'HasWifi': instance.hasWifi,
    };

const _$OperatorNoEnumMap = {
  OperatorNo.CHUNGLI_BUS: '0404',
  OperatorNo.HSINCHU_BUS: '1303',
  OperatorNo.JASUN_BUS: '1103',
  OperatorNo.JINGYANG_BUS: '0915',
  OperatorNo.JINTAI_BUS: '0806',
  OperatorNo.SANCHUNG_BUS: '0301',
  OperatorNo.TAOYUAN_BUS: '1002',
  OperatorNo.UNITED_HIGHWAY_BUS: '1201',
  OperatorNo.YACHENG_BUS: '0704',
  OperatorNo.YATUNG_BUS: '0702',
  OperatorNo.ZHINAN_BUS: '0907',
};
