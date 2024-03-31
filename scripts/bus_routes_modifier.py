import json
import os

import wget
from PIL import Image

routes = json.load(open('bus_routes_origin.json', 'r', encoding='utf-8'))
stops = json.load(open('bus_stops.json', 'r', encoding='utf-8'))
stops_dict = {}
for stop in stops:
    if stop['RouteUID'] not in stops_dict.keys():
        stops_dict[stop['RouteUID']] = {}
    stops_dict[stop['RouteUID']][str(stop['Direction'])] = stop['Stops']
new_routes = []
os_list = os.listdir('./images/')
for route in routes:
    url = route['RouteMapImageUrl']
    print(url)
    if route['RouteUID'] + '.png' not in os_list:
        wget.download(url, out='./images/' + route['RouteUID'] + '.png')
    image = Image.open('./images/' + route['RouteUID'] + '.png', 'r')
    route.pop('RouteMapImageUrl')
    route['RouteMapImage'] = {'Url': url, 'Width': image.width, 'Height': image.height}
    for subRoute in route['SubRoutes']:
        subRoute['Stops'] = stops_dict[subRoute['SubRouteUID']][str(subRoute['Direction'])]
    new_routes.append(route)
json.dump(new_routes, open('../assets/bus_routes.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
