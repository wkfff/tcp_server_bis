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

    Value = '<ESBEntry>'+'<AccessControl>'+'<UserName>'+ user_name +'</UserName>'+'<Password>'+ pass_word +'</Password>'+'<Fid>MS15001</Fid>'+'</AccessControl>'+'<MessageHeader>'+'<Fid>MS15001</Fid>'+'<SourceSysCode>'+ source_code +'</SourceSysCode>'+'<TargetSysCode>'+ target_code +'</TargetSysCode>'+'<MsgDate>'+ time.strftime("%Y-%m-%d%H:%M:%S") +'</MsgDate>'+'</MessageHeader>'+'<RequestOption>'+'<onceFlag/>'+'<startNum/>'+'<endNum/>'+'</RequestOption>'+'<MsgInfo>'
    Value = Value + '<query item="CHARGE_ITEM_INDEX_NO" compy="=" value="\'011010000101\' or 1= 1" splice="and"/>'
    Value = Value + '<query item="INVALID_FLAG" compy="=" value="\'0\'" splice="and"/>'
    Value = Value + '<order item="" sort=""/>'+'</MsgInfo>'+'</ESBEntry>'
    return Value

def result_of_method(str_xml):
    return_xml = '''
    <root>
        <ChargeItemId></ChargeItemId>
        <ChargeItemName></ChargeItemName>
        <SpellCode></SpellCode>
        <ChargePric></ChargePric>
        <ChargeAmount></ChargeAmount>
        <IncomeCode></IncomeCode>
        <OrganizationCode></OrganizationCode>
        <ExecPriceCode></ExecPriceCode>
        <Remark></Remark>
    </root>
'''
    return_root = ET.fromstring(return_xml)
    
    from_root = ET.fromstring(str_xml)
    from_root = ET.fromstring(from_root.find('MsgInfo').find('Msg').text)
    body = from_root.find('body').find('row')
    return_root.find('ChargeItemId').text = body.find('CHARGE_ITEM_CODE').text
    return_root.find('ChargeItemName').text = body.find('CHARGE_ITEM_NAME').text
    return_root.find('SpellCode').text = body.find('PINYIN_CODE').text
    return_root.find('ChargePric').text = body.find('UNIT_PRICE').text
    return_root.find('ChargeAmount').text = body.find('UNIT').text
    return_root.find('IncomeCode').text = body.find('ITEM_CATEG_CODE').text
    return_root.find('OrganizationCode').text = body.find('SPECIFICATIONS').text
    return_root.find('ExecPriceCode').text = body.find('INVOICE_CATEG_CODE').text
    return_root.find('Remark').text = body.find('DESCR').text
    return_xml = ET.tostring(return_root, encoding='utf-8')
    return return_xml.decode('utf-8')

##if __name__ == '__main__':
##    str_xml = '''
##        <ESBEntry>
##    <MessageHeader>
##        <Fid>MS15001</Fid>
##        <SourceSysCode>S03</SourceSysCode>
##        <TargetSysCode>S11</TargetSysCode>
##        <MsgDate>2015-12-1014:45:36</MsgDate>
##    </MessageHeader>
##    <RequestOption>
##        <onceFlag/>
##        <startNum/>
##        <endNum/>
##    </RequestOption>
##    <MsgCount>1</MsgCount>
##    <MsgInfo>
##        <Msg>
##            <![CDATA[<msg><body><row action="select"><WUBI_CODE/><PINYIN_CODE/><UPDATE_DATE/><RECORD_DATE>20170419155605</RECORD_DATE><INVOICE_CATEG_NAME>其它</INVOICE_CATEG_NAME><INVOICE_CATEG_CODE>U</INVOICE_CATEG_CODE><INVALID_FLAG>0</INVALID_FLAG><SPECIFICATIONS/><ABBREV/><NOTE/><ITEM_CATEG_NAME>其它</ITEM_CATEG_NAME><ITEM_CATEG_CODE>U</ITEM_CATEG_CODE><UNIT_PRICE>1.3000</UNIT_PRICE><UNIT>次</UNIT><DESCR>1.3</DESCR><CHARGE_ITEM_NAME>挂号费</CHARGE_ITEM_NAME><CHARGE_ITEM_CODE>011010000101</CHARGE_ITEM_CODE><CHARGE_ITEM_INDEX_NO>011010000101</CHARGE_ITEM_INDEX_NO></row></body></msg>]]>
##        </Msg>
##    </MsgInfo>
##    <RetInfo>
##        <RetCode>1</RetCode>
##        <RetCon>查询成功</RetCon>
##    </RetInfo>
##</ESBEntry>
##    '''
##    print(result_of_method(str_xml))
##
##    str_xml = '''
##        <interfacemessage>
##            <hospitalcode>hospitalcode</hospitalcode>
##            <interfacename>getchargeiteminfos</interfacename>
##            <interfaceparms>none</interfaceparms>
##        </interfacemessage>
##    '''
##    print(param_of_method(str_xml))
