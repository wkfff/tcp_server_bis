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

    interfaceparms = root.find('interfaceparms')
    patient_id = interfaceparms.find('patientid').text
    patient_number = interfaceparms.find('patientnumber').text
    inpatient_id = interfaceparms.find('inpatientid').text
    test_item_code = interfaceparms.find('testitemid').text 

    Value = '<ESBEntry>'+'<AccessControl>'+'<UserName>'+ user_name +'</UserName>'+'<Password>'+ pass_word +'</Password>'+'<Fid>BS20011</Fid>'+'</AccessControl>'+'<MessageHeader>'+'<Fid>BS20011</Fid>'+'<SourceSysCode>'+ source_code +'</SourceSysCode>'+'<TargetSysCode>'+ target_code +'</TargetSysCode>'+'<MsgDate>'+ time.strftime("%Y-%m-%d%H:%M:%S") +'</MsgDate>'+'</MessageHeader>'+'<RequestOption>'+'<onceFlag/>'+'<startNum/>'+'<endNum/>'+'</RequestOption>'+'<MsgInfo><Msg><![CDATA[<msg><body><row>'

    if not patient_number is None:
        Value = Value + '<INHOSP_INDEX_NO>'+ patient_number +'</INHOSP_INDEX_NO>'
    if not inpatient_id is None:
        Value = Value + '<INHOSP_NO>'+ inpatient_id +'</INHOSP_NO>'
    Value = Value + '</row></body></msg>]]></Msg></MsgInfo></ESBEntry>'
    return Value

def result_of_method(str_xml):
    return_root = ET.Element('root')

    from_root = ET.fromstring(str_xml)
    first_docment = from_root.find('MsgInfo')
    for child_docment in first_docment:
        child_root = ET.fromstring(child_docment.text)
        body = child_root.find('body').find('row')
        data_element = ET.SubElement(return_root, 'record')
        key_element = ET.SubElement(data_element, 'GetID')
        key_element.set('key', 'true')
        key_element.text = body.find('REPORT_NO').text + '-' + body.find('TEST_ITEM_CODE').text
        ET.SubElement(data_element, 'PatientId').text = body.find('PAT_INDEX_NO').text
        ET.SubElement(data_element, 'PatientNumber').text = body.find('INHOSP_INDEX_NO').text
        ET.SubElement(data_element, 'InPatientId').text = body.find('INHOSP_NO').text
        ET.SubElement(data_element, 'Barcode').text = body.find('BAR_CODE_NO').text
        ET.SubElement(data_element, 'TestPurposeCH').text = body.find('TEST_AIM').text
        ET.SubElement(data_element, 'TestDate').text = body.find('RECEIVE_DATE').text.replace('T', ' ')
        ET.SubElement(data_element, 'ReportTime').text = body.find('REPORT_DATE').text.replace('T', ' ')
        ET.SubElement(data_element, 'TestItemId').text = body.find('TEST_SIMPLE_NAME').text
        ET.SubElement(data_element, 'TestItemCN').text = body.find('TEST_ITEM_NAME').text
        ET.SubElement(data_element, 'TestIResult1').text = body.find('TEST_RESULT_VALUE').text
        ET.SubElement(data_element, 'Rev1').text = body.find('REFERENCE_VALUE').text
        ET.SubElement(data_element, 'Rev2').text = body.find('TEST_RESULT_VALUE_UNIT').text
        ET.SubElement(data_element, 'TestItemEN').text = body.find('TEST_SIMPLE_NAME').text

    return_xml = ET.tostring(return_root, encoding='utf-8')
    return return_xml.decode('utf-8')

