import json
import os

import wget
from PIL import Image

accept_keys = ['RouteName', 'DepartureStopNameZh', 'DepartureStopNameEn', 'DestinationStopNameZh',
               'DestinationStopNameEn', 'SubRoutes', 'Operators', 'RouteUID']

routes: list[dict] = json.load(open('origin/bus_routes.json', 'r', encoding='utf-8'))
new_routes = {}
img_list = os.listdir('images/')
for route in routes:
    new_route = {key: route[key] for key in route.keys() if key in accept_keys}
    new_route['Headsign'] = route['SubRoutes'][0]['Headsign']
    new_route['Operators'] = [operator['OperatorNo'] for operator in route['Operators']]
    url = route['RouteMapImageUrl']
    if url == 'route-map/phpRg2p5P.jpg':
        url = 'https://ebus.tycg.gov.tw/cms/api/route/5118/map/latest'
    print(url)
    if route['RouteUID'] + '.png' not in img_list:
        wget.download(url, out='images/' + route['RouteUID'] + '.png')
    image = Image.open('images/' + route['RouteUID'] + '.png', 'r')
    new_route['RouteMapImage'] = {'Url': url, 'Width': image.width, 'Height': image.height}
    new_route['SubRoutes'] = [{key: sub_route[key] for key in sub_route.keys() if key == 'Direction'}
                              for sub_route in route['SubRoutes']]
    new_routes[route['RouteUID']] = new_route
json.dump(new_routes, open('out/bus_routes.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
