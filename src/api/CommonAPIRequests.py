import requests
import urllib3
import random
import string
import pprint
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn


@library(scope='GLOBAL')
class CommonAPIRequests:
    """This Library can be used to call common API methods and validate the response

    Author: Thouhid shariff
    Version: 0.1
    """

    headers = {}

    def __init__(self):
        # Added to disable the insecure warnings appearing on calling APIs
        urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

    '''
    Author: Thouhid Shariff
    '''
    @keyword('Search Given Entity With Filter API')
    def filter(self, auth_token, base_url, filter_url, search_text, return_entities=[]):
        """Call filter API and return the id of searched entity
        Parameters:
            auth_token (String): Authorization token
            base_url (String): Environment base URL
            filter_url (String): URL part for filter
            search_text (String): Entity text to search
            return_entities (String):
        Returns:
            entity_id (String): id of searched entity
        Author:
            Thouhid Shariff
        """

        filter_json = BuiltIn().get_variable_value("${filter_body}")
        print(filter_json)
        filter_json.opco = BuiltIn().get_variable_value("${opco}")


        headers = {
            'Authorization': 'Bearer ' + auth_token,
            'Origin': base_url,
            'Content-Type': 'application/json'
        }

        if base_url.endswith('/'):
            base_url = base_url[:-1]

        complete_url = base_url + filter_url
        response = requests.post(complete_url, headers=headers, json=filter_json, verify=False)

        self.print_restapi_request('POST', complete_url, headers, response, filter_json)

        status, failure_message = self.validate_response_code_message(response, 200, None)

        return_value = {'status': status, 'failure_message': failure_message}
        req_json = response.json()
        entity_id = ""
        return_dict = {}
        if 'data' in req_json:
            return_dict = {}
            return_value['response_data'] = req_json['data']
            for item in req_json['data']:
                entity_id = item['Id']
                for entity in return_entities:
                    if entity in item:
                        return_dict[entity] = item[entity]

        return_value['entity_id'] = entity_id
        return_value['return_entities'] = return_dict

        return return_value

    '''
    This Keyword is used to delete the record from database using UserId
    Author: Thouhid Shariff
    '''
    @keyword("Delete By Id")
    def delete_by_id(self, auth_token, base_url, delete_url, entity_id, status_code=200, status_message=None):
        """Call delete API and return status of API call
        Parameters:
            auth_token (String): Authorization token
            base_url (String): Environment base URL
            delete_url (String): URL part for delete
            entity_id (String): Entity id to be deleted
            status_code (Integer): Expected status code (Default set to 200)
            status_message (String): Expected message in response (Default set to None)
        Returns:
            status (Boolean): true if entity deletion is success false otherwise
            failure_message (String): Message
        Author:
            Thouhid Shariff
        """

        headers = {
            'Authorization': 'Bearer ' + auth_token,
            'Origin': base_url,
            'Content-Type': 'application/json'
        }

        if base_url.endswith('/'):
            base_url = base_url[:-1]

        if delete_url.endswith('/'):
            delete_url = delete_url[:-1]

        complete_url = base_url + delete_url + '/' + entity_id
        response = requests.delete(complete_url, headers=headers, verify=False)

        self.print_restapi_request('DELETE', complete_url, headers, response)

        status, failure_message = self.validate_response_code_message(response, status_code, status_message)

        return {'status': status, 'failure_message': failure_message}

    '''Author: Thouhid Shariff'''
    @keyword("Get By Id")
    def get_by_id(self, auth_token, base_url, get_by_id_url, entity_id, status_code=200, status_message=None):
        """Call delete API and return status of API call
        Parameters:
            auth_token (String): Authorization token
            base_url (String): Environment base URL
            get_by_id_url (String): URL part for get by id
            entity_id (String): Entity id to be deleted
            status_code (Integer): Expected status code (Default set to 200)
            status_message (String): Expected message in response (Default set to None)
        Returns:
            entity_id (String): id of searched entity
        Author:
            Thouhid Shariff
        """

        headers = {
            'Authorization': 'Bearer ' + auth_token,
            'Origin': base_url
        }

        if base_url.endswith('/'):
            base_url = base_url[:-1]

        if get_by_id_url.endswith('/'):
            get_by_id_url = get_by_id_url[:-1]

        complete_url = base_url + get_by_id_url + '/' + entity_id
        response = requests.get(complete_url, headers=headers, verify=False)

        self.print_restapi_request('GET', complete_url, headers, response)

        status, failure_message = self.validate_response_code_message(response, status_code, status_message)

        return {'response': response, 'status': status, 'failure_message': failure_message}

    '''Author: Thouhid Shariff'''
    @keyword("Get All")
    def get_all(self, auth_token, base_url, get_all_url, status_code=200, status_message=None):
        """Call delete API and return status of API call
        Parameters:
            auth_token (String): Authorization token
            base_url (String): Environment base URL
            get_all_url (String): URL part for get by id
            status_code (Integer): Expected status code (Default set to 200)
            status_message (String): Expected message in response (Default set to None)
        Returns:
            entity_id (String): id of searched entity
        Author:
            Thouhid Shariff
        """

        headers = {
            'Authorization': 'Bearer ' + auth_token,
            'Origin': base_url
        }

        if base_url.endswith('/'):
            base_url = base_url[:-1]

        complete_url = base_url + get_all_url
        response = requests.get(complete_url, headers=headers, verify=False)

        self.print_restapi_request('GET', complete_url, headers, response)

        status, failure_message = self.validate_response_code_message(response, status_code, status_message)

        return {'response': response, 'status': status, 'failure_message': failure_message}

    '''Author: Thouhid Shariff'''
    @keyword("Get Entity Details From Get All Response")
    def get_entity_details_from_get_all_response(self, entity_id, response):
        """Get the entity details matching given entity id from get all API response
        Parameters:
            entity_id (String): Id of entity to fetch details
            response (Object): Response object
        Returns:
            entity_details (Dict): Details of entity matching the entity id
        Author:
            Thouhid Shariff
        """

        response_json = response.json()

        response_data = response_json['data']
        entity_details = {}
        for item in response_data:
            if item['id'] == entity_id:
                entity_details = item
                break

        return entity_details

    '''Author: Thouhid Shariff'''
    @keyword('Validate API Response Code And Message')
    def validate_response_code_message(self, response_object, status_code=200, status_message=None):
        """Validate the response code and response message in API response
        Parameters:
            response_object (Response Obj): Response Object for API call
            status_code (Integer): Expected status code (Default set to 200)
            status_message (String): Expected message in response (Default set to None)
        Returns:
            status (Boolean): True is expected values match actual values
            failure_message (String): Error message
        Author:
            Thouhid Shariff
        """

        response_json = response_object.json()

        status = True
        failure_message = ""
        if status_message is not None:
            if "message" in response_json:
                if not response_json['message'].lower() == status_message.lower():
                    status = False
                    failure_message = "Expected message: '" + status_message + "' and Actual message: '" + response_json['message'] + "' are not equal"
                    print(failure_message)
            elif "usermessage" in response_json:
                if not response_json['usermessage'].lower() == status_message.lower():
                    status = False
                    failure_message = "Expected usermessage: '" + status_message + "' and Actual usermessage: '" + response_json['usermessage'] + "' are not equal"
                    print(failure_message)
        if 'statusCode' in response_json:
            if not response_json['statusCode'] == status_code:
                status = False
                failure_message = "Expected status code: '" + str(status_code) + "' and Actual status code: '" + str(response_json['statusCode']) + "' are not equal"
        else:
            failure_message = response_json
        print(failure_message)
        return status, failure_message

    '''Author: Thouhid Shariff'''
    def verify_entity_details_in_response(self, actual_details, expected_details):
        added, removed, modified, same = self.dict_compare(expected_details, actual_details)
        print("Expected details :: ")
        print(pprint.pformat(expected_details))
        print("Actual details :: ")
        print(pprint.pformat(actual_details))

        is_dict_same = True
        differences = []
        if added:
            is_dict_same = False
            differences.append("ADDED :: " + str(added))
        if removed:
            is_dict_same = False
            differences.append("REMOVED :: " + str(removed))
        if modified:
            is_dict_same = False
            differences.append("MODIFIED :: " + str(modified))

        return is_dict_same, differences

    @staticmethod
    def dict_compare(d1, d2):
        d1_keys = set(d1.keys())
        d2_keys = set(d2.keys())
        shared_keys = d1_keys.intersection(d2_keys)
        added = d1_keys - d2_keys
        removed = d2_keys - d1_keys
        modified = {o: (d1[o], d2[o]) for o in shared_keys if d1[o] != d2[o]}
        same = set(o for o in shared_keys if d1[o] == d2[o])

        return added, removed, modified, same

    '''Author: Thouhid Shariff'''
    @keyword("Get Random String")
    def get_random_string(self, char_limit):
        random_string = ''.join(random.choice(string.ascii_uppercase) for _ in range(int(char_limit)))
        return random_string

    '''Author: Thouhid Shariff'''
    @keyword("Print Restapi Request")
    def print_restapi_request(self, method, url, headers, response, payload=None):
        if payload:
            print('--------------------------- Method -----------------------------\n' +
                  method +
                  '\n------------------------- API_CALL -----------------------------\n' +
                  'API URL : %s ' % url +
                  '\n------------------------- Request Headers -------------------------\n' +
                  pprint.pformat(headers) +
                  '\n------------------------- Request Payload -------------------------\n' +
                  pprint.pformat(payload) +
                  '\n------------------------- Response -------------------------\n' +
                  pprint.pformat(response.text))
        else:
            print('--------------------------- Method -----------------------------\n' +
                  method +
                  '\n------------------------- API_CALL -----------------------------\n' +
                  'API URL : %s ' % url +
                  '\n------------------------- Request Headers -------------------------\n' +
                  pprint.pformat(headers) +
                  '\n------------------------- Response -------------------------\n' +
                  pprint.pformat(response.text))
