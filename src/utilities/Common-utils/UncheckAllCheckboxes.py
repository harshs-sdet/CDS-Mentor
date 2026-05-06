from robot.api.deco import keyword
from selenium import webdriver

# create webdriver object
from selenium.webdriver.common.by import By

driver = webdriver.Chrome()


@keyword('Uncheck')
def Uncheck():
    checkboxes = driver.find_element(By.XPATH,"//li/input[@type='checkbox']")
    for checkbox in checkboxes:
        if checkbox.isSelected():
            checkbox.click()