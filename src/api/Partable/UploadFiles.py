from time import sleep

import pandas as pd
import json
import yaml
import requests as r


def validate_files(url, bearer, domain, workspaceId):
    url = str(url)
    url = url.replace("{domain}", domain)
    url = url.replace("{workSpaceId}", workspaceId)
    print(url)
    Session = r.Session()
    with Session as s:
        resp = s.post(url,headers={'Content-type':'application/json','Authorization':bearer}, verify=None)
        sleep(360)
        if resp.status_code == 200:
            return resp.json()
        else:
            return 'false'


def deploy_files(url, bearer, domain, workspaceId):
    url = str(url)
    url = url.replace("{domain}", domain)
    url = url.replace("{workSpaceId}", workspaceId)
    print(url)
    Session = r.Session()
    with Session as s:
        resp = s.post(url,headers={'Content-type':'application/json','Authorization':bearer}, verify=None)
        if resp.status_code == 200:
            return resp.json()
        else:
            return 'false'

def get_deploy_files(url , bearer, domain, workspaceId):
    url = url.replace("{domain}", domain)
    url = url.replace("{workSpaceId}", workspaceId)
    print(url)
    print(domain)
    session = r.Session()
    with session as s:
        resp = s.get(url,headers={'Content-type': 'application/json', 'Authorization': bearer }, verify=None)
        if resp.status_code == 200:
            return resp.json()
        else:
            return 'false'