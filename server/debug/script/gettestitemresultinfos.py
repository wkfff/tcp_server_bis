# -*- coding: UTF-8 -*-
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET
import time
import configparser
import os

Txlogger.logger.name = 'gettestitemresultinfos'
def param_of_method(str_xml):
    cf = configparser.ConfigParser()
    # cf.read(os.path.dirname(os.getcwd()) + '\TCPServer.ini')
    cf.read(os.getcwd() + '\TCPServer.ini')

    user_name = cf.get('ESBEntry', 'UserName')
    pass_word = cf.get('ESBEntry', 'PassWord')
    source_code = cf.get('ESBEntry', 'SourceSysCode')
    target_code = cf.get('ESBEntry', 'TargetSysCode')

    root = ET.fromstring(str_xml)

    interfaceparms = root.find('interfaceparms')
    patient_id = interfaceparms.find('patientid').text
    patient_number = interfaceparms.find('patientnumber').text
    inpatient_id = interfaceparms.find('inpatientid').text
    test_item_code = interfaceparms.find('testitemid').text

    Value = '<ESBEntry>' + '<AccessControl>' + '<UserName>' + user_name + '</UserName>' + '<Password>' + pass_word + '</Password>' + '<Fid>BS20011</Fid>' + '</AccessControl>' + '<MessageHeader>' + '<Fid>BS20011</Fid>' + '<SourceSysCode>' + source_code + '</SourceSysCode>' + \
        '<TargetSysCode>' + target_code + '</TargetSysCode>' + '<MsgDate>' + \
            time.strftime("%Y-%m-%d %H:%M:%S") + '</MsgDate>' + '</MessageHeader>' + '<RequestOption>' + '<onceFlag/>' + \
        '<startNum/>' + '<endNum/>' + '</RequestOption>' + \
            '<MsgInfo><Msg><![CDATA[<msg><body><row>'

    if not patient_id is None:
        Value = Value + '<PAT_INDEX_NO>' + patient_id + '</PAT_INDEX_NO>'
    if not patient_number is None:
        Value = Value + '<INHOSP_INDEX_NO>' + patient_number + '</INHOSP_INDEX_NO>'
    if not inpatient_id is None:
        Value = Value + '<INHOSP_NO>' + inpatient_id + '</INHOSP_NO>'
    Value = Value + '<TEST_ITEM_CODE>' + test_item_code + '</TEST_ITEM_CODE>'
    Value = Value + '</row></body></msg>]]></Msg></MsgInfo></ESBEntry>'
    return Value


def result_of_method(str_xml):
    return_xml = '''
        <root>
            <GetID key="true"></GetID>
            <PatientId></PatientId>
            <PatientNumber></PatientNumber>
            <InPatientId></InPatientId>
            <Barcode></Barcode>
            <TestPurposeCH></TestPurposeCH>
            <TestDate></TestDate>
            <ReportTime></ReportTime>
            <TestItemId></TestItemId>
            <TestItemCN></TestItemCN>
            <TestItemEN></TestItemEN>
            <TestIResult1></TestIResult1>
            <TestIResult2></TestIResult2>
            <DataSource></DataSource>
            <InterfaceName></InterfaceName>
            <InputTime></InputTime>
            <Rev1></Rev1>
            <Rev2></Rev2>
            <Rev3></Rev3>
        </root>
    '''
    return_root = ET.fromstring(return_xml)

    from_root = ET.fromstring(str_xml)
    from_root = ET.fromstring(from_root.find('MsgInfo').find('Msg').text)
    body = from_root.find('body').find('row')

    return_root.find('GetID').text = body.find(
        'REPORT_NO').text + '-' + body.find('TEST_ITEM_CODE').text

    return_root.find('PatientId').text = body.find('PAT_INDEX_NO').text
    return_root.find('PatientNumber').text = body.find('INHOSP_INDEX_NO').text
    return_root.find('InPatientId').text = body.find('INHOSP_NO').text

    return_root.find('Barcode').text = body.find('BAR_CODE_NO').text
    return_root.find('TestPurposeCH').text = body.find('TEST_AIM').text
    return_root.find('TestDate').text = body.find(
        'RECEIVE_DATE').text.replace('T', ' ')
    return_root.find('ReportTime').text = body.find(
        'REPORT_DATE').text.replace('T', ' ')
    return_root.find('TestItemId').text = body.find('TEST_ITEM_CODE').text
    return_root.find('TestItemCN').text = body.find('TEST_ITEM_NAME').text
    return_root.find('TestIResult1').text = body.find('TEST_RESULT_VALUE').text
    return_root.find('Rev1').text = body.find('REFERENCE_VALUE').text
    return_root.find('Rev2').text = body.find('TEST_RESULT_VALUE_UNIT').text
    return_root.find('TestItemEN').text = body.find('TEST_SIMPLE_NAME').text
    return_xml = ET.tostring(return_root, encoding='utf-8')
    return return_xml.decode('utf-8')

