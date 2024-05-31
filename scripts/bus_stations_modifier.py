import json

from geopy.distance import geodesic

stations: list[dict] = json.load(open('origin/bus_stations.json', 'r', encoding='utf-8'))
new_stations = {}
group_stations = {}
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
    for group_station in group_stations.values():
        if new_station['StationName']['Zh_tw'] == group_station['GroupStationName'][
            'Zh_tw'] and geodesic(
            (new_station['StationPosition']['PositionLat'], new_station['StationPosition']['PositionLon']),
            (group_station['GroupStationPosition']['PositionLat'],
             group_station['GroupStationPosition']['PositionLon'])).m <= 500:
            if group_station['GroupStationUID'] == "TAO1":
                print()
            new_station['GroupStationUID'] = group_station['GroupStationUID']
            group_station['Stations'].append(new_station['StationUID'])
            print(group_station['GroupStationPosition']['PositionLat'], end=' | ')
            group_station['GroupStationPosition']['PositionLat'] = round(
                (group_station['GroupStationPosition']['PositionLat'] * (
                        len(group_station['Stations']) - 1)
                 + new_station['StationPosition']['PositionLat']
                 )
                / len(
                    group_station['Stations']), 6)
            print(group_station['GroupStationPosition']['PositionLat'], end=' | ')
            print(group_station['GroupStationPosition']['PositionLon'], end=' | ')
            group_station['GroupStationPosition']['PositionLon'] = round(
                (group_station['GroupStationPosition']['PositionLon'] * (
                        len(group_station['Stations']) - 1)
                 + new_station['StationPosition']['PositionLon']
                 ) / len(
                    group_station['Stations']), 6)
            print(group_station['GroupStationPosition']['PositionLon'])
            group_stations[group_station['GroupStationUID']] = group_station
            break
    else:
        new_station['GroupStationUID'] = new_station['StationUID']
        group_stations[new_station['StationUID']] = {'GroupStationUID': new_station['StationUID'],
                                                     'GroupStationName': new_station['StationName'],
                                                     'GroupStationPosition': {
                                                         'PositionLon': new_station['StationPosition']['PositionLon'],
                                                         'PositionLat': new_station['StationPosition']['PositionLat']},
                                                     'Stations': [new_station['StationUID']]}
    new_stations[new_station['StationUID']] = new_station
json.dump(new_stations, open('out/bus_stations.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
json.dump(group_stations, open('out/group_stations.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
