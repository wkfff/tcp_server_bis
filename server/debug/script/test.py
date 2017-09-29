# -*- coding: UTF-8 -*-
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET
import time
import datetime
import configparser 
import os

print(12 // 7)
def get_age_by_birthday(birthday):
    def set_return_value(retuen_value, Age, Type):
        retuen_value['Age'] = Age
        retuen_value['Type'] = Type
        
    birthday = birthday.split('-')
    birthday = datetime.date(int(birthday[0]), int(birthday[1]), int(birthday[2]))
    Today = datetime.date.today()
    return_value = {'Age':0,'Type':5}
    if (Today.year == birthday.year):
        if (Today.month == birthday.month):
            if (Today.day == birthday.day):
                set_return_value(return_value, 1, 4)
            else:
                if (Today.day - birthday.day > 7):
                    set_return_value(return_value, (Today.day - birthday.day) // 7, 3)
                else:
                    set_return_value(return_value, Today.day - birthday.day, 4)
        else:
            set_return_value(return_value, Today.month - birthday.month, 2)
    else:
        set_return_value(return_value, Today.year - birthday.year, 1)
    return return_value
print(str(2))

# format_input = '''
#     <msg>
#         <body>
#             <row>
#                 <ELECTR_REQUISITION_NO></ELECTR_REQUISITION_NO>
#                 <SYS_FLAG></SYS_FLAG>
#                 <FEE_INFO></FEE_INFO>
#             </row>
#         </body>
#     </msg>
#     '''
# record_str = '''
#     <RECORD>
#         <PAT_INDEX_NO>5807465</PAT_INDEX_NO>
#         <INHOSP_NO>2016-0357931-0</INHOSP_NO>
#         <ORDER_NO>4263541</ORDER_NO>
#         <CHARGE_ITEM_CODE>12040016</CHARGE_ITEM_CODE>
#         <CHARGE_DATE>20161224105155</CHARGE_DATE>
#         <AMOUNT>1</AMOUNT>
#         <CHARGE_STAFF_CODE>00</CHARGE_STAFF_CODE>
#         <DEPT_CODE>00</DEPT_CODE>
#         <EXECUT_DEPT_CODE>120026</EXECUT_DEPT_CODE>
#         <EXECUT_DEPT_NAME>血库</EXECUT_DEPT_NAME>
#         <EXECUT_DR_CODE>7164</EXECUT_DR_CODE>
#         <EXECUT_HS_CODE>120026</EXECUT_HS_CODE>
#     </RECORD>
# '''

# format_xml = ET.fromstring(format_input)
# fee_info = format_xml.find('body').find('row').find('FEE_INFO')
# for I in [1,2,3,4,5,6]:
#     record_xml = ET.fromstring(record_str)
#     fee_info.append(record_xml)
# print(ET.dump(format_xml))
# def format_datetime(str_date):
#     return time.strftime('%Y%m%d%H%M%S', time.strptime(str_date, '%Y-%m-%d %H:%M:%S'))
# print(format_datetime('2016-01-05 12:55:00'))

# log_file_path = 'log\\' + time.strftime("%Y-%m-%d")
# print(log_file_path)