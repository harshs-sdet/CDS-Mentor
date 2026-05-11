import requests
import re
import json
from CommonAPIRequests import CommonAPIRequests
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn


@library(scope='GLOBAL')
class AuthBearer(CommonAPIRequests):
    """This Library can be used to call login APIs and get the Auth Token along with OrgId and PersonaId

    Author: Thouhid Shariff
    Version: 0.1
    """

    def __init__(self, user_name, password):

        CommonAPIRequests.__init__(self)
        self.bearer_token = None
        self.user_name = user_name
        self.password = password
        self.session = requests.Session()
        self.headers = AuthBearer.get_default_headers()
        self.data = AuthBearer.get_default_headers()

    @staticmethod
    def get_default_headers():
        login_server_host = BuiltIn().get_variable_value("${login_server_host}")
        env_host = BuiltIn().get_variable_value("${env_base_url}")

        headers = {
            'Referer': env_host,
            'Origin': env_host,
            'Accept-Encoding': 'gzip, deflate, br',
            'User-Agent': 'PostmanRuntime/7.29.2',
            'Accept': '*/*',
            'Host': login_server_host,
            'Connection': 'keep-alive',
            'Content-Type' : 'application/x-www-form-urlencoded'
        }
        data =  {
            'grant_type':'client_credentials',
            'client_id': BuiltIn().get_variable_value("${client_resource}"),
            'client_secret': BuiltIn().get_variable_value("${client_secret}"),
            'resource': BuiltIn().get_variable_value("${client_resource}")
        }


        return data

    '''
    Below Method is used to get B2B Authetication token 
    Author: Thouhid Shariff
    '''
    @keyword("Get Auth Token")
    def get_auth_token(self, user_name=None, password=None ,set_new_password=False):

        if self.user_name != user_name:
            self.session = requests.Session()
            self.headers = AuthBearer.get_default_headers()
            self.data = AuthBearer.get_default_headers()

        headers = AuthBearer.get_default_headers()
        data = AuthBearer.get_default_headers()
        bearer_token = self.call_get_confirmed_api( data, headers )

        self.bearer_token = bearer_token
        print("bearer_token : " + bearer_token)

        return bearer_token

    def call_get_confirmed_api(self, data, headers):
        login_server_name = BuiltIn().get_variable_value("${login_server_name}")
        confirmed_url_part1 = BuiltIn().get_variable_value("${confirmed_url_part1}")

        #url = login_server_name + confirmed_url_part1 + api_props['csrf'] + '&' + confirmed_url_part2 + api_props['state_properties'] + '&' + confirmed_url_part3
        url = login_server_name + confirmed_url_part1
        req = self.session.request('POST', url, data=data, headers=headers)
        self.print_restapi_request('POST', url, headers, req)
        print(req.headers)
        substring = json.loads(req.content)

        id_token = ""
        if substring:
            id_token = substring["access_token"]



        print("id_token ::: ")
        print(id_token)

        return id_token



    def call_post_self_asserted_api(self, user_name=None, password=None):
        login_server_name = BuiltIn().get_variable_value("${login_server_name}")
        self_asserted_url_part1 = BuiltIn().get_variable_value("${self_asserted_url_part1}")
        login_server_host = BuiltIn().get_variable_value("${login_server_host}")

        # ToDo: Figure out how to use & in yaml file
        url = login_server_name + self_asserted_url_part1

        headers = dict(self.headers)
       # headers['Referer'] = self_asserted_url_referer
       # headers['Accept'] = 'application/json, text/javascript, */*; q=0.01'
        headers['Accept'] = '*/*'
        #headers['X-Requested-With'] = 'XMLHttpRequest'
       # headers['X-CSRF-TOKEN'] = api_props['csrf']
        headers['Content-Type'] = 'application/x-www-form-urlencoded'
        #headers['Host'] = login_server_host

        if user_name is None:
            user_name = self.user_name
        if password is None:
            password = self.password

        creds = {
            'grant_type':'client_credentials',
            'client_id': 'f52646c5-4976-49d9-b25c-61f4036f7aff',
            'client_secret': 'jYvZ8f9Z1d8XT_WQ~.-YAlfRQ5rtgdomb5',
            'resource': 'f52646c5-4976-49d9-b25c-61f4036f7aff'
        }

        req = self.session.request('POST', url, data=creds, headers=headers)
        self.print_restapi_request('POST', url, headers, req, creds)
        print(req.headers)
        return headers



