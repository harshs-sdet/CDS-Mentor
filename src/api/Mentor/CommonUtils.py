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


@keyword('Get Response Details')
def getResponseDetails(self, json, procedures):
    length= len(procedures)
    bool=False
    for i in range(length):
        ids = [json['data'][i]['procedureId']]
        if  ids in procedures:
            bool=True
        else:
            bool=False
    return True
@keyword('Find the Remaining Page Count')
def findTheRemainingPageCount(self, current, total):
    remaining=False;
    if (total - current )>0:
        remaining=True
    return remaining


