# -*- coding: UTF-8 -*-
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET

def param_of_method(str_xml):
    return 'select * from ythis.department_all'
    
def result_of_method(str_xml):
    return_root = ET.Element('root')
    from_root = ET.fromstring(str_xml)

    for child_element in from_root:
        data_element = ET.SubElement(return_root, 'record')
        key_element = ET.SubElement(data_element, 'DeptCode') 
        key_element.text = child_element.find('DEPTCODE').text
        key_element.set('key', 'true')
        ET.SubElement(data_element, 'DeptName').text = child_element.find('DEPTNAME').text
        ET.SubElement(data_element, 'SpellCode').text = child_element.find('SPELLCODE').text
        ET.SubElement(data_element, 'Remark').text = child_element.find('REMARK').text
        ET.SubElement(data_element, 'telephonenumber').text = child_element.find('TELEPHONENUMBER').text
        ET.SubElement(data_element, 'Registered').text = '0'

    return_xml = ET.tostring(return_root, encoding='utf-8')
    return return_xml.decode('utf-8')

# if __name__ == '__main__':
#    str_xml = '''
#        <root>
#             <record>
#                 <DEPTCODE>0135</DEPTCODE>
#                 <DEPTNAME>导管室</DEPTNAME>
#                 <SPELLCODE>DGS</SPELLCODE>
#                 <TELEPHONENUMBER></TELEPHONENUMBER>
#                 <REMARK></REMARK>
#             </record>
#             <record>
#                 <DEPTCODE>01351</DEPTCODE>
#                 <DEPTNAME>导管室1</DEPTNAME>
#                 <SPELLCODE>DGS1</SPELLCODE>
#                 <TELEPHONENUMBER></TELEPHONENUMBER>
#                 <REMARK></REMARK>
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
