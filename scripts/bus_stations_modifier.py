import json

stations: list[dict] = json.load(open('origin/bus_stations.json', 'r', encoding='utf-8'))
new_stations = {}
for station in stations:
    new_station = {'StationUID': station['StationUID'], 'StationName': station['StationName'],
                   'StationPosition': station['StationPosition'],
                   'Stops': list({stop['StopUID'] for stop in station['Stops']})}
    new_stations[station['StationUID']] = new_station
json.dump(new_stations, open('out/bus_stations.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
