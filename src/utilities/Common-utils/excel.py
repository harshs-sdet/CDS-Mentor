from openpyxl import load_workbook



@library(scope='GLOBAL')
class ExcelUtility(object):
    """This Library can be used to call login APIs and get the Auth Token along with OrgId and PersonaId

    Author: Thouhid Shariff
    Version: 0.1
    """

    def __init__(self):
        print 'read cell valu in excel'


    @keyword("Read cell Value")
    def read_cell_value(self, excelfile, sheetname, columname, rownumber):
        wb = load_workbook(filename=excelfile, read_only=True)
        sheet_ranges = wb[sheetname]
        cellToRead = '' + columname + str(rownumber)
        cellValue = sheet_ranges[cellToRead].value
        print
        "cell value :", cellValue
        return cellValue


