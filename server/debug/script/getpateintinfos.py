# -*- coding: UTF-8 -*-
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET
import time
import configparser 
import os

def get_param_patient_inpatient(str_xml):
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

    Value = '<ESBEntry>'+'<AccessControl>'+'<UserName>'+ user_name +'</UserName>'+'<Password>'+ pass_word +'</Password>'+'<Fid>BS10001</Fid>'+'</AccessControl>'+'<MessageHeader>'+'<Fid>BS10001</Fid>'+'<SourceSysCode>'+ source_code +'</SourceSysCode>'+'<TargetSysCode>'+ target_code +'</TargetSysCode>'+'<MsgDate>'+ time.strftime("%Y-%m-%d %H:%M:%S") +'</MsgDate>'+'</MessageHeader>'+'<RequestOption>'+'<onceFlag/>'+'<startNum/>'+'<endNum/>'+'</RequestOption>'+'<MsgInfo>'
    if not patient_id is None:
        Value = Value + '<query item="PAT_INDEX_NO" compy="=" value="\''+ patient_id +'\'" splice="and"/>'
    if not patient_number is None:
        Value = Value + '<query item="INHOSP_INDEX_NO" compy="=" value="\''+ patient_number +'\'" splice="and"/>'
    if not inpatient_id is None:
        Value = Value + '<query item="INHOSP_NO" compy="=" value="\''+ inpatient_id +'\'" splice="and"/>'
    Value = Value + '<order item="" sort=""/>'+'</MsgInfo>'+'</ESBEntry>'
    return Value

def get_param_patient_outpatient(str_xml):
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

    Value = '<ESBEntry>'+'<AccessControl>'+'<UserName>'+ user_name +'</UserName>'+'<Password>'+ pass_word +'</Password>'+'<Fid>BS10005</Fid>'+'</AccessControl>'+'<MessageHeader>'+'<Fid>BS10005</Fid>'+'<SourceSysCode>'+ source_code +'</SourceSysCode>'+'<TargetSysCode>'+ target_code +'</TargetSysCode>'+'<MsgDate>'+ time.strftime("%Y-%m-%d%H:%M:%S") +'</MsgDate>'+'</MessageHeader>'+'<RequestOption>'+'<onceFlag/>'+'<startNum/>'+'<endNum/>'+'</RequestOption>'+'<MsgInfo>'
    if not patient_number is None:
        Value = Value + '<query item="VISIT_CARD_NO" compy="=" value="\''+ patient_number +'\'" splice="and"/>'
    if not inpatient_id is None:
        Value = Value + '<query item="OUTHOSP_NO" compy="=" value="\''+ inpatient_id +'\'" splice="and"/>'
    Value = Value + '<order item="" sort=""/>'+'</MsgInfo>'+'</ESBEntry>'
    return Value

def get_result_inpatient(str_xml):
    return_xml = '''
        <root>
            <record>
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
            </record>
        </root>
    '''
    root = ET.fromstring(return_xml)
    return_root = root.find('record')
    
    from_root = ET.fromstring(str_xml)
    FID = from_root.find('MessageHeader').find('Fid').text
    from_root = ET.fromstring(from_root.find('MsgInfo').find('Msg').text)
    body = from_root.find('body').find('row')
    if FID == 'BS10001' :
        return_root.find('PatientType').text = '2'
    return_root.find('GetId').text = body.find('INHOSP_NO').text
    return_root.find('PatientId').text = body.find('PAT_INDEX_NO').text
    return_root.find('PatientNumber').text = body.find('INHOSP_INDEX_NO').text
    return_root.find('InPatientId').text = body.find('INHOSP_NO').text
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
    InHospitalTime = body.find('ADMIT_DATE').text
    return_root.find('InHospitalTime').text = InHospitalTime
##    return_root.find('InHospitalTime').text = InHospitalTime[0:4] + '-' + InHospitalTime[4:6] + '-' + InHospitalTime[6:8] + ' ' + InHospitalTime[8:10] + ':' + InHospitalTime[10:12] + ':' + InHospitalTime[12:14]
    return_root.find('DeptCode').text = body.find('CURR_DEPT_CODE').text
    return_root.find('DeptName').text = body.find('CURR_DEPT_NAME').text
    return_root.find('WardCode').text = body.find('CURR_WARD_CODE').text
    return_root.find('WardName').text = body.find('CURR_WARD_NAME').text
    return_root.find('BedNo').text = body.find('CURR_BED_INDEX_NO').text
    return_xml = ET.tostring(root, encoding='utf-8')
    return return_xml.decode('utf-8')

