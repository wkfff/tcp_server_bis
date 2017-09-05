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
    cf.read(os.getcwd() + '\DIOCPTcpServer.ini')

    user_name = cf.get('ESBEntry', 'UserName')
    pass_word = cf.get('ESBEntry', 'PassWord')
    source_code = cf.get('ESBEntry', 'SourceSysCode')
    target_code = cf.get('ESBEntry', 'TargetSysCode')

    # str_xml = bis_var.Value

    root = ET.fromstring(str_xml)

    interfaceparms = root.find('interfaceparms')
    patient_id = interfaceparms.find('patientid').text
    patient_number = interfaceparms.find('patientnumber').text
    inpatient_id = interfaceparms.find('inpatientid').text

    # <query item="MR_NO" compy="=" cover="patientid" splice="and" />
    # <query item="INHOSP_INDEX_NO" compy="=" cover="inpatientid" splice="and" />
    # <query item="VISIT_CARD_NO" compy="=" cover="patientnumber" splice="and" />

    Value = '<ESBEntry>'+'<AccessControl>'+'<UserName>'+ user_name +'</UserName>'+'<Password>'+ pass_word +'</Password>'+'<Fid>BS10001</Fid>'+'</AccessControl>'+'<MessageHeader>'+'<Fid>BS10001</Fid>'+'<SourceSysCode>'+ source_code +'</SourceSysCode>'+'<TargetSysCode>'+ target_code +'</TargetSysCode>'+'<MsgDate>'+ time.strftime("%Y-%m-%d%H:%M:%S") +'</MsgDate>'+'</MessageHeader>'+'<RequestOption>'+'<onceFlag/>'+'<startNum/>'+'<endNum/>'+'</RequestOption>'+'<MsgInfo>'
    if not patient_id is None:
        Value = Value + '<query item="MR_NO" compy="=" value="\''+ patient_id +'\'" splice="and"/>'
    if not patient_number is None:
        Value = Value + '<query item="INHOSP_INDEX_NO" compy="=" value="\''+ patient_number +'\'" splice="and"/>'
    if not inpatient_id is None:
        Value = Value + '<query item="VISIT_CARD_NO" compy="=" value="\''+ inpatient_id +'\'" splice="and"/>'
    Value = Value + '<order item="" sort=""/>'+'</MsgInfo>'+'</ESBEntry>'
    return Value

def result_of_method(str_xml):
    return_xml = '''
    <root>
        <GetId key="true"></GetId>
        <PatientId></PatientId>
        <PatientNumber></PatientNumber>
        <InPatientId></InPatientId>
        <InHospitalTime></InHospitalTime>
        <PatientType></PatientType>
        <PatientName></PatientName>
        <PatientSex></PatientSex>
        <PatientAge></PatientAge>
        <AgeUnit></AgeUnit>
        <WardCode></WardCode>
        <WardName></WardName>
        <DeptName></DeptName>
        <DeptCode></DeptCode>
        <BedNo></BedNo>
        <DigCode></DigCode>
        <DiagnosesID></DiagnosesID>
        <Diagnoses></Diagnoses>
        <Address></Address>
        <CompanyName></CompanyName>
        <TelePhoneNo></TelePhoneNo>
        <MobilePhoneNo></MobilePhoneNo>
        <IdCardNo></IdCardNo>
        <MCardNo></MCardNo>
        <FCardNo></FCardNo>
        <HCardNo></HCardNo>
        <GetTime></GetTime>
        <GetProName></GetProName>
        <Rev_1></Rev_1>
        <Rev_2></Rev_2>
        <Rev_3></Rev_3>
    </root>
'''
    return_root = ET.fromstring(return_xml)
    
    from_root = ET.fromstring(str_xml)
    from_root = ET.fromstring(from_root.find('MsgInfo').find('Msg').text)
    body = from_root.find('body').find('row')
    return_root.find('GetId').text = body.find('INHOSP_NO').text
    return_root.find('PatientId').text = body.find('MR_NO').text
    return_root.find('PatientNumber').text = body.find('PAT_INDEX_NO').text
    return_root.find('PatientName').text = body.find('PAT_NAME').text
    return_root.find('PatientSex').text = body.find('PHYSI_SEX_CODE').text
    return_root.find('PatientAge').text = body.find('AGE').text
    return_root.find('IdCardNo').text = body.find('ID_NUMBER').text
    return_root.find('Address').text = body.find('CONTACT_ADDR').text
    return_root.find('MobilePhoneNo').text = body.find('PHONE_NO').text
    return_root.find('TelePhoneNo').text = body.find('PHONE_NO_HOME').text
    return_root.find('CompanyName').text = body.find('COMPANY').text
    return_root.find('DiagnosesID').text = body.find('ADMIT_DIAG_CODE').text
    return_root.find('Diagnoses').text = body.find('ADMIT_DIAG_NAME').text
    return_root.find('InHospitalTime').text = body.find('ADMIT_DATE').text
    return_root.find('DeptCode').text = body.find('CURR_DEPT_CODE').text
    return_root.find('DeptName').text = body.find('CURR_DEPT_NAME').text
    return_root.find('WardCode').text = body.find('CURR_WARD_CODE').text
    return_root.find('WardName').text = body.find('CURR_WARD_NAME').text
    return_root.find('BedNo').text = body.find('CURR_BED_INDEX_NO').text
    return_root.find('InPatientId').text = body.find('INHOSP_INDEX_NO').text
    return_xml = ET.tostring(return_root, encoding='utf-8')
    return return_xml.decode('utf-8')

