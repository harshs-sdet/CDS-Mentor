import pandas as pd
import json
import yaml
import requests as r


def get_notifications_api(url, bearer, domain):
    url = str(url)
    url = url.replace("{domain}", domain)
    print(url)
    Session = r.Session()
    with Session as s:
        resp = s.post(url,headers={'Content-type':'application/json','Authorization':bearer}, verify=None)
        if resp.status_code == 200:
            return resp.json()
        else:
            return 'false'


def get_notification_count(url , bearer, domain):
    url = url.replace("{domain}", domain)
    print(url)
    print(domain)
    session = r.Session()
    with session as s:
        resp = s.get(url,headers={'Content-type': 'application/json', 'Authorization': bearer }, verify=None)
        if resp.status_code == 200:
            return resp.json()
        else:
            return 'false'


def read_all_notifications(url, bearer,domain ):
    # authentication={"Authorization" : bearer}
    payload = {"targetId":["d0bbd96e368c4207b52d9d5f18ff855b","wsorgtest20220230522170735"]}
    url = str(url)
    url = url.replace("{domain}", domain)
    print(url)
    Session = r.Session()
    with Session as s:
        resp = s.put(url, params = payload, headers={'Content-type': 'application/json', 'Authorization': bearer}, verify=None)
        if resp.status_code == 200:
            return resp.json()
        else:
            return 'false'


def get_notification_count(url , bearer, domain):
    url = url.replace("{domain}", domain)
    print(url)
    print(domain)
    session = r.Session()
    with session as s:
        resp = s.get(url,headers={'Content-type': 'application/json', 'Authorization': bearer }, verify=None)
        if resp.status_code == 200:
            return resp.json()
        else:
            return 'false'

