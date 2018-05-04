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

    Value = '<ESBEntry>'+'<AccessControl>'+'<UserName>'+ user_name +'</UserName>'+'<Password>'+ pass_word +'</Password>'+'<Fid>MS02003</Fid>'+'</AccessControl>'+'<MessageHeader>'+'<Fid>MS02003</Fid>'+'<SourceSysCode>'+ source_code +'</SourceSysCode>'+'<TargetSysCode>'+ target_code +'</TargetSysCode>'+'<MsgDate>'+ time.strftime("%Y-%m-%d%H:%M:%S") +'</MsgDate>'+'</MessageHeader>'+'<RequestOption>'+'<onceFlag/>'+'<startNum/>'+'<endNum/>'+'</RequestOption>'+'<MsgInfo>'
    Value = Value + '<query item="STAFF_INDEX_NO" compy="=" value="\'100\' or 1=1" splice="and"/>'
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
        key_element = ET.SubElement(data_element, 'User_Id') 
        key_element.text = body.find('STAFF_CODE').text
        key_element.set('key', 'true')
        ET.SubElement(data_element, 'User_Phone').text = body.find('PHONE_NO').text
        ET.SubElement(data_element, 'User_No').text = body.find('LOGIN_NAME').text
        ET.SubElement(data_element, 'User_Sex').text = body.find('PHYSI_SEX_CODE').text
        ET.SubElement(data_element, 'SpellCode').text = body.find('PINYIN_CODE').text
        ET.SubElement(data_element, 'User_Name').text = body.find('STAFF_NAME').text
        ET.SubElement(data_element, 'User_Email').text = body.find('EMAIL').text
        ET.SubElement(data_element, 'User_Dept').text = body.find('SUBOR_DEPT_CODE').text
        ET.SubElement(data_element, 'User_Level').text = body.find('STAFF_CATEG_CODE').text
        ET.SubElement(data_element, 'User_Remark').text = body.find('TITLE_LEVEL_NAME').text

    return_xml = ET.tostring(return_root, encoding='utf-8')
    return return_xml.decode('utf-8')

# if __name__ == '__main__':
#    str_xml = '''
#        <ESBEntry>
#   <MessageHeader>
#     <Fid>MS02003</Fid>
#     <SourceSysCode>S03</SourceSysCode>
#     <TargetSysCode>S11</TargetSysCode>
#     <MsgDate>2015-12-1014:45:36</MsgDate>
#   </MessageHeader>
#   <RequestOption>
#     <onceFlag/>
#     <startNum/>
#     <endNum/>
#   </RequestOption>
#   <MsgCount>2</MsgCount>
#   <MsgInfo>
#     <Msg>
#       <![CDATA[<msg><body><row action="select"><STAFF_CODE>1001</STAFF_CODE><PHONE_NO>12345678901</PHONE_NO><PHYSI_SEX_CODE>1</PHYSI_SEX_CODE><PINYIN_CODE>lxx</PINYIN_CODE><STAFF_NAME>林新新</STAFF_NAME><EMAIL>qq</EMAIL><SUBOR_DEPT_NAME>骨科</SUBOR_DEPT_NAME><SUBOR_DEPT_CODE>8</SUBOR_DEPT_CODE><TITLE_LEVEL_NAME/><STAFF_CATEG_NAME>医生</STAFF_CATEG_NAME><STAFF_CATEG_CODE>6</STAFF_CATEG_CODE><LOGIN_NAME>lx</LOGIN_NAME></row></body></msg>]]>
#     </Msg>
#     <Msg>
#       <![CDATA[<msg><body><row action="select"><STAFF_CODE>1004</STAFF_CODE><PHONE_NO>12345678901</PHONE_NO><PHYSI_SEX_CODE>1</PHYSI_SEX_CODE><PINYIN_CODE>lcx</PINYIN_CODE><STAFF_NAME>林彩霞</STAFF_NAME><EMAIL>qq</EMAIL><SUBOR_DEPT_NAME>骨科</SUBOR_DEPT_NAME><SUBOR_DEPT_CODE>8</SUBOR_DEPT_CODE><TITLE_LEVEL_NAME/><STAFF_CATEG_NAME>医生</STAFF_CATEG_NAME><STAFF_CATEG_CODE>6</STAFF_CATEG_CODE><LOGIN_NAME>lcx</LOGIN_NAME></row></body></msg>]]>
#     </Msg>
#   </MsgInfo>
#   <RetInfo>
#     <RetCode>1</RetCode>
#     <RetCon>查询成功</RetCon>
#   </RetInfo>
# </ESBEntry>
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
