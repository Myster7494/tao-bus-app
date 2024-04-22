import json

routes: list[dict] = json.load(open('origin/route_stops.json', 'r', encoding='utf-8'))
new_routes = {}
for route in routes:
    new_route = {'RouteUID': route['RouteUID'], 'Direction': route['Direction'], 'Stops': [
        {'StopUID': stop['StopUID'], 'StopSequence': stop['StopSequence']} for stop in route['Stops']]}
    if route['RouteUID'] not in new_routes:
        new_routes[route['RouteUID']] = [new_route]
    else:
        new_routes[route['RouteUID']].append(new_route)
json.dump(new_routes, open('out/route_stops.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
