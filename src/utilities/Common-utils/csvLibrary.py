import csv
from robot.api.deco import keyword, library
from collections import Counter
import pandas as pd
import string
import re
import math
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.keys import Keys
from selenium import webdriver

@library(scope='GLOBAL')
class csvLibrary:
    """This Library is Used for Redaing data content from CSV file

    Author: Thouhid shariff
    Version: 0.1
    """

    # @keyword('Get User Credentials')
    # def get_user_credentials(self, filename):
    #     '''This creates a keyword named "Read CSV File"
    #
    #     This keyword takes one argument, which is a path to a .csv file. It
    #     returns a list of rows, with each row being a list of the data in
    #     each column.
    #     '''
    #     print(filename)
    #     data = []
    #     with open(filename, 'r') as csvfile:
    #         csv_reader = csv.DictReader(csvfile, delimiter=';')
    #         line_count = 0
    #         for row in csv_reader:
    #             username = row['username']
    #             password = row['password']
    #             print(username)
    #             print(password)
    #         return username,password

    @keyword('Read Excel Data')

    def read_excel_data(self, filename):
        """Specify the path or URL of the Excel file in the first argument.
        If there are multiple sheets, only the first sheet is used by pandas.
        It reads as DataFrame.

            Author: Thouhid shariff
            Version: 0.1
            """

        userInfo = pd.read_excel(filename, sheet_name='Sheet1', usecols=['TD_UserName', 'TD_Password'], engine='openpyxl')
        print(userInfo)
        #return userInfo
        ProductInfo = pd.read_excel(filename, sheet_name='Sheet1', usecols=['Products'], engine='openpyxl')
        print(ProductInfo)
        return userInfo,ProductInfo

    @keyword('Xlsx to Csv Converter')
    def xlsx_to_csv_converter(self, filename):
        cvsDataframe = pd.read_csv(filename)

        # creating an output excel file
        resultExcelFile = pd.ExcelWriter(filename)

        # converting the csv file to an excel file
        cvsDataframe.to_excel(resultExcelFile, index=False)

        # saving the excel file
        resultExcelFile.save()
    @keyword('Get Company Name')
    def get_company_name(self, input_str):
        return  str(input_str).split('\n')[0]


    @keyword('Get List Price')
    def get_listPrice(self, extented_price, qty):
        res = extented_price.replace('$ ', '')
        if not str(qty).isdigit():
            qty = 1
            print(qty)
        qty = float(qty)
        res = float(res)
        res*=qty
        return  '$ ' + str("{:,.2f}".format(res))

    @keyword('Get Actual Price')
    def get_actual_price(self, extented_price):
        return  '$ ' + str("{:,.2f}".format(float(extented_price)))

    @keyword('Tuple to List Convertion')
    def tuple_to_list_convertion(self,tup):

        # tuple to list
        aList = list(tup)

        # print list
        print(type(aList))
        print(aList)
        return aList



    @keyword("Read Csv TestID")
    def read_csv_TestID(self, filename, index_col="TestID",delimiter="\t"):
        df = pd.read_csv(filename)
        df.set_index(index_col, inplace=True)
        return df

    @keyword("Read Csv ID")
    def read_csv_ID(self, filename, index_col="td_ID",error_bad_lines=False,delimiter="\t"):
        df = pd.read_csv(filename)
        df.set_index(index_col, inplace=True)
        return df

    @keyword("Read Csv ScenarioName")
    def read_csv_ScenarioName(self, filename, index_col="ScenarioName", delimiter="\t"):
        df = pd.read_csv(filename)
        df.set_index(index_col, inplace=True)
        return df


    @keyword("Check if TestcaseId is Unique")
    def check_if_testcaseid_is_Unique(self, val):
        for key in val:  # loop through all the keys
            value = val[key]  # get value for the key
            if len(value) > 1:
                return True
            else:
                return False


    #@keyword("
    # 0GetTDVar")
    #def getTDVar(self, df, row_name, col_name):
    #    return df.loc[row_name, col_name]

    @keyword("GetTDVarRow")
    def getTDVarRow(self, df, row_name):
        return df.loc[row_name]

    @keyword("GetTDVarRowAsDict")
    def getTDVarRowAsDict(self, df, row_name):
        return df.loc[row_name].to_dict(orient="index")

    @keyword("GetTDVarRowDict")
    def getTDVarRowDict(self, df, row_name):
        return df.loc[row_name].to_dict()

    @keyword("getTDVarRowColDict")
    def getTDVarRowColDict(self, df, rows, columns):
        ret_df = df.loc[rows, columns]
        return ret_df.to_dict()

    @keyword("Verify Runtime Var")
    def verify_runtime_var(self,val):
        if not (pd.isna(val)):
            varFirst = val[:2]
            varLast = val[-2:]
            if varFirst=="<<" and varLast==">>":
                return (val[2:-2])
            else:
                return "False"
        else:
            return "False"

    @keyword("Read Csv File")
    def read_csv_file(self, filename):
        data = []
        with open(filename, 'r') as csvfile:
            reader = csv.reader(csvfile)
            for row in reader:
                data.append(row)
        return data

    @keyword("Csv Length")
    def csv_length(self, filename):
        length = 0
        with open(filename, 'r') as csvfile:
            reader = csv.reader(csvfile)
            for row in reader:
                length += 1
        return length
    
    @keyword("Get CSV Headers")
    def get_csv_headers(self, filename):
        headers = []
        with open(filename, mode='r', newline='', encoding='utf-8') as csvfile:
            reader = csv.reader(csvfile)
            try:
                headers = next(reader) 
            except StopIteration:
                print(f"Warning: File '{filename}' is empty.")
        return headers