# if __name__ == '__main__':
#     str_xml = '''
#         <ESBEntry>
# 	<MessageHeader>
# 		<Fid>BS20011</Fid>
# 		<SourceSysCode>S03</SourceSysCode>
# 		<TargetSysCode>S11</TargetSysCode>
# 		<MsgDate>2017-12-04 10:48:28</MsgDate>
# 	</MessageHeader>
# 	<RequestOption>
# 		<onceFlag>0</onceFlag>
# 		<startNum/>
# 		<endNum/>
# 	</RequestOption>
# 	<MsgCount>6</MsgCount>
# 	<MsgInfo>
# 		<Msg>
# 			<![CDATA[<msg><body><row action="select"><INHOSP_INDEX_NO>1000321901</INHOSP_INDEX_NO><INHOSP_NO>2017-1150319-0</INHOSP_NO><VISIT_CARD_NO></VISIT_CARD_NO><LOWER_LIMIT></LOWER_LIMIT><UPPER_LIMIT></UPPER_LIMIT><NORMAL_FLAG></NORMAL_FLAG><TEST_SIMPLE_NAME>ALT</TEST_SIMPLE_NAME><BAR_CODE_NO>6711202131</BAR_CODE_NO><RECEIVE_DATE>2017-11-21 09:09:00</RECEIVE_DATE><TEST_ITEM_NAME>*谷丙转氨酶</TEST_ITEM_NAME><TEST_ITEM_CODE>100080</TEST_ITEM_CODE><TEST_AIM>辅助临床</TEST_AIM><TEST_CATEG_CODE></TEST_CATEG_CODE><TEST_RESULT_VALUE_UNIT>U/L</TEST_RESULT_VALUE_UNIT><TEST_RESULT_VALUE>12</TEST_RESULT_VALUE><PAT_INDEX_NO>2844676</PAT_INDEX_NO><REFERENCE_VALUE>5-64</REFERENCE_VALUE><REPORT_DATE>2017-11-21 12:11:00</REPORT_DATE><REPORT_NO>0249</REPORT_NO></row></body></msg>]]>
# 		</Msg>
# 		<Msg>
# 			<![CDATA[<msg><body><row action="select"><INHOSP_INDEX_NO>1000321901</INHOSP_INDEX_NO><INHOSP_NO>2017-1150319-0</INHOSP_NO><VISIT_CARD_NO></VISIT_CARD_NO><LOWER_LIMIT></LOWER_LIMIT><UPPER_LIMIT></UPPER_LIMIT><NORMAL_FLAG></NORMAL_FLAG><TEST_SIMPLE_NAME>APTT</TEST_SIMPLE_NAME><BAR_CODE_NO>6711202135</BAR_CODE_NO><RECEIVE_DATE>2017-11-21 09:02:00</RECEIVE_DATE><TEST_ITEM_NAME>部分凝血活酶时间</TEST_ITEM_NAME><TEST_ITEM_CODE>600050</TEST_ITEM_CODE><TEST_AIM>辅助临床</TEST_AIM><TEST_CATEG_CODE></TEST_CATEG_CODE><TEST_RESULT_VALUE_UNIT>S</TEST_RESULT_VALUE_UNIT><TEST_RESULT_VALUE>43</TEST_RESULT_VALUE><PAT_INDEX_NO>2844676</PAT_INDEX_NO><REFERENCE_VALUE>22.7-45</REFERENCE_VALUE><REPORT_DATE>2017-11-21 10:54:00</REPORT_DATE><REPORT_NO>214</REPORT_NO></row></body></msg>]]>
# 		</Msg>
# 		<Msg>
# 			<![CDATA[<msg><body><row action="select"><INHOSP_INDEX_NO>1000321901</INHOSP_INDEX_NO><INHOSP_NO>2017-1150319-0</INHOSP_NO><VISIT_CARD_NO></VISIT_CARD_NO><LOWER_LIMIT></LOWER_LIMIT><UPPER_LIMIT></UPPER_LIMIT><NORMAL_FLAG></NORMAL_FLAG><TEST_SIMPLE_NAME>FIB</TEST_SIMPLE_NAME><BAR_CODE_NO>6711202135</BAR_CODE_NO><RECEIVE_DATE>2017-11-21 09:02:00</RECEIVE_DATE><TEST_ITEM_NAME>纤维蛋白原(Fib)</TEST_ITEM_NAME><TEST_ITEM_CODE>600070</TEST_ITEM_CODE><TEST_AIM>辅助临床</TEST_AIM><TEST_CATEG_CODE></TEST_CATEG_CODE><TEST_RESULT_VALUE_UNIT>g/L</TEST_RESULT_VALUE_UNIT><TEST_RESULT_VALUE>4.66</TEST_RESULT_VALUE><PAT_INDEX_NO>2844676</PAT_INDEX_NO><REFERENCE_VALUE>1.8-4</REFERENCE_VALUE><REPORT_DATE>2017-11-21 10:54:00</REPORT_DATE><REPORT_NO>214</REPORT_NO></row></body></msg>]]>
# 		</Msg>
# 		<Msg>
# 			<![CDATA[<msg><body><row action="select"><INHOSP_INDEX_NO>1000321901</INHOSP_INDEX_NO><INHOSP_NO>2017-1150319-0</INHOSP_NO><VISIT_CARD_NO></VISIT_CARD_NO><LOWER_LIMIT></LOWER_LIMIT><UPPER_LIMIT></UPPER_LIMIT><NORMAL_FLAG></NORMAL_FLAG><TEST_SIMPLE_NAME>HGB</TEST_SIMPLE_NAME><BAR_CODE_NO>6711202136</BAR_CODE_NO><RECEIVE_DATE>2017-11-21 09:12:00</RECEIVE_DATE><TEST_ITEM_NAME>*血红蛋白</TEST_ITEM_NAME><TEST_ITEM_CODE>200030</TEST_ITEM_CODE><TEST_AIM>辅助临床</TEST_AIM><TEST_CATEG_CODE></TEST_CATEG_CODE><TEST_RESULT_VALUE_UNIT>g/L</TEST_RESULT_VALUE_UNIT><TEST_RESULT_VALUE>131</TEST_RESULT_VALUE><PAT_INDEX_NO>2844676</PAT_INDEX_NO><REFERENCE_VALUE>110-160</REFERENCE_VALUE><REPORT_DATE>2017-11-21 10:42:00</REPORT_DATE><REPORT_NO>152</REPORT_NO></row></body></msg>]]>
# 		</Msg>
# 		<Msg>
# 			<![CDATA[<msg><body><row action="select"><INHOSP_INDEX_NO>1000321901</INHOSP_INDEX_NO><INHOSP_NO>2017-1150319-0</INHOSP_NO><VISIT_CARD_NO></VISIT_CARD_NO><LOWER_LIMIT></LOWER_LIMIT><UPPER_LIMIT></UPPER_LIMIT><NORMAL_FLAG></NORMAL_FLAG><TEST_SIMPLE_NAME>PLT</TEST_SIMPLE_NAME><BAR_CODE_NO>6711202136</BAR_CODE_NO><RECEIVE_DATE>2017-11-21 09:12:00</RECEIVE_DATE><TEST_ITEM_NAME>*血小板计数</TEST_ITEM_NAME><TEST_ITEM_CODE>200050</TEST_ITEM_CODE><TEST_AIM>辅助临床</TEST_AIM><TEST_CATEG_CODE></TEST_CATEG_CODE><TEST_RESULT_VALUE_UNIT>*10^9/L</TEST_RESULT_VALUE_UNIT><TEST_RESULT_VALUE>235</TEST_RESULT_VALUE><PAT_INDEX_NO>2844676</PAT_INDEX_NO><REFERENCE_VALUE>100-300</REFERENCE_VALUE><REPORT_DATE>2017-11-21 10:42:00</REPORT_DATE><REPORT_NO>152</REPORT_NO></row></body></msg>]]>
# 		</Msg>
# 		<Msg>
# 			<![CDATA[<msg><body><row action="select"><INHOSP_INDEX_NO>1000321901</INHOSP_INDEX_NO><INHOSP_NO>2017-1150319-0</INHOSP_NO><VISIT_CARD_NO></VISIT_CARD_NO><LOWER_LIMIT></LOWER_LIMIT><UPPER_LIMIT></UPPER_LIMIT><NORMAL_FLAG></NORMAL_FLAG><TEST_SIMPLE_NAME>PT</TEST_SIMPLE_NAME><BAR_CODE_NO>6711202135</BAR_CODE_NO><RECEIVE_DATE>2017-11-21 09:02:00</RECEIVE_DATE><TEST_ITEM_NAME>凝血酶原时间(PT)</TEST_ITEM_NAME><TEST_ITEM_CODE>600010</TEST_ITEM_CODE><TEST_AIM>辅助临床</TEST_AIM><TEST_CATEG_CODE></TEST_CATEG_CODE><TEST_RESULT_VALUE_UNIT>S</TEST_RESULT_VALUE_UNIT><TEST_RESULT_VALUE>13.3</TEST_RESULT_VALUE><PAT_INDEX_NO>2844676</PAT_INDEX_NO><REFERENCE_VALUE>10-15</REFERENCE_VALUE><REPORT_DATE>2017-11-21 10:54:00</REPORT_DATE><REPORT_NO>214</REPORT_NO></row></body></msg>]]>
# 		</Msg>
# 	</MsgInfo>
# 	<RetInfo>
# 		<RetCode>1</RetCode>
# 		<RetCon>查询成功</RetCon>
# 	</RetInfo>
# </ESBEntry>
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
#                 <testitemid>HCT,PLT</testitemid>
#             </interfaceparms>
#         </interfacemessage>
#     '''
#     print(param_of_method(str_xml))
