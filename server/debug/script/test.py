# -*- coding: UTF-8 -*-
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET
import time
import configparser 
import os

format_input = '''
    <msg>
        <body>
            <row>
                <ELECTR_REQUISITION_NO></ELECTR_REQUISITION_NO>
                <SYS_FLAG></SYS_FLAG>
                <FEE_INFO></FEE_INFO>
            </row>
        </body>
    </msg>
    '''
record_str = '''
    <RECORD>
        <PAT_INDEX_NO>5807465</PAT_INDEX_NO>
        <INHOSP_NO>2016-0357931-0</INHOSP_NO>
        <ORDER_NO>4263541</ORDER_NO>
        <CHARGE_ITEM_CODE>12040016</CHARGE_ITEM_CODE>
        <CHARGE_DATE>20161224105155</CHARGE_DATE>
        <AMOUNT>1</AMOUNT>
        <CHARGE_STAFF_CODE>00</CHARGE_STAFF_CODE>
        <DEPT_CODE>00</DEPT_CODE>
        <EXECUT_DEPT_CODE>120026</EXECUT_DEPT_CODE>
        <EXECUT_DEPT_NAME>血库</EXECUT_DEPT_NAME>
        <EXECUT_DR_CODE>7164</EXECUT_DR_CODE>
        <EXECUT_HS_CODE>120026</EXECUT_HS_CODE>
    </RECORD>
'''

format_xml = ET.fromstring(format_input)
fee_info = format_xml.find('body').find('row').find('FEE_INFO')
for I in [1,2,3,4,5,6]:
    record_xml = ET.fromstring(record_str)
    fee_info.append(record_xml)
print(ET.dump(format_xml))
def format_datetime(str_date):
    return time.strftime('%Y%m%d%H%M%S', time.strptime(str_date, '%Y-%m-%d %H:%M:%S'))
print(format_datetime('2016-01-05 12:55:00'))