import requests
from robot.api.deco import keyword, library
from CommonAPIRequests import CommonAPIRequests
from robot.libraries.BuiltIn import BuiltIn


@library(scope='GLOBAL')
class UsersAPI(CommonAPIRequests):
    """This Library can be used to call API methods for Users and validate the response

    Author: Thouhid Shariff
    Version: 0.1
    """

    def __init__(self):
        CommonAPIRequests.__init__(self)

    '''
    This will create a new user and record in database 
    Author: Thouhid Shariff
    '''
    @keyword("Create User")
    def create_user(self, auth_token  , user_param={}, status_code=201, status_message=None):
        """Create Role with API based on parameters provided
        Parameters:
            auth_token (String): Authorization token
            user_param (Dict): Parameters required for entity creation
            status_code (Integer): Expected status code (Default set to 200)
            status_message (String): Expected message in response (Default set to None)
        Returns:
            Userid (String): id of searched entity
        Author:
            Thouhid shariff
        """

        base_url = BuiltIn().get_variable_value("${env_base_url}")
        create_url = BuiltIn().get_variable_value("${user_create}")

        """if BuiltIn().get_variable_value("${brand}") == "Metcal":
            organizationIds = BuiltIn().get_variable_value("${brand}")
            brand = "Metcal"
        else :
            organizationIds = "1d283bd25ead4d04a650f7e1fff46178"
            brand = "Techon"""""

        global email
        email = self.get_random_string(5) + "@gmail.com"

        f_name = "First" + self.get_random_string(5)
        l_name = "Last" + self.get_random_string(5)


        user = BuiltIn().get_variable_value("${Create_user_body}")
        user.opcoName = BuiltIn().get_variable_value("${opco}")
        user.companyName = BuiltIn().get_variable_value("${opco}")
        user.firstName = f_name
        user.lastName = l_name
        user.email = email
        user.brand = BuiltIn().get_variable_value("${brand}")
        user.userName = email
        user.organizationIds = BuiltIn().get_variable_value("${organizationIds}")
        print(user)

        for key in user_param.keys():
            user[key] = user_param[key]

        headers = {
            'Authorization': 'Bearer ' + auth_token,
            'Origin': base_url,
            'Content-Type': 'application/json'
        }

        if base_url.endswith('/'):
            base_url = base_url[:-1]

        complete_url = base_url + create_url
        response = requests.post(complete_url, headers=headers, json=user, verify=False)

        self.print_restapi_request('POST', complete_url, headers, response, user)

        return response

    '''
    This function fetches users of Partiular opco Based on Page Number / Page size or Text
    Author: Thouhid Shariff
    '''
    @keyword("Filter User")
    def filter_user(self, auth_token, user_name='f_name'):
        """Filter User based on username and return id and oid
        Parameters:
            auth_token (String): Authorization token
            user_name (String): Name of user
        Returns:
            entity_id (String): id of searched entity
        Author:
            Thouhid Shariff
        """

        base_url = BuiltIn().get_variable_value("${env_base_url}")
        filter_url = BuiltIn().get_variable_value("${user_filter}")
        response_dict = self.filter(auth_token, base_url, filter_url, user_name, return_entities=['oId'])
        user_id = ""
        user_oid = ""
        print(response_dict)
        if 'entity_id' in response_dict:
            user_id = response_dict['entity_id']
        if 'return_entities' in response_dict:
            user_oid = response_dict['return_entities']['oId']

        return user_id, user_oid

    '''
    Below function Deletes the user instance from the database for a given id
    Author: Thouhid Shariff
    '''
    @keyword("Delete User")
    def delete_user(self, auth_token, user_OID , status_code=200, status_message=None):
        base_url = BuiltIn().get_variable_value("${env_base_url}")
        delete_user_url = BuiltIn().get_variable_value("${Delete_user}")
        opco = BuiltIn().get_variable_value("${opco}")

        headers = {
            'Authorization': 'Bearer ' + auth_token,
            'Origin': base_url,
            'accept': 'application/json'
        }


        Unique_id = {

            "userOid": user_OID
        }

        if base_url.endswith('/'):
            base_url = base_url[:-1]

        complete_url = base_url + delete_user_url + user_OID + '/' + opco
        response = requests.delete(complete_url, headers=headers, json=Unique_id, verify=False)

        self.print_restapi_request('Delete', complete_url, headers, response, Unique_id)

        status, failure_message = self.validate_response_code_message(response, status_code, status_message)

        #return {'userid_data': Unique_id, 'status': status, 'failure_message': failure_message}
        return response

    '''
    Below Function will reset user password.
    Author: Thouhid Shariff
    '''
    @keyword("Reset Password")
    def reset_password(self, auth_token, user_OID, new_password, status_code=200, status_message=None):
        base_url = BuiltIn().get_variable_value("${env_url}")
        reset_password_url = BuiltIn().get_variable_value("${user_password_reset}")

        headers = {
            'Authorization': 'Bearer ' + auth_token,
            'Origin': base_url,
            'Content-Type': 'application/json'
        }

        reset_password = {
            "password": new_password,
            "userOid": user_OID
        }

        if base_url.endswith('/'):
            base_url = base_url[:-1]

        complete_url = base_url + reset_password_url
        response = requests.put(complete_url, headers=headers, json=reset_password, verify=False)

        self.print_restapi_request('PUT', complete_url, headers, response, reset_password)

        status, failure_message = self.validate_response_code_message(response, status_code, status_message)

        return {'password_data': reset_password, 'status': status, 'failure_message': failure_message}

    '''
    Get user details validates the content available in User created Email notification for Retails users registered in Customer Registration form 
    and Retail users imported via import user API.
    Author: Thouhid Shariff
    '''
    @keyword("Get User Details")
    def get_user_details(self, auth_token, user_name=None, password=None ,set_new_password=False):

       # if self.user_name != user_name:
       #     self.session = requests.Session()
        #    self.headers = AuthBearer.get_default_headers()
       #     self.data = AuthBearer.get_default_headers()

        headers = {
            'Authorization': 'Bearer ' + auth_token,
            'Origin': BuiltIn().get_variable_value("${env_base_url}"),
            'Content-Type': 'application/json'
        }

        data = self.call_get_User_ByEmailid_api( headers )

        return data

    '''
    Reads the users instance from the database for a given email
    Author: Thouhid Shariff
    '''
    @keyword("Call Get User ByEmailid Api")
    def call_get_User_ByEmailid_api(self, headers ):
        base_url = BuiltIn().get_variable_value("${env_base_url}")
        getUserByEmail_url = BuiltIn().get_variable_value("${get_user_byEmail}")

        url = base_url + getUserByEmail_url + email
        print(headers)

        response = requests.get( url, headers=headers, verify=False)
        self.print_restapi_request('GET', url, self.headers, response)
        return response