# if __name__ == '__main__':
#     str_xml = '''
#         <ESBEntry>
#             <MessageHeader>
#                 <Fid>BS20011</Fid>
#                 <SourceSysCode>S11</SourceSysCode>
#                 <TargetSysCode>S11</TargetSysCode>
#                 <MsgDate>2017-09-05 10:37:10</MsgDate>
#             </MessageHeader>
#             <RequestOption>
#                 <onceFlag>0</onceFlag>
#             </RequestOption>
#             <MsgCount>1</MsgCount>
#             <MsgInfo>
#                 <Msg>
#                 <![CDATA[<msg><body><row action="select"><INHOSP_INDEX_NO>10003046</INHOSP_INDEX_NO><INHOSP_NO>2017-0847280-0</INHOSP_NO><LOWER_LIMIT></LOWER_LIMIT><UPPER_LIMIT></UPPER_LIMIT><NORMAL_FLAG></NORMAL_FLAG><TEST_SIMPLE_NAME>DBIL</TEST_SIMPLE_NAME><BAR_CODE_NO>6709020008</BAR_CODE_NO><RECEIVE_DATE>2017-09-02T12:00:22</RECEIVE_DATE><TEST_ITEM_NAME>*直接胆红素</TEST_ITEM_NAME><TEST_ITEM_CODE>100020</TEST_ITEM_CODE><TEST_AIM>辅助临床</TEST_AIM><TEST_CATEG_CODE></TEST_CATEG_CODE><TEST_RESULT_VALUE_UNIT>umol/L</TEST_RESULT_VALUE_UNIT><TEST_RESULT_VALUE>23</TEST_RESULT_VALUE><PAT_INDEX_NO>7094247</PAT_INDEX_NO><REFERENCE_VALUE>0-8</REFERENCE_VALUE><REPORT_DATE>2017-09-02T15:47:18</REPORT_DATE><REPORT_NO>6709020008</REPORT_NO></row></body></msg>]]>
#                 </Msg>
#             </MsgInfo>
#             <RetInfo>
#                 <RetCode>1</RetCode>
#                 <RetCon>查询成功</RetCon>
#             </RetInfo>
#             </ESBEntry>
#     '''
#     print(result_of_method(str_xml))

#     str_xml = '''
#        <interfacemessage>
#             <hospitalcode>00002</hospitalcode>
#             <interfacename>gettestitemresultinfos</interfacename>
#             <interfaceparms>
#                 <patienttype>patienttype</patienttype>
#                 <patientid>907321</patientid>
#                 <patientnumber>patientnumber</patientnumber>
#                 <inpatientid>inpatientid</inpatientid>
#                 <testitemid>HCT</testitemid>
#             </interfaceparms>
#         </interfacemessage>
#     '''
#     print(param_of_method(str_xml))
