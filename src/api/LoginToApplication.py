import requests
import re
from CommonAPIRequests import CommonAPIRequests
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn


@library(scope='GLOBAL')
class LoginToApplication(CommonAPIRequests):
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
        self.headers = LoginToApplication.get_default_headers()

    @staticmethod
    def get_default_headers():
        login_server_host = BuiltIn().get_variable_value("${login_server_host1}")
        env_host = BuiltIn().get_variable_value("${orgin}")
        headers = {
            'Referer': env_host + "/",
            'Accept-Language': 'en-US,en;q=0.5',
            'Origin': env_host,
            'Accept-Encoding': 'gzip, deflate, br',
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36',
            'Accept': '*/*',
            'Host': login_server_host,
            'Connection': 'keep-alive'
        }

        return headers
    '''
    This Method is to get Authentication Bearer for B2C
    Author: Thouhid Shariff
    '''
    @keyword("Get Auth Token B2c")
    def get_auth_token_b2c(self, user_name=None, password=None, set_new_password=False):

        if self.user_name != user_name:
            self.session = requests.Session()
            self.headers = LoginToApplication.get_default_headers()

        self.call_get_openid_configuration_api()
        api_props = self.call_get_authorize_api()
        headers = self.call_post_self_asserted_api(api_props, user_name, password)
        if set_new_password:
            bearer_token, new_csrf = self.call_get_confirmed_api(api_props, headers)
            headers = self.call_post_self_asserted_api_new_password(api_props, user_name, password, headers, new_csrf)

        bearer_token, new_csrf = self.call_get_confirmed_api(api_props, headers)

        self.bearer_token = bearer_token
        print("bearer_token : " + bearer_token)

        return bearer_token

    def call_get_openid_configuration_api(self):
        login_server_name = BuiltIn().get_variable_value("${env_b2c_url}")
        openid_configuration_url = BuiltIn().get_variable_value("${openid_configuration_url}")

        url = login_server_name + openid_configuration_url

        response = self.session.request('GET', url, headers=self.headers)
        self.print_restapi_request('GET', url, self.headers, response)

    def call_get_authorize_api(self):
        login_server_name = BuiltIn().get_variable_value("${login_server}")
        authorize_url = BuiltIn().get_variable_value("${authorize_url}")

        url = login_server_name + authorize_url

        headers = dict(self.headers)
        headers['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
        headers.pop('Origin')

        req = self.session.request('GET', url, headers=headers)
        self.print_restapi_request('GET', url, headers, req)

        state_properties = ""
        page_view_id = ""
        csrf = ""

        substring = re.search('"StateProperties=(.+?)"', str(req.content))
        if substring:
            state_properties = substring.group(1)

        substring = re.search('"pageViewId":"(.+?)"', str(req.content))
        if substring:
            page_view_id = substring.group(1)

        substring = re.search('"csrf":"(.+?)"', str(req.content))
        if substring:
            csrf = substring.group(1)

        print("state_properties : " + state_properties)
        print("page_view_id : " + page_view_id)
        print("csrf : " + csrf)
        return {'state_properties': state_properties, 'page_view_id': page_view_id, 'csrf': csrf}

    def call_post_self_asserted_api(self, api_props, user_name=None, password=None):
        login_server_name = BuiltIn().get_variable_value("${login_server}")
        self_asserted_url_part1 = BuiltIn().get_variable_value("${self_asserted_url_part1}")
        self_asserted_url_part2 = BuiltIn().get_variable_value("${self_asserted_url_part2}")
        self_asserted_url_referer = BuiltIn().get_variable_value("${self_asserted_url_referer}")
        login_server_host = BuiltIn().get_variable_value("${login_server_host1}")

        # ToDo: Figure out how to use & in yaml file
        url = login_server_name + self_asserted_url_part1 + api_props['state_properties'] + '&' + self_asserted_url_part2

        headers = dict(self.headers)
        headers['Referer'] = self_asserted_url_referer
        headers['Accept'] = 'application/json, text/javascript, */*; q=0.01'
        headers['X-Requested-With'] = 'XMLHttpRequest'
        headers['X-CSRF-TOKEN'] = api_props['csrf']
        headers['Content-Type'] = 'application/x-www-form-urlencoded; charset=UTF-8'
        headers['Host'] = login_server_host

        if user_name is None:
            user_name = self.user_name
        if password is None:
            password = self.password

        creds = {
            'request_type': 'RESPONSE',
            'signInName': user_name,
            'password': password
        }

        req = self.session.request('POST', url, data=creds, headers=headers)
        self.print_restapi_request('POST', url, headers, req, creds)
        print(req.headers)
        return headers

    def call_post_self_asserted_api_new_password(self, api_props, user_name=None, password=None, headers=None, new_csrf=None):
        login_server_name = BuiltIn().get_variable_value("${login_server}")
        self_asserted_url_part1 = BuiltIn().get_variable_value("${self_asserted_url_part1}")
        self_asserted_url_part2 = BuiltIn().get_variable_value("${self_asserted_url_part2}")
        self_asserted_url_referer = BuiltIn().get_variable_value("${self_asserted_url_referer}")
        login_server_host = BuiltIn().get_variable_value("${login_server_host1}")

        # ToDo: Figure out how to use & in yaml file
        url = login_server_name + self_asserted_url_part1 + api_props['state_properties'] + '&' + self_asserted_url_part2

        headers['X-CSRF-TOKEN'] = new_csrf

        if user_name is None:
            user_name = self.user_name
        if password is None:
            password = self.password
        creds = {
            'request_type': 'RESPONSE',
            'newPassword': password,
            'reenterPassword': password
        }

        req = self.session.request('POST', url, data=creds, headers=headers)
        self.print_restapi_request('POST', url, headers, req, creds)
        return headers

    def call_get_confirmed_api(self, api_props, headers):
        login_server_name = BuiltIn().get_variable_value("${login_server}")
        confirmed_url_part1 = BuiltIn().get_variable_value("${confirmed_url}")
        confirmed_url_part2 = BuiltIn().get_variable_value("${confirmed_url_part2}")
        confirmed_url_part3 = BuiltIn().get_variable_value("${confirmed_url_part3}")

        url = login_server_name + confirmed_url_part1 + api_props['csrf'] + '&' + confirmed_url_part2 + api_props['state_properties'] + '&' + confirmed_url_part3

        req = self.session.request('GET', url, verify=False, headers=headers, allow_redirects=False)
        self.print_restapi_request('GET', url, headers, req)
        print(req.headers)

        substring = re.search('id_token=(.+?)"', str(req.content))
        id_token = ""
        if substring:
            id_token = substring.group(1)

        csrf = re.search('"csrf":"(.+?)"', str(req.text), re.MULTILINE)
        new_csrf = ""
        if new_csrf:
            new_csrf = csrf.group(1)
        print("new_csrf ::: ")
        print(new_csrf)

        regex = r"\"csrf\":\"(.+?)\""
        matches = re.finditer(regex, str(req.text), re.MULTILINE)

        for matchNum, match in enumerate(matches, start=1):

            print("Match {matchNum} was found at {start}-{end}: {match}".format(matchNum=matchNum, start=match.start(),
                                                                                end=match.end(), match=match.group()))

            for groupNum in range(0, len(match.groups())):
                groupNum = groupNum + 1

                print("Group {groupNum} found at {start}-{end}: {group}".format(groupNum=groupNum,
                                                                                start=match.start(groupNum),
                                                                                end=match.end(groupNum),
                                                                                group=match.group(groupNum)))
                new_csrf = match.group(groupNum)

        print("new_csrf ::: ")
        print(new_csrf)

        print("id_token ::: ")
        print(id_token)

        return id_token, new_csrf

    @keyword()
    def get_user_details_with_oid_api(self, bearer_token=None):
        if bearer_token is None:
            bearer_token = self.bearer_token
        env_host = BuiltIn().get_variable_value("${env_b2c_url}")
        user_oid = BuiltIn().get_variable_value("${user_oid_get}")

        headers = {
            'Referer': env_host,
            'Accept': 'application/json, text/plain, */*',
            'Authorization': 'Bearer ' + bearer_token
        }

        if env_host.endswith('/'):
            env_host = env_host[:-1]

        req = self.session.request('GET', env_host + user_oid, verify=False, headers=headers)
        self.print_restapi_request('GET', env_host + user_oid, headers, req)

        status = self.validate_response_code_message(req, 200, None)

        req_json = req.json()
        user_details = {}
        if status:
            user_details = {'organizationId': req_json['data']['organizationId'], 'persona': req_json['data']['persona'], 'oId': req_json['data']['oId']}

        return user_details
