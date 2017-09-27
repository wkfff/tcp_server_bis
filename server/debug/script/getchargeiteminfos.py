# -*- coding: UTF-8 -*-
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET
import time
import configparser 
import os
from Txlogger import logger

def param_of_method(str_xml):
    cf = configparser.ConfigParser()

    # cf.read(os.path.dirname(os.getcwd()) + '\TCPServer.ini')
    cf.read(os.getcwd() + '\TCPServer.ini')

    user_name = cf.get('ESBEntry', 'UserName')
    pass_word = cf.get('ESBEntry', 'PassWord')
    source_code = cf.get('ESBEntry', 'SourceSysCode')
    target_code = cf.get('ESBEntry', 'TargetSysCode')

    Value = '<ESBEntry>'+'<AccessControl>'+'<UserName>'+ user_name +'</UserName>'+'<Password>'+ pass_word +'</Password>'+'<Fid>MS15001</Fid>'+'</AccessControl>'+'<MessageHeader>'+'<Fid>MS15001</Fid>'+'<SourceSysCode>'+ source_code +'</SourceSysCode>'+'<TargetSysCode>'+ target_code +'</TargetSysCode>'+'<MsgDate>'+ time.strftime("%Y-%m-%d %H:%M:%S") +'</MsgDate>'+'</MessageHeader>'+'<RequestOption>'+'<onceFlag/>'+'<startNum/>'+'<endNum/>'+'</RequestOption>'+'<MsgInfo>'
    Value = Value + '<query item="CHARGE_ITEM_CODE" compy="=" value="\'011010000101\' or 1= 1" splice="and"/>'
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
        key_element = ET.SubElement(data_element, 'ChargeItemId') 
        key_element.text = body.find('CHARGE_ITEM_CODE').text
        key_element.set('key', 'true')
        ET.SubElement(data_element, 'ChargeItemName').text = body.find('CHARGE_ITEM_NAME').text
        ET.SubElement(data_element, 'SpellCode').text = body.find('PINYIN_CODE').text
        ET.SubElement(data_element, 'ChargePrice').text = body.find('UNIT_PRICE').text
        ET.SubElement(data_element, 'ChargeAmount').text = body.find('UNIT').text
        ET.SubElement(data_element, 'IncomeCode').text = body.find('ITEM_CATEG_CODE').text
        ET.SubElement(data_element, 'OrganizationCode').text = body.find('SPECIFICATIONS').text
        ET.SubElement(data_element, 'Remark').text = body.find('DESCR').text
        
    return_xml = ET.tostring(return_root, encoding='utf-8')
    return return_xml.decode('utf-8')

