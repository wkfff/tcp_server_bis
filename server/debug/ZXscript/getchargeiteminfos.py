# -*- coding: UTF-8 -*-
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET
from Txlogger import logger

def param_of_method(str_xml):
    return 'select * from ythis.chargeitem'

def result_of_method(str_xml):
    return_root = ET.Element('root')
    from_root = ET.fromstring(str_xml)

    for child_element in from_root:
        data_element = ET.SubElement(return_root, 'record')
        key_element = ET.SubElement(data_element, 'ChargeItemId') 
        key_element.text = child_element.find('CHARGEITEMID').text
        key_element.set('key', 'true')
        ET.SubElement(data_element, 'ChargeItemName').text = child_element.find('CHARGEITEMNAME').text
        ET.SubElement(data_element, 'SpellCode').text = child_element.find('SPELLCODE').text
        ET.SubElement(data_element, 'ChargePrice').text = child_element.find('CHARGEPRICE').text
        ET.SubElement(data_element, 'ChargeAmount').text = child_element.find('CHARGEAMOUNT').text
        ET.SubElement(data_element, 'IncomeCode').text = child_element.find('INCOMECODE').text
        ET.SubElement(data_element, 'OrganizationCode').text = child_element.find('ORGANIZATIONCODE').text
        ET.SubElement(data_element, 'ExecpriceCode').text = child_element.find('EXECPRICECODE').text
        ET.SubElement(data_element, 'Remark').text = child_element.find('REMARK').text
        
    return_xml = ET.tostring(return_root, encoding='utf-8')
    return return_xml.decode('utf-8')

if __name__ == '__main__':
    str_xml = '''
        <root>
            <record>
                <CHARGEITEMID>I00000004637</CHARGEITEMID>
                <CHARGEITEMNAME>人工关节（双极头）</CHARGEITEMNAME>
                <SPELLCODE>RGGJSJT</SPELLCODE>
                <CHARGEPRICE>1522.5</CHARGEPRICE>
                <CHARGEAMOUNT>1</CHARGEAMOUNT>
                <INCOMECODE>031</INCOMECODE>
                <ORGANIZATIONCODE></ORGANIZATIONCODE>
                <EXECPRICECODE></EXECPRICECODE>
                <REMARK></REMARK>
            </record>
            <record>
                <CHARGEITEMID>I00000004638</CHARGEITEMID>
                <CHARGEITEMNAME>人工关节（股骨柄）</CHARGEITEMNAME>
                <SPELLCODE>RGGJGGB</SPELLCODE>
                <CHARGEPRICE>2100</CHARGEPRICE>
                <CHARGEAMOUNT>1</CHARGEAMOUNT>
                <INCOMECODE>031</INCOMECODE>
                <ORGANIZATIONCODE></ORGANIZATIONCODE>
                <EXECPRICECODE></EXECPRICECODE>
                <REMARK></REMARK>
            </record>
        </root>
   '''
    print(result_of_method(str_xml))

    str_xml = '''
       <interfacemessage>
           <hospitalcode>hospitalcode</hospitalcode>
           <interfacename>getchargeiteminfos</interfacename>
           <interfaceparms>none</interfaceparms>
       </interfacemessage>
    '''
    print(param_of_method(str_xml))
