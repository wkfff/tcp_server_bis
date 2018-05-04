# -*- coding: UTF-8 -*-
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET

def param_of_method(str_xml):
    return 'select * from ythis.department_n'
    
def result_of_method(str_xml):
    return_root = ET.Element('root')
    from_root = ET.fromstring(str_xml)

    for child_element in from_root:
        data_element = ET.SubElement(return_root, 'record')
        key_element = ET.SubElement(data_element, 'WardCode') 
        key_element.text = child_element.find('WARDCODE').text
        key_element.set('key', 'true')
        ET.SubElement(data_element, 'WardName').text = child_element.find('WARDNAME').text
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
#                 <WARDCODE>0215</WARDCODE>
#                 <WARDNAME>门诊急诊护士站</WARDNAME>
#                 <SPELLCODE>MZJZHSZ</SPELLCODE>
#                 <TELEPHONENUMBER></TELEPHONENUMBER>
#                 <REMARK></REMARK>
#             </record>
#             <record>
#                 <WARDCODE>0105</WARDCODE>
#                 <WARDNAME>重症医学科病区</WARDNAME>
#                 <SPELLCODE>ZZYXKBQ</SPELLCODE>
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