# if __name__ == '__main__':
#     str_xml = '''
#        <ESBEntry>
#    <MessageHeader>
#        <Fid>MS15001</Fid>
#        <SourceSysCode>S03</SourceSysCode>
#        <TargetSysCode>S11</TargetSysCode>
#        <MsgDate>2015-12-1014:45:36</MsgDate>
#    </MessageHeader>
#    <RequestOption>
#        <onceFlag/>
#        <startNum/>
#        <endNum/>
#    </RequestOption>
#    <MsgCount>1</MsgCount>
#    <MsgInfo>
#        <Msg>
#            <![CDATA[<msg><body><row action="select"><WUBI_CODE/><PINYIN_CODE/><UPDATE_DATE/><RECORD_DATE>20170419155605</RECORD_DATE><INVOICE_CATEG_NAME>其它</INVOICE_CATEG_NAME><INVOICE_CATEG_CODE>U</INVOICE_CATEG_CODE><INVALID_FLAG>0</INVALID_FLAG><SPECIFICATIONS/><ABBREV/><NOTE/><ITEM_CATEG_NAME>其它</ITEM_CATEG_NAME><ITEM_CATEG_CODE>U</ITEM_CATEG_CODE><UNIT_PRICE>1.3000</UNIT_PRICE><UNIT>次</UNIT><DESCR>1.3</DESCR><CHARGE_ITEM_NAME>挂号费</CHARGE_ITEM_NAME><CHARGE_ITEM_CODE>011010000101</CHARGE_ITEM_CODE><CHARGE_ITEM_INDEX_NO>011010000101</CHARGE_ITEM_INDEX_NO></row></body></msg>]]>
#        </Msg>
#        <Msg>
#     <![CDATA[<msg><body><row action="select"><CHARGE_ITEM_INDEX_NO>950008000029</CHARGE_ITEM_INDEX_NO><WUBI_CODE/><PINYIN_CODE/><UPDATE_DATE/><RECORD_DATE>2017-04-19 15:56:05</RECORD_DATE><INVALID_FLAG>0</INVALID_FLAG><SPECIFICATIONS/><ABBREV/><NOTE/><ITEM_CATEG_NAME/><ITEM_CATEG_CODE/><UNIT_PRICE>4.5000</UNIT_PRICE><UNIT>个</UNIT><DESCR>4.5</DESCR><CHARGE_ITEM_NAME>一次性使用吸痰器[如皋恒康]</CHARGE_ITEM_NAME><CHARGE_ITEM_CODE>950008000029</CHARGE_ITEM_CODE></row></body></msg>]]>
# </Msg>
# <Msg>
#     <![CDATA[<msg><body><row action="select"><CHARGE_ITEM_INDEX_NO>950008000030</CHARGE_ITEM_INDEX_NO><WUBI_CODE/><PINYIN_CODE/><UPDATE_DATE/><RECORD_DATE>2017-04-19 15:56:05</RECORD_DATE><INVALID_FLAG>0</INVALID_FLAG><SPECIFICATIONS/><ABBREV/><NOTE/><ITEM_CATEG_NAME/><ITEM_CATEG_CODE/><UNIT_PRICE>7.5000</UNIT_PRICE><UNIT>根</UNIT><DESCR>7.5</DESCR><CHARGE_ITEM_NAME>口咽通气管(中空式红色10cm)[南通协和]</CHARGE_ITEM_NAME><CHARGE_ITEM_CODE>950008000030</CHARGE_ITEM_CODE></row></body></msg>]]>
# </Msg>
# <Msg>
#     <![CDATA[<msg><body><row action="select"><CHARGE_ITEM_INDEX_NO>950008000031</CHARGE_ITEM_INDEX_NO><WUBI_CODE/><PINYIN_CODE/><UPDATE_DATE/><RECORD_DATE>2017-04-19 15:56:05</RECORD_DATE><INVALID_FLAG>0</INVALID_FLAG><SPECIFICATIONS/><ABBREV/><NOTE/><ITEM_CATEG_NAME/><ITEM_CATEG_CODE/><UNIT_PRICE>1.2000</UNIT_PRICE><UNIT>支</UNIT><DESCR>1.2</DESCR><CHARGE_ITEM_NAME>一次性吸痰管((儿童)6#,8#,10#)[麦克林]</CHARGE_ITEM_NAME><CHARGE_ITEM_CODE>950008000031</CHARGE_ITEM_CODE></row></body></msg>]]>
# </Msg>
# <Msg>
#     <![CDATA[<msg><body><row action="select"><CHARGE_ITEM_INDEX_NO>950008000033</CHARGE_ITEM_INDEX_NO><WUBI_CODE/><PINYIN_CODE/><UPDATE_DATE/><RECORD_DATE>2017-04-19 15:56:05</RECORD_DATE><INVALID_FLAG>0</INVALID_FLAG><SPECIFICATIONS/><ABBREV/><NOTE/><ITEM_CATEG_NAME/><ITEM_CATEG_CODE/><UNIT_PRICE>2.8800</UNIT_PRICE><UNIT>支</UNIT><DESCR>2.88</DESCR><CHARGE_ITEM_NAME>一次性使用吸痰包(F8/F10/F14)[苏州麦克林](ICU专用)</CHARGE_ITEM_NAME><CHARGE_ITEM_CODE>950008000033</CHARGE_ITEM_CODE></row></body></msg>]]>
# </Msg>
# <Msg>
#     <![CDATA[<msg><body><row action="select"><CHARGE_ITEM_INDEX_NO>950008000036</CHARGE_ITEM_INDEX_NO><WUBI_CODE/><PINYIN_CODE/><UPDATE_DATE/><RECORD_DATE>2017-04-19 15:56:05</RECORD_DATE><INVALID_FLAG>0</INVALID_FLAG><SPECIFICATIONS/><ABBREV/><NOTE/><ITEM_CATEG_NAME/><ITEM_CATEG_CODE/><UNIT_PRICE>6.5000</UNIT_PRICE><UNIT>支</UNIT><DESCR>6.5</DESCR><CHARGE_ITEM_NAME>一次性使用吸引连接管(3m)[日月星]</CHARGE_ITEM_NAME><CHARGE_ITEM_CODE>950008000036</CHARGE_ITEM_CODE></row></body></msg>]]>
# </Msg>
# <Msg>
#     <![CDATA[<msg><body><row action="select"><CHARGE_ITEM_INDEX_NO>950009000016</CHARGE_ITEM_INDEX_NO><WUBI_CODE/><PINYIN_CODE/><UPDATE_DATE/><RECORD_DATE>2017-04-19 15:56:05</RECORD_DATE><INVALID_FLAG>0</INVALID_FLAG><SPECIFICATIONS/><ABBREV/><NOTE/><ITEM_CATEG_NAME/><ITEM_CATEG_CODE/><UNIT_PRICE>10.2000</UNIT_PRICE><UNIT>条</UNIT><DESCR>10.2</DESCR><CHARGE_ITEM_NAME>一次性使用引流管（潘氏管各号）[如皋恒康]</CHARGE_ITEM_NAME><CHARGE_ITEM_CODE>950009000016</CHARGE_ITEM_CODE></row></body></msg>]]>
# </Msg>
#    </MsgInfo>
#    <RetInfo>
#        <RetCode>1</RetCode>
#        <RetCon>查询成功</RetCon>
#    </RetInfo>
# </ESBEntry>
#    '''
#     print(result_of_method(str_xml))
#
#    str_xml = '''
#        <interfacemessage>
#            <hospitalcode>hospitalcode</hospitalcode>
#            <interfacename>getchargeiteminfos</interfacename>
#            <interfaceparms>none</interfaceparms>
#        </interfacemessage>
#    '''
#    print(param_of_method(str_xml))
