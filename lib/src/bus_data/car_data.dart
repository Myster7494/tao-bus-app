import 'package:bus_app/src/bus_data/bus.dart';
import 'package:json_annotation/json_annotation.dart';

part 'car_data.g.dart';

@JsonSerializable()
class CarData {
  @JsonKey(name: "PlateNumb")
  final String plateNumb;
  @JsonKey(name: "OperatorNo")
  final OperatorNo operatorNo;
  @JsonKey(name: "VehicleClass")
  final int vehicleClass;
  @JsonKey(name: "VehicleType")
  final int vehicleType;
  @JsonKey(name: "CardReaderLayout")
  final int cardReaderLayout;
  @JsonKey(name: "IsElectric")
  final int isElectric;
  @JsonKey(name: "IsHybrid")
  final int isHybrid;
  @JsonKey(name: "IsLowFloor")
  final int isLowFloor;
  @JsonKey(name: "HasLiftOrRamp")
  final int hasLiftOrRamp;
  @JsonKey(name: "HasWifi")
  final int hasWifi;

  CarData({
    required this.plateNumb,
    required this.operatorNo,
    required this.vehicleClass,
    required this.vehicleType,
    required this.cardReaderLayout,
    required this.isElectric,
    required this.isHybrid,
    required this.isLowFloor,
    required this.hasLiftOrRamp,
    required this.hasWifi,
  });

  factory CarData.fromJson(Map<String, dynamic> json) =>
      _$CarDataFromJson(json);

  Map<String, dynamic> toJson() => _$CarDataToJson(this);
}
