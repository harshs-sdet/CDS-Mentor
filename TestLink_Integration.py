
# -*- coding:utf-8 -*-
# !/usr/bin/python
#   Author            :      Sajan Vyas

import sys
from datetime import datetime

import testlink
import argparse
from robot.api import ExecutionResult, ResultVisitor
from testlink import TestlinkAPIClient
from testlink.testlinkerrors import TLResponseError


class RobotI:
    def __init__(self, serverurl, devkey):
        self.testlinker = TestlinkAPIClient(serverurl, devkey)

    def getTestPlanPlatforms(self, testplan_id):
        return self.testlinker.getTestPlanPlatforms(testplan_id)

    def getTestPlanPlatformsIDByName(self, testplan_id, platform_name):
        try:
            PLlist = self.testlinker.getTestPlanPlatforms(testplan_id)
            PLid = ""
            for i in PLlist:
                if platform_name.lower() in i['name'].lower():
                    PLid = i['id']
                    break
            return PLid
        except IOError as e:
            errno, strerror = e.args
            print
            "getTestPlanPlatformsIDByName I/O error({0}): {1}".format(errno, strerror)
        except testlink.testlinkerrors.TLResponseError as e:
            print
            "TestLink error({0}): {1}".format(e.code, e.message)
            return False
        except testlink.testlinkerrors.TLConnectionError as e:
            print
            "TestLink error:({0})".format(e.message)
            return False
        except:
            print
            "Unexpected error:", sys.exc_info()[0]
            raise

    def getTestProjectIDByName(self, project_name):
        return self.testlinker.getTestProjectByName(project_name)['id']

    def getTestCaseIDByName(self, testcase_name, project_name):
        return self.testlinker.getTestCaseIDByName(testcase_name, testprojectname=project_name)[0]['id']

    def getTestProjectPrefixByName(self, project_name):
        return self.testlinker.getTestProjectByName(project_name)['prefix']

    def getTestCasesForTestPlan(self, testplain_id):
        return self.testlinker.getTestCasesForTestPlan(testplain_id)

    def getTestPlanIDByName(self, project_name, test_plan_name):
        try:
            tp = self.testlinker.getTestPlanByName(project_name, test_plan_name)
            return tp[0]['id']
        except IOError as e:
            errno, strerror = e.args
            print
            "getTestPlanIDByName I/O error({0}): {1}".format(errno, strerror)
        except testlink.testlinkerrors.TLResponseError as e:
            print
            "TestLink error({0}): {1}".format(e.code, e.message)
            return False
        except testlink.testlinkerrors.TLConnectionError as e:
            print
            "TestLink error:({0})".format(e.message)
            return False
        except:
            print
            "Unexpected error:", sys.exc_info()[0]
            raise

    def reportTCResult(self, testcase_id, testplan_id, build_id, result, notes, platform_id):
        self.testlinker.reportTCResult(testcase_id, testplan_id, build_id, result, notes, platformid=platform_id)

    def getProjectIDByName(self, project_name):
        self.testlinker.getProjectIDByName(project_name)

    def addTestCaseToTestPlan(self, testproject_id, testplan_id, testcaseexternalid, version, platformid):
        try:
            self.testlinker.addTestCaseToTestPlan(testproject_id, testplan_id, testcaseexternalid, version,
                                                  platformid=platformid)
        except testlink.testlinkerrors.TLResponseError as e:
            print
            "TestLink error({0}): {1}".format(e.code, e.message)

    def createTestSuite(self, testproject_id, testSuiteName, details):
        self.testlinker.createTestSuite(testproject_id, testSuiteName, details)

    def setTestCaseTestSuite(self, testcaseexternalid, testsuiteid):
        self.testlinker.setTestCaseTestSuite(testcaseexternalid, testsuiteid)

    def getTestCase(self, testcaseexternalid):
        self.testlinker.getTestCase(testcaseexternalid=testcaseexternalid)

    def createBuild(self, testplanid, build_name, buildnotes):
        try:
            newbuildID = self.testlinker.createBuild(testplanid, build_name, buildnotes)
            if 'exist' in newbuildID[0]['message']:
                return newbuildID[0]['message'].split(":")[1].replace(")", "")
            else:
                return self.existingBuild(testplanid)
        except IOError as e:
            errno, strerror = e.args
            print
            "createBuild I/O error({0}): {1}".format(errno, strerror)
        except testlink.testlinkerrors.TLResponseError as e:
            print
            "TestLink error({0}): {1}".format(e.code, e.message)
            return False
        except testlink.testlinkerrors.TLConnectionError as e:
            print
            "TestLink error:({0})".format(e.message)
            return False
        except:
            print
            "Unexpected error:", sys.exc_info()[0]
            raise

    def getInternalTestcaseID(self, externalTestCaseID):
        try:
            tc_info = self.testlinker.getTestCase(testcaseexternalid=externalTestCaseID)
            return tc_info[0]['testcase_id']
        except IOError as e:
            errno, strerror = e.args
            print
            "getInternalTestcaseID I/O error({0}): {1}".format(errno, strerror)
        except testlink.testlinkerrors.TLResponseError as e:
            print
            "TestLink error({0}): {1}".format(e.code, e.message)
            return False
        except testlink.testlinkerrors.TLConnectionError as e:
            print
            "TestLink error:({0})".format(e.message)
            return False
        except:
            print
            "Unexpected error:", sys.exc_info()[0]
            raise

    def existingBuild(self, testplanid):
        try:
            existingBuild = self.testlinker.getLatestBuildForTestPlan(testplanid)
            return existingBuild['id']
        except IOError as e:
            errno, strerror = e.args
            print
            "existingBuild I/O error({0}): {1}".format(errno, strerror)
        except testlink.testlinkerrors.TLResponseError as e:
            print
            "TestLink error({0}): {1}".format(e.code, e.message)
            return False
        except testlink.testlinkerrors.TLConnectionError as e:
            print
            "TestLink error:({0})".format(e.message)
            return False
        except:
            print
            "Unexpected error:", sys.exc_info()[0]
            raise

    def addPlatformToTestPlan(self, testplan_id, platformname):
        self.testlinker.addPlatformToTestPlan(testplan_id, platformname)

    def getProjectPlatforms(self, testproject_id):
        platform_info = self.testlinker.getProjectPlatforms(testproject_id)
        return platform_info

    def createTestPlan(self, testplanname, testprojectname):
        try:
            self.testlinker.createTestPlan(testplanname, testprojectname)
        except testlink.testlinkerrors.TLResponseError as e:
            print
            "TestLink error({0}): {1}".format(e.code, e.message)

    def createPlatform(self, projectname, platformname):
        try:
            self.testlinker.createPlatform(projectname, platformname, platformondesign=True, platformonexecution=True)
        except testlink.testlinkerrors.TLResponseError as e:
            print
            "TestLink error({0}): {1}".format(e.code, e.message)


