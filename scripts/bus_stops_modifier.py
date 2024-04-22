import json

stops: list[dict] = json.load(open('origin/bus_stops.json', 'r', encoding='utf-8'))
new_stops = {}
for stop in stops:
    new_stop = {'StopUID': stop['StopUID'], 'StopPosition': stop['StopPosition'],
                'StationUID': 'TAO' + stop['StationID'], 'StopName': stop['StopName']}
    new_stops[stop['StopUID']] = new_stop
json.dump(new_stops, open('out/bus_stops.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
