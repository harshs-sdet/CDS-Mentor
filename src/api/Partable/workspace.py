import pandas as pd
import json
import yaml
import requests as r

def get_domain_workspace(url , bearer, domain):
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

def create_workspace(data, url, bearer, domain):
    url = str(url)
    url = url.replace("{domain}", domain)
    print(url)
    Session = r.Session()
    with Session as s:
        resp = s.post(url, json = data, headers={'Content-type':'application/json','Authorization':bearer}, verify=None)
        if resp.status_code == 200:
            return resp.json()
        else:
            return 'false'

def get_specific_workspace(url , bearer, domain, workspaceId):
    # url = str(url)
    # productId = str(productId)
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

def edit_workspace(data, url, bearer, domain, workspaceId):
    url = str(url)
    url = url.replace("{domain}", domain)
    url = url.replace("{workSpaceId}", workspaceId)
    print(url)
    Session = r.Session()
    with Session as s:
        resp = s.put(url, json = data, headers={'Content-type':'application/json','Authorization':bearer}, verify=None)
        if resp.status_code == 200:
            return resp.json()
        else:
            return 'false'

def delete_workspace(url, bearer, domain, workspaceId):
    url = str(url)
    url = url.replace("{domain}", domain)
    url = url.replace("{workSpaceId}", workspaceId)
    print(url)
    Session = r.Session()
    with Session as s:
        resp = s.delete(url, headers={'Content-type':'application/json','Authorization':bearer}, verify=None)
        if resp.status_code == 200:
            return resp.json()
        else:
            return 'false'


def clone_workspace(url, bearer, domain, workspaceId):
    url = str(url)
    url = url.replace("{domain}", domain)
    url = url.replace("{workSpaceId}", workspaceId)
    print(url)
    Session = r.Session()
    with Session as s:
        resp = s.post(url, headers={'Content-type':'application/json','Authorization':bearer}, verify=None)
        if resp.status_code == 200:
            return resp.json()
        else:
            return 'false'

def read_workflow(url, bearer, domain, workspaceId):
    url = str(url)
    url = url.replace("{domain}", domain)
    url = url.replace("{workSpaceId}", workspaceId)
    print(url)
    Session = r.Session()
    with Session as s:
        resp = s.get(url, headers={'Content-type':'application/json','Authorization':bearer}, verify=None)
        if resp.status_code == 200:
            return resp.json()
        else:
            return 'false'

def create_workflow_workspace(data, url, bearer, domain, workspaceId):
    url = str(url)
    url = url.replace("{domain}", domain)
    url = url.replace("{workSpaceId}", workspaceId)
    print(url)
    Session = r.Session()
    with Session as s:
        resp = s.put(url, json = data, headers={'Content-type':'application/json','Authorization':bearer}, verify=None)
        if resp.status_code == 200:
            return resp.json()
        else:
            return 'false'