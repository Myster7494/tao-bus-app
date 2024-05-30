import json

from geopy.distance import geodesic

stations: list[dict] = json.load(open('origin/bus_stations.json', 'r', encoding='utf-8'))
new_stations = {}
group_stations = []
for station in stations:
    english_name = None
    for stop in station['Stops']:
        if stop['StopName']['Zh_tw'] == station['StationName']['Zh_tw']:
            if 'En' in stop['StopName'].keys():
                english_name = stop['StopName']['En']
                break
    new_station = {'StationUID': station['StationUID'],
                   'StationName': station['StationName'],
                   'StationPosition': station['StationPosition'],
                   'Stops': list({stop['StopUID'] for stop in station['Stops']})}
    if english_name is not None:
        new_station['StationName']['En'] = english_name
    new_stations[station['StationUID']] = new_station
    for group_station in group_stations:
        if new_station['StationName']['Zh_tw'] == group_station['StationName']['Zh_tw'] and geodesic(
                (new_station['StationPosition']['PositionLat'], new_station['StationPosition']['PositionLon']),
                (group_station['StationPosition']['PositionLat'],
                 group_station['StationPosition']['PositionLon'])).m <= 500:
            group_station['Stations'].append(station['StationUID'])
            group_station['StationPosition']['PositionLat'] = round((group_station['StationPosition']['PositionLat'] * (
                    len(group_station['Stations']) - 1) + new_station['StationPosition']['PositionLat']) / len(
                group_station['Stations']), 6)
            group_station['StationPosition']['PositionLon'] = round((group_station['StationPosition']['PositionLon'] * (
                    len(group_station['Stations']) - 1) + new_station['StationPosition']['PositionLon']) / len(
                group_station['Stations']), 6)
            break
    else:
        group_stations.append(
            {'StationName': new_station['StationName'], 'StationPosition': new_station['StationPosition'],
             'Stations': [station['StationUID']]})
json.dump(new_stations, open('out/bus_stations.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
json.dump(group_stations, open('out/group_stations.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
