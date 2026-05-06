# custom_action_keywords.py
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.keys import Keys
from selenium import webdriver
from robot.api.deco import keyword, library

@library(scope='GLOBAL')
class ChainedActions:
    @keyword('Create Action Chain Object')
    def create_action_chain_object(self, driver):
        self.driver = driver
        self.actions = ActionChains(driver)

    @keyword('HOLD CTRL AND CLICK')
    def hold_ctrl_and_click(self, elements):
        # Simulate holding down the CTRL key and clicking multiple elements
        self.actions.key_down(Keys.CONTROL)  # Hold down CTRL
        for element in elements:
            self.actions.click(element)  # Click each element
        self.actions.key_up(Keys.CONTROL)  # Release CTRL
        self.actions.perform()  # Execute all actions