def get_result_outpatient(str_xml):
    return_xml = '''
        <root>
            <record>
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
            </record>
        </root>
    '''
    root = ET.fromstring(return_xml)
    return_root = root.find('record')
    
    from_root = ET.fromstring(str_xml)
    FID = from_root.find('MessageHeader').find('Fid').text
    from_root = ET.fromstring(from_root.find('MsgInfo').find('Msg').text)
    body = from_root.find('body').find('row')
    return_root.find('PatientType').text = '1'
    return_root.find('GetId').text = body.find('OUTHOSP_NO').text
    return_root.find('DiagnosesID').text = body.find('OUTHOSP_DIAG_CODE').text
    return_root.find('Diagnoses').text = body.find('OUTHOSP_DIAG_NAME').text
    return_root.find('DeptName').text = body.find('VISIT_DEPT_NAME').text
    return_root.find('DeptCode').text = body.find('VISIT_DEPT_CODE').text
    return_root.find('PatientId').text = body.find('PAT_INDEX_NO').text
    return_root.find('InPatientId').text = body.find('OUTHOSP_NO').text
    return_root.find('PatientNumber').text = body.find('VISIT_CARD_NO').text
    return_root.find('PatientAge').text = body.find('AGE').text
    return_root.find('CompanyName').text = body.find('COMPANY').text
    return_root.find('MobilePhoneNo').text = body.find('CONTACT_PHONE_NO').text
    return_root.find('Address').text = body.find('CONTACT_ADDR').text
    return_root.find('MCardNo').text = body.find('MEDICARE_NO').text
    return_root.find('PatientName').text = body.find('PAT_NAME').text
    return_root.find('IdCardNo').text = body.find('ID_NUMBER').text
    return_root.find('TelePhoneNo').text = body.find('PHONE_NO').text
    return_root.find('PatientSex').text = body.find('PHYSI_SEX_CODE').text
    return_xml = ET.tostring(root, encoding='utf-8')
    return return_xml.decode('utf-8')

def param_of_method(str_xml):
    root = ET.fromstring(str_xml)

    interfaceparms = root.find('interfaceparms')
    patient_type = interfaceparms.find('patienttype').text
    if not patient_type is None:
        if patient_type == '2':
            return get_param_patient_inpatient(str_xml)
        else:
            return get_param_patient_outpatient(str_xml)

def result_of_method(str_xml):
    from_root = ET.fromstring(str_xml)
    FID = from_root.find('MessageHeader').find('Fid').text
    if not FID is None:
        if FID == 'BS10001':
            return get_result_inpatient(str_xml)
        else:
            return get_result_outpatient(str_xml)
    

# if __name__ == '__main__':
#     str_xml = '''
#        <ESBEntry>
#     <MessageHeader>
#         <Fid>BS10005</Fid>
#         <SourceSysCode>S02</SourceSysCode>
#         <TargetSysCode>S11</TargetSysCode>
#         <MsgDate>2017-09-01 10:24:44</MsgDate>
#     </MessageHeader>
#     <RequestOption>
#         <onceFlag>0</onceFlag>
#     </RequestOption>
#     <MsgCount>1</MsgCount>
#     <MsgInfo>
#         <Msg>
#             <![CDATA[<msg><body><row action="select"><OUTHOSP_DIAG_NAME>腹痛</OUTHOSP_DIAG_NAME><OUTHOSP_DIAG_CODE>R10.400</OUTHOSP_DIAG_CODE><VISIT_DEPT_NAME>眼科门诊</VISIT_DEPT_NAME><VISIT_DEPT_CODE>20020921</VISIT_DEPT_CODE><VISIT_DATE>2017-09-16 19:35:09</VISIT_DATE><PAT_INDEX_NO>7101263</PAT_INDEX_NO><OUTHOSP_NO>20170916000027</OUTHOSP_NO><VISIT_CARD_NO>0000002</VISIT_CARD_NO><DATE_BIRTH>1989-01-01</DATE_BIRTH><AGE>28岁</AGE><COMPANY/><CONTACT_PHONE_NO>1234567</CONTACT_PHONE_NO><CONTACT_ADDR>福建省福州市台江区@1</CONTACT_ADDR><MEDICARE_NO>0000002</MEDICARE_NO><PAT_NAME>邹宇</PAT_NAME><ID_NUMBER>无</ID_NUMBER><PHONE_NO>1234567</PHONE_NO><PHYSI_SEX_CODE>1</PHYSI_SEX_CODE></row></body></msg>]]>
#         </Msg>
#     </MsgInfo>
#     <RetInfo>
#         <RetCode>1</RetCode>
#         <RetCon>查询成功</RetCon>
#     </RetInfo>
# </ESBEntry>
#     '''
#     print(result_of_method(str_xml))

#     str_xml = '''
#        <interfacemessage>
#            <hospitalcode>hospitalcode</hospitalcode>
#            <interfacename>getpateintinfos</interfacename>
#            <interfaceparms>
#                <patienttype>1</patienttype>
#                <patientid>patientid</patientid>
#                <patientnumber>patientnumber</patientnumber>
#                <inpatientid>inpatientid</inpatientid>
#            </interfaceparms>
#        </interfacemessage>
#     '''
#     print(param_of_method(str_xml))
