# -*- coding: UTF-8 -*-
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET

def param_of_method(str_xml):
    return_root = ET.Element('root')
    data_xml = ET.fromstring(str_xml)
    doctor_advice = ''
    data_element = ET.SubElement(return_root, 'param')
    for child_of_child in data_xml:
        ET.SubElement(data_element, 'InPatientId').text = child_of_child.find('InPatientId').text
        ET.SubElement(data_element, 'vdoct_code').text = child_of_child.find('RequisitionDoctor').text
        ET.SubElement(data_element, 'vdept_code').text = child_of_child.find('DeptCode').text
        ET.SubElement(data_element, 'vitem_code').text = child_of_child.find('ItemCode').text
        if doctor_advice == '':
            doctor_advice = child_of_child.find('ItemName').text
        else:
            doctor_advice = doctor_advice + ',' + child_of_child.find('ItemName').text
        ET.SubElement(data_element, 'apply_num').text = child_of_child.find('RequisitionID').text
    ET.SubElement(data_element, 'doctor_advice').text = doctor_advice
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

# if __name__ == '__main__':
#     str_xml = '12312;213123;123'
#     print(result_of_method(str_xml))

#     str_xml = '''
#         <root>
#             <Requisition>
#                 <OrderID>1</OrderID>
#                 <RequisitionID>RequisitionID</RequisitionID>
#                 <RequisitionDoctor></RequisitionDoctor>
#                 <RequisitionTime></RequisitionTime>
#                 <PatientId>PatientId</PatientId>
#                 <PatientNumber>PatientNumber</PatientNumber>
#                 <InPatientId>InPatientId</InPatientId>
#                 <PatientType>2</PatientType>
#                 <DeptCode>DeptCode</DeptCode>
#                 <WardCode></WardCode>
#                 <ExecUnit>ExecUnit</ExecUnit>
#                 <OrderType>1</OrderType>
#                 <ItemCode></ItemCode>
#                 <ItemName>ItemName</ItemName>
#                 <HisItemCode></HisItemCode>
#                 <HisItemName></HisItemName>
#                 <ItemCount>ItemCount</ItemCount>
#                 <ItemUnit>ItemUnit</ItemUnit>
#                 <ItemPrice></ItemPrice>
#                 <Costs></Costs>
#                 <OrderStatus></OrderStatus>
#                 <OrderNo></OrderNo>
#                 <OrderTime></OrderTime>
#                 <CreateUser>CreateUser</CreateUser>
#                 <CreateTime>CreateTime</CreateTime>
#                 <Remark></Remark>
#             </Requisition>
#             <Requisition>
#                 <OrderID>1</OrderID>
#                 <RequisitionID>RequisitionID</RequisitionID>
#                 <RequisitionDoctor></RequisitionDoctor>
#                 <RequisitionTime></RequisitionTime>
#                 <PatientId>PatientId</PatientId>
#                 <PatientNumber>PatientNumber</PatientNumber>
#                 <InPatientId>InPatientId</InPatientId>
#                 <PatientType>2</PatientType>
#                 <DeptCode>DeptCode</DeptCode>
#                 <WardCode></WardCode>
#                 <ExecUnit>ExecUnit</ExecUnit>
#                 <OrderType>2</OrderType>
#                 <ItemCode></ItemCode>
#                 <ItemName>ItemName</ItemName>
#                 <HisItemCode></HisItemCode>
#                 <HisItemName></HisItemName>
#                 <ItemCount>ItemCount</ItemCount>
#                 <ItemUnit>ItemUnit</ItemUnit>
#                 <ItemPrice></ItemPrice>
#                 <Costs></Costs>
#                 <OrderStatus></OrderStatus>
#                 <OrderNo></OrderNo>
#                 <OrderTime></OrderTime>
#                 <CreateUser>CreateUser</CreateUser>
#                 <CreateTime>CreateTime</CreateTime>
#                 <Remark></Remark>
#             </Requisition>
#         </root>
#     '''
#     print(param_of_method(str_xml))
