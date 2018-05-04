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

    Value = '<ESBEntry>'+'<AccessControl>'+'<UserName>'+ user_name +'</UserName>'+'<Password>'+ pass_word +'</Password>'+'<Fid>MS02002</Fid>'+'</AccessControl>'+'<MessageHeader>'+'<Fid>MS02002</Fid>'+'<SourceSysCode>'+ source_code +'</SourceSysCode>'+'<TargetSysCode>'+ target_code +'</TargetSysCode>'+'<MsgDate>'+ time.strftime("%Y-%m-%d%H:%M:%S") +'</MsgDate>'+'</MessageHeader>'+'<RequestOption>'+'<onceFlag/>'+'<startNum/>'+'<endNum/>'+'</RequestOption>'+'<MsgInfo>'
    Value = Value + '<query item="WARD_INDEX_NO" compy="=" value="\'100\' or 1=1" splice="and"/>'
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
        key_element = ET.SubElement(data_element, 'WardCode') 
        key_element.text = body.find('WARD_CODE').text
        key_element.set('key', 'true')
        ET.SubElement(data_element, 'WardName').text = body.find('WARD_NAME').text
        ET.SubElement(data_element, 'SpellCode').text = body.find('PINYIN_CODE').text
        ET.SubElement(data_element, 'Remark').text = body.find('SUBOR_DEPT_CODE').text
        ET.SubElement(data_element, 'Registered').text = '0'

    return_xml = ET.tostring(return_root, encoding='utf-8')
    return return_xml.decode('utf-8')

# if __name__ == '__main__':
#    str_xml = '''
#        <ESBEntry>
#   <MessageHeader>
#     <Fid>MS02002</Fid>
#     <SourceSysCode>S03</SourceSysCode>
#     <TargetSysCode>S11</TargetSysCode>
#     <MsgDate>2017-07-1409:59:36</MsgDate>
#   </MessageHeader>
#   <RequestOption>
#     <onceFlag/>
#     <startNum/>
#     <endNum/>
#   </RequestOption>
#   <MsgCount>1</MsgCount>
#   <MsgInfo>
#     <Msg>
#       <![CDATA[<msg><body><row action="select"><SUBOR_DEPT_NAME>骨科</SUBOR_DEPT_NAME><SUBOR_DEPT_CODE>100</SUBOR_DEPT_CODE><WUBI_CODE>gkyq</WUBI_CODE><PINYIN_CODE>gkyq</PINYIN_CODE><WARD_NAME>王者微信区</WARD_NAME><WARD_CODE>1000</WARD_CODE><WARD_INDEX_NO>1000</WARD_INDEX_NO></row></body></msg>]]>
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
