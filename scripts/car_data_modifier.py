import json

accept_keys = ["PurchaseTime", "HasWifi", "HasLiftOrRamp", "IsLowFloor", "IsHybrid", "IsElectric", "CardReaderLayout",
               "VehicleType", "VehicleClass", "OperatorNo", "PlateNumb"]

bus_data: list[dict] = json.load(open('origin/car_data.json', 'r', encoding='utf-8'))
new_bus_data_map = {}
for single_bus_data in bus_data:
    new_bus_data = {key: single_bus_data[key] for key in single_bus_data.keys() if key in accept_keys}
    new_bus_data_map[single_bus_data['PlateNumb']] = new_bus_data
json.dump(new_bus_data_map, open('out/car_data.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
