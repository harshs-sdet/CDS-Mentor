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

def get_List_Of_Organizations(data):
    print(data)
    res = []
    for d in data:
        if(d["displayOrgName"]):
            res.append(d["displayOrgName"])
    print(">>>>>Lis of Orgs:")
    return res

def get_organisations(data,url, bearer):
    print(url)
    session = r.Session()
    with session as s:
        resp = s.post(url,json = data, headers={'Content-type': 'application/json', 'Authorization': bearer}, verify=None)
        if resp.status_code == 200:
            get_List_Of_Organizations(resp.json())
        else:
            return 'false'

def create_Organization(data, url, bearer):
    print(url)
    session = r.Session()
    with session as s:
        resp = s.post(url, json=data, headers={'Content-type': 'application/json', 'Authorization': bearer}, verify=None)
        if resp.status_code == 200:
            return resp.json()
        else:
            return 'false'

def sort_All_Organization(data, url, bearer):
    print(url)
    sortBy = ["organizationname", "datecreated"]
    sortOrder = ["asc", "desc"]
    for x in sortBy:
        sortUrl = url.replace("{sortBy}", x)
        print(sortUrl)
        for y in sortOrder:
            url = sortUrl.replace("{sortOrder}", y)
            print(url)
            session = r.Session()
            with session as s:
                resp = s.post(url, json=data, headers={'Content-type': 'application/json', 'Authorization': bearer},verify=None)
                if resp.status_code == 200:
                    return resp.json()
                else:
                    return 'false'

def filter_Organization(data, url, bearer):
    print(url)
    session = r.Session()
    with session as s:
        resp = s.post(url, json=data, headers={'Content-type': 'application/json', 'Authorization': bearer},
                      verify=None)
        if resp.status_code == 200:
            return resp.json()
        else:
            return 'false'

def clear_Filters(data, url, bearer):
    print(url)
    session = r.Session()
    with session as s:
        resp = s.post(url, json=data, headers={'Content-type': 'application/json', 'Authorization': bearer},
                      verify=None)
        if resp.status_code == 200:
            return resp.json()
        else:
            return 'false'

def active_Inactive_Organizations(data,url, bearer):
    session = r.Session()
    print("Count of Active Organizations")
    url = url.replace("{status}", "completed")
    with session as s:
        resp = s.post(url, json=data, headers={'Content-type': 'application/json', 'Authorization': bearer},
                      verify=None)
        if resp.status_code == 200:
            print("Count of Active Organizations")
            print(len(get_List_Of_Organizations(resp.json())))
        else:
            return 'false'

    print("Count of Inactive Organizations")
    url = url.replace("{status}", "inprogress")
    with session as s:
        resp = s.post(url, json=data, headers={'Content-type': 'application/json', 'Authorization': bearer},
                      verify=None)
        if resp.status_code == 200:
            print("Count of Inactive Organizations")
            print(len(get_List_Of_Organizations(resp.json())))
        else:
            return 'false'