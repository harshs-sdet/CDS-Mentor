import pandas as pd
import json
import yaml
import requests as r

def deploy_assets(url, bearer, domain):
    url = url.replace("{domain}", domain)
    print(url)
    print(domain)
    session = r.Session()
    with session as s:
        resp = s.get(url, headers={'Content-type': 'application/json', 'Authorization': bearer}, verify=None)
        if resp.status_code == 200:
            return resp.json()
        else:
            return 'false'

def monitor_tasks(url, bearer, domain,workspaceId):
    url = url.replace("{domain}", domain)
    url = url.replace("{workSpaceId}", workspaceId)
    print(url)
    print(domain)
    session = r.Session()
    with session as s:
        resp = s.get(url, headers={'Content-type': 'application/json', 'Authorization': bearer}, verify=None)
        if resp.status_code == 200:
            return resp.json()
        else:
            return 'false'