# -*- coding: UTF-8 -*-
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET
import time
import configparser 
import os

def param_of_method(str_xml):
    cf = configparser.ConfigParser()
    # cf.read(os.path.dirname(os.getcwd()) + '\TCPServer.ini')
    cf.read(os.getcwd() + '\TCPServer.ini')

    user_name = cf.get('ESBEntry', 'UserName')
    pass_word = cf.get('ESBEntry', 'PassWord')
    source_code = cf.get('ESBEntry', 'SourceSysCode')
    target_code = cf.get('ESBEntry', 'TargetSysCode')

    root = ET.fromstring(str_xml)
    

    format_input = '''
    <msg>
        <body>
            <row>
                <ELECTR_REQUISITION_NO></ELECTR_REQUISITION_NO>
                <PAT_INDEX_NO></PAT_INDEX_NO>
                <INHOSP_NO></INHOSP_NO>
                <SYS_FLAG></SYS_FLAG>
                <REQUISITION_TYPE>1</REQUISITION_TYPE>
                <APPLY_CONTENT></APPLY_CONTENT>
                <ORDER_EXECUT_STATUS>0</ORDER_EXECUT_STATUS>
                <MODIFY_DATE></MODIFY_DATE>
                <MODIFY_STAFF_CODE></MODIFY_STAFF_CODE>
                <MODIFY_DEPT_CODE></MODIFY_DEPT_CODE>
                <CREATE_DATE></CREATE_DATE>
                <CREATE_STAFF_CODE></CREATE_STAFF_CODE>
                <ORDER_NO></ORDER_NO>
                <NOTE></NOTE>
            </row>
        </body>
    </msg>
    '''

    format_xml = ET.fromstring(format_input)

    APPLY_CONTENT = ''

    for child_of_child in root:
        requisition_id = child_of_child.find('RequisitionID').text   
        patient_id = child_of_child.find('PatientId').text 
        patient_number = child_of_child.find('PatientNumber').text 
        inpatient_id = child_of_child.find('InPatientId').text
        patient_type = child_of_child.find('PatientType').text
        CreateUser = child_of_child.find('CreateUser').text
        DeptCode = child_of_child.find('DeptCode').text
        if APPLY_CONTENT == '':
            if child_of_child.find('OrderType').text == '1':
                APPLY_CONTENT = child_of_child.find('ItemName').text + child_of_child.find('ItemCount').text + child_of_child.find('ItemUnit').text
            else:
                APPLY_CONTENT = child_of_child.find('ItemName').text
        else:
            if child_of_child.find('OrderType').text == '1':
                APPLY_CONTENT = APPLY_CONTENT + ';' + child_of_child.find('ItemName').text + child_of_child.find('ItemCount').text + child_of_child.find('ItemUnit').text
            else:
                APPLY_CONTENT = APPLY_CONTENT + ' + ' + child_of_child.find('ItemName').text

    temp_xml = format_xml.find('body').find('row')    
    temp_xml.find('ELECTR_REQUISITION_NO').text = requisition_id
    temp_xml.find('PAT_INDEX_NO').text = patient_id
    temp_xml.find('INHOSP_NO').text = inpatient_id
    temp_xml.find('SYS_FLAG').text = patient_type
    temp_xml.find('APPLY_CONTENT').text = APPLY_CONTENT
    temp_xml.find('CREATE_DATE').text = time.strftime("%Y-%m-%d %H:%M:%S")
    temp_xml.find('CREATE_STAFF_CODE').text = CreateUser
    temp_xml.find('MODIFY_DATE').text = time.strftime("%Y-%m-%d %H:%M:%S")
    temp_xml.find('MODIFY_STAFF_CODE').text = CreateUser
    temp_xml.find('MODIFY_DEPT_CODE').text = DeptCode

    Value = '<ESBEntry>'+'<AccessControl>'+'<UserName>'+ user_name +'</UserName>'+'<Password>'+ pass_word +'</Password>'+'<Fid>BS35006</Fid>'+'</AccessControl>'+'<MessageHeader>'+'<Fid>BS35006</Fid>'+'<SourceSysCode>'+ source_code +'</SourceSysCode>'+'<TargetSysCode>'+ target_code +'</TargetSysCode>'+'<MsgDate>'+ time.strftime("%Y-%m-%d %H:%M:%S") +'</MsgDate>'+'</MessageHeader>'+'<RequestOption>'+'<onceFlag/>'+'<startNum/>'+'<endNum/>'+'</RequestOption>'+'<MsgInfo><Msg><![CDATA[' + ET.tostring(format_xml, encoding='utf-8').decode('utf-8') + ']]></Msg></MsgInfo></ESBEntry>'
    return Value

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
#        <root>
#     <Requisition>
#         <OrderID>1</OrderID>
#         <RequisitionID>RequisitionID</RequisitionID>
#         <RequisitionDoctor></RequisitionDoctor>
#         <RequisitionTime></RequisitionTime>
#         <PatientId>PatientId</PatientId>
#         <PatientNumber>PatientNumber</PatientNumber>
#         <InPatientId>InPatientId</InPatientId>
#         <PatientType>2</PatientType>
#         <DeptCode>DeptCode</DeptCode>
#         <WardCode></WardCode>
#         <ExecUnit>ExecUnit</ExecUnit>
#         <OrderType>1</OrderType>
#         <ItemCode></ItemCode>
#         <ItemName>ItemName</ItemName>
#         <HisItemCode></HisItemCode>
#         <HisItemName></HisItemName>
#         <ItemCount>ItemCount</ItemCount>
#         <ItemUnit>ItemUnit</ItemUnit>
#         <ItemPrice></ItemPrice>
#         <Costs></Costs>
#         <OrderStatus></OrderStatus>
#         <OrderNo></OrderNo>
#         <OrderTime></OrderTime>
#         <CreateUser>CreateUser</CreateUser>
#         <CreateTime>CreateTime</CreateTime>
#         <Remark></Remark>
#     </Requisition>
#     <Requisition>
#         <OrderID>1</OrderID>
#         <RequisitionID>RequisitionID</RequisitionID>
#         <RequisitionDoctor></RequisitionDoctor>
#         <RequisitionTime></RequisitionTime>
#         <PatientId>PatientId</PatientId>
#         <PatientNumber>PatientNumber</PatientNumber>
#         <InPatientId>InPatientId</InPatientId>
#         <PatientType>2</PatientType>
#         <DeptCode>DeptCode</DeptCode>
#         <WardCode></WardCode>
#         <ExecUnit>ExecUnit</ExecUnit>
#         <OrderType>2</OrderType>
#         <ItemCode></ItemCode>
#         <ItemName>ItemName</ItemName>
#         <HisItemCode></HisItemCode>
#         <HisItemName></HisItemName>
#         <ItemCount>ItemCount</ItemCount>
#         <ItemUnit>ItemUnit</ItemUnit>
#         <ItemPrice></ItemPrice>
#         <Costs></Costs>
#         <OrderStatus></OrderStatus>
#         <OrderNo></OrderNo>
#         <OrderTime></OrderTime>
#         <CreateUser>CreateUser</CreateUser>
#         <CreateTime>CreateTime</CreateTime>
#         <Remark></Remark>
#     </Requisition>
# </root>
#     '''
#     print(param_of_method(str_xml))
