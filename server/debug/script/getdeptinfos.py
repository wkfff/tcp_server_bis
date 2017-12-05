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
    cf.read(os.getcwd()  + '\TCPServer.ini')

    user_name = cf.get('ESBEntry', 'UserName')
    pass_word = cf.get('ESBEntry', 'PassWord')
    source_code = cf.get('ESBEntry', 'SourceSysCode')
    target_code = cf.get('ESBEntry', 'TargetSysCode')

    Value = '<ESBEntry>'+'<AccessControl>'+'<UserName>'+ user_name +'</UserName>'+'<Password>'+ pass_word +'</Password>'+'<Fid>MS02001</Fid>'+'</AccessControl>'+'<MessageHeader>'+'<Fid>MS02001</Fid>'+'<SourceSysCode>'+ source_code +'</SourceSysCode>'+'<TargetSysCode>'+ target_code +'</TargetSysCode>'+'<MsgDate>'+ time.strftime("%Y-%m-%d%H:%M:%S") +'</MsgDate>'+'</MessageHeader>'+'<RequestOption>'+'<onceFlag/>'+'<startNum/>'+'<endNum/>'+'</RequestOption>'+'<MsgInfo>'
    Value = Value + '<query item="DEPT_INDEX_NO" compy="=" value="\'100\' or 1=1" splice="and"/>'
    Value = Value + '<query item="INVALID_FLAG" compy="=" value="\'0\'" splice="and"/>'
    Value = Value + '<order item="" sort=""/>'+'</MsgInfo>'+'</ESBEntry>'
    return Value

def result_of_method(str_xml):
    
    return_root = ET.Element('root')
    from_root = ET.fromstring(str_xml)
    first_element = from_root.find('MsgInfo')

    for child_element in first_element:
        temp_element = ET.fromstring(child_element.text)
        body = temp_element.find('body').find('row')
        data_element = ET.SubElement(return_root, 'record')
        key_element = ET.SubElement(data_element, 'DeptCode') 
        key_element.text = body.find('DEPT_CODE').text
        key_element.set('key', 'true')
        ET.SubElement(data_element, 'DeptName').text = body.find('DEPT_NAME').text
        ET.SubElement(data_element, 'SpellCode').text = body.find('PINYIN_CODE').text
        ET.SubElement(data_element, 'Remark').text = body.find('DEPT_INDEX_NO').text

    return_xml = ET.tostring(return_root, encoding='utf-8')
    return return_xml.decode('utf-8')

# if __name__ == '__main__':
#    str_xml = '''
#        <ESBEntry>
#   <MessageHeader>
#     <Fid>MS02001</Fid>
#     <SourceSysCode>S03</SourceSysCode>
#     <TargetSysCode>S11</TargetSysCode>
#     <MsgDate>2015-12-1014:45:36</MsgDate>
#   </MessageHeader>
#   <RequestOption>
#     <onceFlag/>
#     <startNum/>
#     <endNum/>
#   </RequestOption>
#   <MsgCount>270</MsgCount>
#   <MsgInfo>
#     <Msg>
#       <![CDATA[<msg><body><row action="select"><SUPERIOR_DEPT_CODE/><DEPT_CATEG_NAME/><DEPT_CATEG_CODE/><MS_DEPT_FLAG>2</MS_DEPT_FLAG><OI_DEPT_FLAG>1</OI_DEPT_FLAG><CLINIC_DEPT_FLAG>0</CLINIC_DEPT_FLAG><WUBI_CODE/><PINYIN_CODE>TTMZ</PINYIN_CODE><INPUT_CODE/><DEPT_ALIAS>疼痛门诊</DEPT_ALIAS><DEPT_NAME>疼痛门诊</DEPT_NAME><DEPT_CODE>1001</DEPT_CODE><DEPT_INDEX_NO>670057896411013120</DEPT_INDEX_NO><SUBOR_HOSPITAL_DISTRICT>从属院区</SUBOR_HOSPITAL_DISTRICT><INVALID_FLAG>0</INVALID_FLAG><DESCR/><DEPT_PHONE_NO/><DEPT_GEOGRAPHY_PLACE/><OPEN_BEDS_NUM/><SUPERIOR_DEPT_NAME/></row></body></msg>]]>
#     </Msg>
#     <Msg>
#       <![CDATA[<msg><body><row action="select"><SUPERIOR_DEPT_CODE/><DEPT_CATEG_NAME/><DEPT_CATEG_CODE/><MS_DEPT_FLAG/><OI_DEPT_FLAG/><CLINIC_DEPT_FLAG>0</CLINIC_DEPT_FLAG><WUBI_CODE/><PINYIN_CODE>GDNKMZ</PINYIN_CODE><INPUT_CODE/><DEPT_ALIAS>肝胆内科门诊</DEPT_ALIAS><DEPT_NAME>肝胆内科门诊</DEPT_NAME><DEPT_CODE>100</DEPT_CODE><DEPT_INDEX_NO>671837393514799104</DEPT_INDEX_NO><SUBOR_HOSPITAL_DISTRICT/><INVALID_FLAG>0</INVALID_FLAG><DESCR/><DEPT_PHONE_NO/><DEPT_GEOGRAPHY_PLACE/><OPEN_BEDS_NUM/><SUPERIOR_DEPT_NAME/></row></body></msg>]]>
#     </Msg>    
#      </MsgInfo>
#   <RetInfo>
#     <RetCode>1</RetCode>
#     <RetCon>查询成功</RetCon>
#   </RetInfo>
# </ESBEntry>
#    '''
#    print(result_of_method(str_xml))

#    str_xml = '''
#        <interfacemessage>
#            <hospitalcode>hospitalcode</hospitalcode>
#            <interfacename>getchargeiteminfos</interfacename>
#            <interfaceparms>none</interfaceparms>
#        </interfacemessage>
#    '''
#    print(param_of_method(str_xml))
