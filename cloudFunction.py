from flask import escape, jsonify, request, make_response, Flask
from math import pow
from math import radians
from math import cos
from math import sin
from math import asin
from math import sqrt
from math import * 
from decimal import Decimal


"""
    Google Clound Function to calculate distance between two coordinates.
    Source code: (https://github.com/chirichignoa/ParkingRecommender/blob/4c1d7a4dcfa98fe459ab54cb7aaac37c68214231/HaversineDistanceService/app.py)
    Haversine: (https://en.wikipedia.org/wiki/Haversine_formula)
"""

def haversine(lon1, lat1, lon2, lat2):
    """
    Calculate the great circle distance between two points 
    on the earth (specified in decimal degrees)
    """
    # convert decimal degrees to radians 
    lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])

    # haversine formula 
    dlon = lon2 - lon1 
    dlat = lat2 - lat1 
    a = sin(dlat/2)*2 + cos(lat1) * cos(lat2) * sin(dlon/2)*2
    c = 2 * asin(sqrt(a)) 

    # 6367 km is the radius of the Earth
    meters = 6367 * c * 1000
    return meters


"""
    Function to convert degrees to radians 
"""


def degrees_to_radians(degrees):
    return degrees * pi / 180


def get_haversine(lat_s, lng_s, lat_d, lng_d):
    earth_radius_km = 6371
    d_lat = degrees_to_radians(lat_d - lat_s)
    d_lon = degrees_to_radians(lng_d - lng_s)

    a = sin(d_lat / 2) * sin(d_lat / 2) + sin(d_lon / 2) * sin(d_lon / 2) * cos(lat_s) * cos(lat_d)
    c = 2 * atan2(sqrt(a), sqrt(1 - a))
    return (earth_radius_km * c) * 1000


def hello_world(request):
    """Responds to any HTTP request.
    Args:
        request (flask.Request): HTTP request object.
    Returns:
        The response text or any set of values that can be turned into a
        Response object using
        `make_response <http://flask.pocoo.org/docs/1.0/api/#flask.Flask.make_response>`.
    """
    request_json = request.get_json()

    lat_s = float(request.args.get('lat_s', None))
    lng_s = float(request.args.get('lng_s', None))
    lat_d = float(request.args.get('lat_d', None))
    lng_d = float(request.args.get('lng_d', None))
    if (lat_s is None) or (lng_s is None) or (lat_d is None) or (lng_d is None):
        return make_response(jsonify("The request does not have neccessary parameters"), 400)
    distance = get_haversine(lat_s, lng_s, lat_d, lng_d)
    if(distance < 100):
        return make_response(jsonify(
                                {'distance': get_haversine(lat_s, lng_s, lat_d, lng_d), 'response': True}
                            ), 200)
    return make_response(jsonify(
                                {'distance': get_haversine(lat_s, lng_s, lat_d, lng_d), 'response': False}
                            ), 200)