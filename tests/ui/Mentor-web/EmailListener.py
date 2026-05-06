import json
import smtplib
import re
import sys
from email.message import EmailMessage
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from pathlib import Path
import os
from email import encoders
import xml.etree.ElementTree as ET
from os.path import dirname as up
import os
import subprocess
import os.path
import time
from lxml import etree


class EmailListener:
    ROBOT_LISTENER_API_VERSION = 3

    def __init__(self):
        # print(moduleName)
        # self.moduleName=moduleName
        print('send email utility')

    def send_email_outlook_with_attachment(self, subject, send_from, send_to, message):
        msg = EmailMessage()
        msg['Subject'] = subject
        msg['From'] = send_from
        msg['To'] = send_to

        # def fetch_suite_name(testcase_filename):
        #     tree = ET.parse(testcase_filename)
        #     root = tree.getroot()
        #     # Suite element is usually the first child
        #     suite = root.find('suite')
        #     print(suite.get('name'))
        #     return suite.get('name') if suite is not None else None
        #
        def go_up(path, levels):
            for _ in range(levels):
                path = os.path.dirname(path)
            return path

        file = "reports/output.xml"
        dirname = go_up(os.path.abspath(__file__), 1)
        testcase_filename = os.path.join(dirname, file)
        #
        # print(testcase_filename)
        # self.suitename= fetch_suite_name(testcase_filename)






        execution_result = self.update_value(testcase_filename)
        print(execution_result)
        total_testcases = self.calculate_total_testcases(execution_result)
        Test_Report = "Test Execution Results are : Total Testcases {} = {}".format(total_testcases, execution_result)
        html = f"""Dear All,
        <br/><br/> Please find test case results of CDS Mentor on QA environment.<br/><br/>
        <b>Test Result Summary:</b><br/><br/> <br/>
        <table border="2" padding: 10px border: 1px solid black border-collapse: collapse cellpadding="2" cellspacing="0">
        <tr>
            <td style="text-align:center"><b>
            <a  "{Test_Report}"</a>
            "{Test_Report}"</b></td>
        </tr>
        </table><br/><br/>
        <b>This is an automated email, Please do not reply ...</b><br/><br/>
        <b>Thanks,</b><br/>
        <b>QA Team</b>"""
        html += '</body></html>'

        msg.set_content(html, 'html')

        directory = go_up(os.path.abspath(__file__), 1)
        log_file = "/reports/log.html"
        log_path = directory + log_file

        with open(log_path, 'rb') as f:
            file_data = f.read()
            log_file_name = "log.html"
        msg.add_attachment(file_data, maintype='application', subtype='octet-stream', filename=log_file_name)
        smtp = smtplib.SMTP('smtp.gmail.com', 587)
        smtp.starttls()  # for using port 587
        smtp.login("dovertestuser@gmail.com", "lakgtyzemtdibxup")
        smtp.send_message(msg)
        smtp.quit()

    def update_value(self, filename):
        Statistics = {}

        try:
            tree = ET.parse(filename)
            root = tree.getroot()

            for total_elem in root.iter('total'):
                for subelem in total_elem:
                    for key, value in subelem.attrib.items():
                        try:
                            Statistics[key] = Statistics.get(key, 0) + int(value)
                        except (ValueError, TypeError):
                            # Skip non-integer values
                            continue

        except ET.ParseError:
            print(f"Warning: Failed to parse XML file: {filename}")
        except FileNotFoundError:
            print(f"Warning: File not found: {filename}")
        except Exception as e:
            print(f"Unexpected error: {e}")

        print(Statistics)
        return Statistics

    def calculate_total_testcases(self, result):
        totat_testcase = 0
        for i in result.values():
            totat_testcase = totat_testcase + int(i)

        return totat_testcase

    def close(self):
        print("Execution finished. Triggering email...")
        try:
            def fetch_suite_name(testcase_filename):
                tree = ET.parse(testcase_filename)
                root = tree.getroot()
                # Suite element is usually the first child
                suite = root.find('suite')
                print(suite.get('name'))
                return suite.get('name') if suite is not None else None

            def go_up(path, levels):
                for _ in range(levels):
                    path = os.path.dirname(path)
                return path

            file = "reports/output.xml"
            dirname = go_up(os.path.abspath(__file__), 1)
            testcase_filename = os.path.join(dirname, file)
            suitename = fetch_suite_name(testcase_filename)
            self.send_email_outlook_with_attachment(
                subject=f"CDS Mentor Automation execution report - {suitename} module",
                send_from="dovertestuser@gmail.com",
                # send_to="skrishna@dovercorp.com, cgopinath@dovercorp.com, bmishra@dovercorp.com,c-pagrawal1@dovercorp.com, c-squreshi@dovercorp.com",
                send_to="c-pagrawal1@dovercorp.com, bmishra@dovercorp.com, skrishna@dovercorp.com",
                message="Test Summary",

            )
        except Exception as e:
            print(f"[ERROR] Failed to send email: {e}")