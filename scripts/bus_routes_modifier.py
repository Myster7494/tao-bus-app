import json
import os

import wget
from PIL import Image

routes = json.load(open('bus_routes_origin.json', 'r', encoding='utf-8'))
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
    new_routes.append(route)
json.dump(new_routes, open('../assets/bus_routes.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
