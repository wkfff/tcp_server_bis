# -*- coding: UTF-8 -*-
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET


def param_of_method(str_xml):
    return 'select * from ythis.user_emp'

def result_of_method(str_xml):
    return_root = ET.Element('root')
    from_root = ET.fromstring(str_xml)

    for child_element in from_root:
        data_element = ET.SubElement(return_root, 'record')
        key_element = ET.SubElement(data_element, 'User_Id') 
        key_element.text = child_element.find('USER_ID').text
        key_element.set('key', 'true')
        ET.SubElement(data_element, 'User_Phone').text = child_element.find('USER_PHONE').text
        ET.SubElement(data_element, 'User_No').text = child_element.find('USER_ID').text
        ET.SubElement(data_element, 'User_Sex').text = child_element.find('USER_SEX').text
        ET.SubElement(data_element, 'SpellCode').text = child_element.find('SPELLCODE').text
        ET.SubElement(data_element, 'User_Name').text = child_element.find('USER_NAME').text
        ET.SubElement(data_element, 'User_Email').text = child_element.find('USER_EMAIL').text
        ET.SubElement(data_element, 'User_Dept').text = child_element.find('USER_DEPT').text
        ET.SubElement(data_element, 'User_Level').text = child_element.find('USER_LEVEL').text
        ET.SubElement(data_element, 'User_Remark').text = child_element.find('USER_REMARK').text

    return_xml = ET.tostring(return_root, encoding='utf-8')
    return return_xml.decode('utf-8')

# if __name__ == '__main__':
#    str_xml = '''
#        <root>
#             <record>
#                 <USER_ID>000838</USER_ID>
#                 <USER_NO>000838</USER_NO>
#                 <USER_TYPE>2</USER_TYPE>
#                 <USER_NAME>李璐</USER_NAME>
#                 <USER_SEX>1</USER_SEX>
#                 <SPELLCODE>LL</SPELLCODE>
#                 <USER_EMAIL></USER_EMAIL>
#                 <USER_PHONE></USER_PHONE>
#                 <USER_LEVEL>15</USER_LEVEL>
#                 <USER_DEPT>0035</USER_DEPT>
#                 <USER_WARD>0152</USER_WARD>
#                 <USER_PWD></USER_PWD>
#                 <USER_REMARK></USER_REMARK>
#             </record>
#             <record>
#                 <USER_ID>0008381</USER_ID>
#                 <USER_NO>0008381</USER_NO>
#                 <USER_TYPE>21</USER_TYPE>
#                 <USER_NAME>李璐1</USER_NAME>
#                 <USER_SEX>11</USER_SEX>
#                 <SPELLCODE>LL1</SPELLCODE>
#                 <USER_EMAIL></USER_EMAIL>
#                 <USER_PHONE></USER_PHONE>
#                 <USER_LEVEL>151</USER_LEVEL>
#                 <USER_DEPT>00351</USER_DEPT>
#                 <USER_WARD>01521</USER_WARD>
#                 <USER_PWD></USER_PWD>
#                 <USER_REMARK></USER_REMARK>
#             </record>
#         </root>
#    '''
#    print(result_of_method(str_xml))

#    str_xml = '''
#        <interfacemessage>
#             <hospitalcode>hospitalcode</hospitalcode>
#             <interfacename>getstaffinfos</interfacename>
#             <interfaceparms>none</interfaceparms>
#         </interfacemessage>
#    '''
#    print(param_of_method(str_xml))
