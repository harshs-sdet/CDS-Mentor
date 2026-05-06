import pprint
import copy
import json
import requests
from CommonAPIRequests import CommonAPIRequests
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn


@library(scope='GLOBAL')
class AlertsAPI(CommonAPIRequests):
    """This Library can be used to call login APIs and get the Auth Token along with OrgId and PersonaId

    Author: Thouhid Shariff
    Version: 0.1
    """

    def __init__(self):
        CommonAPIRequests.__init__(self)

        self.session = requests.Session()

    ''' 
    This api will send alerts information to the users by email and sms.
    Author: Thouhid Shariff
    https://cxportal-dev.dovertech.co.in/api/alerts/docs/#/default/post_api_alerts_sendAlerts  (Swagger url)
    '''
    @keyword("Execute Send Alerts")
    def execute_send_alerts(self, auth_token):
        base_url = BuiltIn().get_variable_value("${env_base_url}")
        get_url = BuiltIn().get_variable_value("${Send_alerts}")
        url = base_url + get_url
        print (url)

        body = BuiltIn().get_variable_value("${execute_send_alerts_body}")
        body.opco = BuiltIn().get_variable_value("${opco}")

        headers = {
                    'Authorization': 'Bearer ' + auth_token,
                    'Content-Type': 'application/json',
                    'Origin': BuiltIn().get_variable_value("${env_base_url}")
                }

        print (headers.values())
        resp =  requests.post(url, data= json.dumps(body),headers=headers, verify=False)
        print(resp.status_code, resp.text)
        return (resp)

    '''
    This api function will give list of generated alerts.
    /api/Alert/GetGeneratedAlertList (swagger URL)
    Author: Thouhid Shariff
    '''
    @keyword("Execute GetGeneratedAlertList")
    def execute_getGeneratedAlertList(self, auth_token , userId):
        base_url = BuiltIn().get_variable_value("${env_centralus_base_url}")
        get_url = BuiltIn().get_variable_value("${get_generated_alert_list}")
        url = base_url + get_url
        print(url)


        body = BuiltIn().get_variable_value("${execute_getGeneratedAlertList_body}")
        body.userId = userId

        headers = {
            'Authorization': 'Bearer ' + auth_token,
            'Content-Type': 'application/json',
            'Origin': BuiltIn().get_variable_value("${env_base_url}")
        }

        print(headers.values())
        resp = requests.post(url, data=json.dumps(body), headers=headers, verify=False)
        print(resp.status_code, resp.text)
        return (resp)

    '''
    This API function will Save / Update notification preferences.
    Author: Thouhid Shariff
    '''
    @keyword("Save Notification Preferences")
    def save_notification_preferences(self, auth_token, userId, status_code=200, status_message=None):
        base_url = BuiltIn().get_variable_value("${env_centralus_base_url}")
        get_url = BuiltIn().get_variable_value("${Save_user-preference}")
        url = base_url + get_url
        print(url)

        body = BuiltIn().get_variable_value("${save_notification_preference_body}")
        body.userId = userId


        headers = {
            'Authorization': 'Bearer ' + auth_token,
            'Content-Type': 'application/json',
            'Origin': BuiltIn().get_variable_value("${env_centralus_base_url}")
        }

        print(body.values())
        response = requests.put(url, data=json.dumps(body), headers=headers, verify=False)
        print(response.status_code, response.text)
        # return (resp)
        self.print_restapi_request('PUT', url, headers, response)
        status, failure_message = self.validate_response_code_message(response, status_code, status_message)
        return {'response': response, 'status': status, 'failure_message': failure_message}

    '''
    This API function will Get notification preferences by userId and opco
    Author: Thouhid Shariff
    '''
    @keyword
    def get_notification_preferences(self, auth_token, userId, opco, status_code=200, status_message=None):
        base_url = BuiltIn().get_variable_value("${env_centralus_base_url}")
        get_url = BuiltIn().get_variable_value("${Get_user-preference}")
        url = base_url + get_url + userId + '/' + opco
        print(url)

        headers = {
            'Authorization': 'Bearer ' + auth_token,
            'accept': 'application/json'
        }

        response = requests.get(url, headers=headers, verify=False)
        print(response.status_code, response.text)
        # return (resp)
        self.print_restapi_request('GET', url, headers, response)
        status, failure_message = self.validate_response_code_message(response, status_code, status_message)
        return {'response': response, 'status': status, 'failure_message': failure_message}