class PrintTestInfo(ResultVisitor):

    def visit_test(self, test):
        if test.status == "PASS":
            testcase_id_result_dict['p'].append([test.name, test.status, test.tags])
        else:
            testcase_id_result_dict['f'].append([test.name, test.status, test.tags])


class TestlinkFeeder:
    def __init__(self, serverurl, devkey, project_name, testplan_name, platform_name, build_name):
        # testplan_names = str(testplan_name).split("/")
        self.robotI = RobotI(serverurl, devkey)
        self.project_name = project_name
        self.TProjectid = self.robotI.getTestProjectIDByName(project_name)
        self.platform_name = platform_name

        self.robotI.createTestPlan(testplan_name, self.project_name)
        self.robotI.createPlatform(self.project_name, self.platform_name)

        self.TPid = self.robotI.getTestPlanIDByName(project_name, testplan_name)
        for build in build_name:
            Bid = self.robotI.createBuild(self.TPid, build, '')
        platform_info = self.robotI.getProjectPlatforms(self.TProjectid)
        self.PLid = platform_info[self.platform_name]['id']
        self.build_name = build_name
        global testcase_id_result_dict
        global tcIds
        global Ids_dict_pass
        global Ids_dict_fail
        global Ids_notfound
        testcase_id_result_dict = {
            "f": [],
            "p": []
        }
        tcIds = []
        Ids_dict_pass = {}
        Ids_dict_fail = {}
        Ids_notfound = []

    def parseRFreport(self, RFreport):
        try:
            project_prefix_name = self.robotI.getTestProjectPrefixByName(self.project_name)

            tcIntID = ""
            result = ExecutionResult(RFreport)

            result.visit(PrintTestInfo())

            pass_index = 0
            fail_index = 0
            for name, result, tagList in testcase_id_result_dict['p']:
                for t in tagList:
                    if "CZ" in t:
                        tcIntID = self.robotI.getInternalTestcaseID(t)
                        Ids_dict_pass[t] =tcIntID
                        tcIds.append(t)
                pass_index += 1

            for name, result, tagList in testcase_id_result_dict['f']:
                for t in tagList:
                    if "CZ" in t:
                        tcIntID = self.robotI.getInternalTestcaseID(t)
                        Ids_dict_fail[t] = tcIntID
                        tcIds.append(t)
                fail_index += 1

        except IOError as e:
            errno, strerror = e.args
            print
            "parseRFreport I/O error({0}): {1}".format(errno, strerror)
        except testlink.testlinkerrors.TLResponseError as e:
            print
            "TestLink error({0}): {1}".format(e.code, e.message)
            return False
        except testlink.testlinkerrors.TLConnectionError as e:
            print
            "TestLink error:({0})".format(e.message)
            return False
        except:
            print
            "Unexpected error:", sys.exc_info()[0]
            raise

    def reportTCResult(self, build_names, project_name):
        for id in tcIds:
            build_name = []
            # All test case must contain atleast one keyword (Regression / Sanity / Smoke)
            try:
                test_case_keyword = self.robotI.testlinker.listKeywordsForTC(id)
                if "Regression" in test_case_keyword:
                    build_name.append(build_names[0])
                if "Sanity" in test_case_keyword:
                    build_name.append(build_names[1])
                if "Smoke" in test_case_keyword:
                    build_name.append(build_names[2])
                for name, pass_id, taglist in testcase_id_result_dict['p']:
                    if id in taglist:
                        for i in range(len(build_name)):
                            self.robotI.testlinker.reportTCResult(Ids_dict_pass[id], self.TPid, build_name[i], "p",
                                                                  "Executed through "
                                                                  "automation and Passed",
                                                                  platformid=self.PLid)
                print(testcase_id_result_dict['f'])
                for name, pass_id, taglist in testcase_id_result_dict['f']:
                    if id in taglist:
                        for i in range(len(build_name)):
                            self.robotI.testlinker.reportTCResult(Ids_dict_fail[id], self.TPid, build_name[i], "f",
                                                                  "Executed through "
                                                                  "automation and failed",
                                                                  platformid=self.PLid)
            except TLResponseError as e:
                Ids_notfound.append(id)

    def addTestCaseToTestPlan(self, project_name):

        for id in tcIds:
            # All test case must contain atleast one keyword (Regression / Sanity / Smoke)
            self.robotI.addTestCaseToTestPlan(self.TProjectid, self.TPid, id, 1, platformid=self.PLid)

    def createTestSuite(self, testSuiteName, details):
        self.robotI.testlinker.createTestSuite(self.TProjectid, testSuiteName, details)

    def addPlatformToTestPlan(self, project_name):
        for id in tcIds:
            # All test case must contain atleast one keyword (Regression / Sanity / Smoke)
            self.robotI.addPlatformToTestPlan(self.TPid, self.platform_name)

    def createTestPlan(self, testplanname, projectname):
        self.robotI.createTestPlan(testplanname, projectname)

    def createPlatform(self, projectname, platformname):
        self.robotI.createPlatform(projectname, platformname)