# if __name__ == '__main__':
#     str_xml = '''
#         <ESBEntry>
#         <MessageHeader>
#             <Fid>BS10001</Fid>
#             <SourceSysCode>S03</SourceSysCode>
#             <TargetSysCode>S11</TargetSysCode>
#             <MsgDate>2015-12-1014:45:36</MsgDate>
#         </MessageHeader>
#         <RequestOption>
#             <onceFlag/>
#             <startNum/>
#             <endNum/>
#         </RequestOption>
#         <MsgCount>1</MsgCount>
#         <MsgInfo>
#             <Msg>
#             <![CDATA[<msg><body><row action="select"><INHOSP_INDEX_NO>10003044</INHOSP_INDEX_NO><CURR_BED_INDEX_NO>加16床</CURR_BED_INDEX_NO><CURR_WARD_NAME>普通外科病区</CURR_WARD_NAME><CURR_WARD_CODE>400202</CURR_WARD_CODE><CURR_DEPT_NAME>普通外科病区</CURR_DEPT_NAME><CURR_DEPT_CODE>400202</CURR_DEPT_CODE><ADMIT_DATE>20170829142100</ADMIT_DATE><ADMIT_DIAG_NAME>死亡</ADMIT_DIAG_NAME><ADMIT_DIAG_CODE>R99.x01</ADMIT_DIAG_CODE><COMPANY>水电费|水电费</COMPANY><PHONE_NO_HOME>1234565432345</PHONE_NO_HOME><PHONE_NO/><CONTACT_ADDR>黑龙江省佳木斯市抚远县海青乡@的撒</CONTACT_ADDR><ID_NUMBER>234567890234567890</ID_NUMBER><DATE_BIRTH>19921213000000</DATE_BIRTH><AGE>24</AGE><PHYSI_SEX_CODE>1</PHYSI_SEX_CODE><PAT_NAME>刘赛还</PAT_NAME><PAT_INDEX_NO>7093244</PAT_INDEX_NO><INHOSP_NO>2017-0847278-0</INHOSP_NO><MR_NO>10003044</MR_NO></row></body></msg>]]>
#             </Msg>
#         </MsgInfo>
#         <RetInfo>
#             <RetCode>1</RetCode>
#             <RetCon>查询成功</RetCon>
#         </RetInfo>
#         </ESBEntry>
#     '''
#     print(generate_patient_result(str_xml))

#     str_xml = '''
#         <interfacemessage>
#             <hospitalcode>hospitalcode</hospitalcode>
#             <interfacename>getpateintinfos</interfacename>
#             <interfaceparms>
#                 <patienttype>patienttype</patienttype>
#                 <patientid></patientid>
#                 <patientnumber></patientnumber>
#                 <inpatientid>inpatientid</inpatientid>
#             </interfaceparms>
#         </interfacemessage>
#     '''
#     print(generate_patient_query(str_xml))