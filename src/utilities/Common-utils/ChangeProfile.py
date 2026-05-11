import shutil, os
import easygui
from robot.api.deco import keyword
import time



@keyword('Change Profile')
def ChangeProfile():
    currdir = os.getcwd()
    print(currdir)
    profile = easygui.enterbox('Enter the profile needed to execute the test cases: ')
    if profile=="":
        time.sleep(2)
    profileneeded_Config = "VHSS_Automation\Config\\" + profile.upper() + ".yaml"
    defaultprofile_Config = "VHSS_Automation\Config\Default.yaml"
    shutil.copyfile(profileneeded_Config, defaultprofile_Config)
    profileneeded_TestData = "VHSS_Automation\TestData\ui\web\\" + profile.upper() + ".yaml"
    defaultprofile_TestData = "VHSS_Automation\TestData\ui\web\Default.yaml"
    shutil.copyfile(profileneeded_TestData, defaultprofile_TestData)
    print('done')
