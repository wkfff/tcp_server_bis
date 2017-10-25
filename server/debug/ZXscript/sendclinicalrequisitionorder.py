# -*- coding: UTF-8 -*-
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET

from Txlogger import logger

def param_of_method(str_xml):
    return_root = ET.Element('root')
    data_xml = ET.fromstring(str_xml)
    doctor_advice = ''
    data_element = ET.SubElement(return_root, 'param')
    for child_of_child in data_xml:
        ET.SubElement(data_element, 'InPatientId').text = child_of_child.find('InPatientId').text
        ET.SubElement(data_element, 'vdoct_code').text = child_of_child.find('RequisitionDoctor').text
        ET.SubElement(data_element, 'vdept_code').text = child_of_child.find('DeptCode').text
        ET.SubElement(data_element, 'vitem_code').text = child_of_child.find('HisItemCode').text
        
        doctor_advice = child_of_child.find('HisItemName').text
        if child_of_child.find('OrderType').text == '1':
            if  child_of_child.find('ItemCount').text is not None:
                doctor_advice = doctor_advice + child_of_child.find('ItemCount').text
            if  child_of_child.find('ItemUnit').text is not None:
                doctor_advice = doctor_advice + child_of_child.find('ItemUnit').text
        ET.SubElement(data_element, 'apply_num').text = child_of_child.find('RequisitionID').text
    ET.SubElement(data_element, 'doctor_advice').text = doctor_advice
    logger.debug(ET.tostring(return_root, encoding='utf-8').decode('utf-8'))
    return ET.tostring(return_root, encoding='utf-8').decode('utf-8')

def result_of_method(str_xml):
    root = ET.Element('root')
    for orderId in str_xml.split(';'):
        record = ET.SubElement(root, 'record')
        key_ele = ET.SubElement(record, 'OrderID')
        key_ele.text = orderId
        key_ele.set('key', 'true')
        ET.SubElement(record, 'OrderStatus').text = '2'
    result = ET.tostring(root, encoding='utf-8').decode('utf-8')
    return result

if __name__ == '__main__':
    str_xml = '12312;213123;123'
    print(result_of_method(str_xml))

    str_xml = '''
        <root>
    <record>
        <OrderID>17</OrderID>
        <RequisitionID>170000942</RequisitionID>
        <RequisitionDoctor>9999</RequisitionDoctor>
        <RequisitionTime>2017-10-24 22:02:56</RequisitionTime>
        <PatientId>0081041717</PatientId>
        <PatientNumber>0002009568</PatientNumber>
        <InPatientId>ZY010002009568</InPatientId>
        <PatientType>2</PatientType>
        <DeptCode>0046</DeptCode>
        <WardCode>0121</WardCode>
        <ExecUnit>2140100</ExecUnit>
        <OrderType>2</OrderType>
        <ItemCode>I00000017622</ItemCode>
        <ItemName>交叉配血</ItemName>
        <HisItemCode>I00000017622</HisItemCode>
        <HisItemName>交叉配血</HisItemName>
        <ItemCount>1</ItemCount>
        <ItemUnit></ItemUnit>
        <ItemPrice></ItemPrice>
        <Costs></Costs>
        <OrderStatus>2</OrderStatus>
        <OrderNo>26448821USER_SEX</OrderNo>
        <OrderTime>1899-12-30 00:00:00</OrderTime>
        <CreateUser>9999</CreateUser>
        <CreateTime>2017-10-24 22:03:25</CreateTime>
        <Remark></Remark>
    </record>
</root>
    '''
    print(param_of_method(str_xml))