if __name__ == "__main__":

    parser = argparse.ArgumentParser(prog='testlinker.py', usage='%(prog)s',
                                     description='Auto update testlink test cases status from RF report')
    parser.add_argument('-u', '--serverurl', required=True,
                        help='API server url to connect to testlink. Example: '
                             '"http://testlink-server.centralus.cloudapp.azure.com/lib/api/xmlrpc/v1/xmlrpc.php"')
    parser.add_argument('-p', '--project', required=True, help='Project name from testlink. Example: "test 123"')
    parser.add_argument('-t', '--testplan', required=True, help='Test plan name from testlink. Example: "Automation"')
    parser.add_argument('-f', '--platform', required=True, help='Platform name from testlink. Example: "chrome"')
    parser.add_argument('--file', required=True,
                        help='Robotframework output_2.xml file for test case result. Example: "output_2.xml"')

    # Logic for parsing the values collected from Command line
    args = parser.parse_args()
    devkey = "7565a1638fddb5b8e8806cb63f0cc08f"   ##Harshit's API key

    # Logic for providing three different builds for execution as per three different Keywords
    version = int(datetime.now().strftime("%Y%m%d"))
    build_name = []
    regressionBuild = "Regression_" + str(version)
    sanityBuild = "Sanity_" + str(version)
    smokeBuild = "Smoke_" + str(version)
    build_name = [regressionBuild, sanityBuild, smokeBuild]

    # Logic for setting up values for further execution
    testlink_feeder = TestlinkFeeder(args.serverurl, devkey, args.project, args.testplan, args.platform,
                                     build_name)

    # This method will Read output.xml file, parse info and add it in dictionary with Pass / Fail bifurcation
    testlink_feeder.parseRFreport(args.file)

    # This method will add Platform to Test plan
    testlink_feeder.addPlatformToTestPlan(args.project)

    # This method will add test cases parsed from output.xml file to test plan
    testlink_feeder.addTestCaseToTestPlan(args.project)

    # This method will execute the test cases based on keyword and build
    testlink_feeder.reportTCResult(build_name, args.project)
    if len(Ids_notfound)>0:
        print(''.join(str(Ids_notfound))+ ' ids not found in testlink.')
    for name, result, tags in testcase_id_result_dict['p']:
        print(name)
        print("====PASS====")
    for name, result, tags in testcase_id_result_dict['f']:
        print(name)
        print("====FAIL====")
